//
//  ABCAudioRecord.m
//  PlayerWithDub
//
//  Created by 泽泰 舒 on 2018/10/31.
//  Copyright © 2018年 泽泰 舒. All rights reserved.
//

#import "AlertHelper.h"
#import "GCDTimer.h"

#import <AVFoundation/AVFoundation.h>
#import "ABCAudioRecorder.h"

@interface ABCAudioRecorder () <AVAudioRecorderDelegate>

@property (nonatomic, strong) AVAudioRecorder *audioRecorder;
@property (nonatomic, copy) ABCMediaRecordCompletion recordCompletion;
@property (nonatomic, copy) ABCMediaRecordProgress progress;
@property (nonatomic, strong) GCDTimer *progressTimer;

@end

NSInteger const kABCDefaultSampleRate = 22050;

static ABCAudioRecorder *sharedABCAudioRecorder = nil;

@implementation ABCAudioRecorder

+ (instancetype)sharedInstance {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedABCAudioRecorder = [[ABCAudioRecorder alloc] init];
    });
    return sharedABCAudioRecorder;
}

- (void)startRecordWithUrl:(NSString *)url duration:(NSTimeInterval)duration progress:(ABCMediaRecordProgress)progress completion:(ABCMediaRecordCompletion)completion {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        self.audioRecorder = [self audioRecorderWithUrl:url settings:[self defaultAduioRecorderSettings]];
        self.audioRecorder.delegate = self;
        if (progress) {
            self.audioRecorder.meteringEnabled = YES;
        }
        
        BOOL success = NO;
        if ([self.audioRecorder prepareToRecord]) {
            AVAudioSession *audioSession = [AVAudioSession sharedInstance];
            [audioSession setCategory:AVAudioSessionCategoryPlayAndRecord error:nil];
            [audioSession overrideOutputAudioPort:AVAudioSessionPortOverrideSpeaker error:nil]; // 不加这句，录出来的声音很小，但是之后插入耳机会无效，所以后面录音完成后在需要耳机功能的地方设置为AVAudioSessionPortOverrideNone
            NSError *sessionError;
            [audioSession setActive:YES error:&sessionError];
            success = [self.audioRecorder recordForDuration:duration];
        }
        if (success) {
            self.recordCompletion = completion;
            self.progress = progress;
            [self initProgressTimer];
            [self.progressTimer fire];
        }
        else {
            [self resetAudioRecorder];
            if (completion) {
                completion(NO, nil);
            }
        }
    });
}

- (void)stopRecordWithDeleteRecording:(BOOL)delete {
    if (self.audioRecorder) {
        [self.audioRecorder stop];
        if (delete) {
            [self.audioRecorder deleteRecording];
        }
        [self resetAudioRecorder];
    }
}

- (void)resetAudioRecorder {
    [self releaseProgressTimer];
    [[AVAudioSession sharedInstance] overrideOutputAudioPort:AVAudioSessionPortOverrideNone error:nil];
    self.audioRecorder.delegate = nil;
    self.audioRecorder = nil;
}

- (NSDictionary *)defaultAduioRecorderSettings {
    NSMutableDictionary * settings = @{}.mutableCopy;
    [settings setObject:@(kABCDefaultSampleRate) forKey:AVSampleRateKey];
    [settings setObject:@(kAudioFormatLinearPCM) forKey:AVFormatIDKey];
    [settings setObject:@2 forKey:AVNumberOfChannelsKey];//iPnone只有一个麦克风，一个通道已经足够了。但是后期转mp3需要双通道，所以设置为2
    [settings setObject:@16 forKey:AVLinearPCMBitDepthKey];//采样的位数
    [settings setObject:@(AVAudioQualityHigh) forKey:AVEncoderAudioQualityKey]; // 录音质量
    return settings;
}

- (AVAudioRecorder *)audioRecorderWithUrl:(NSString *)url settings:(NSDictionary *)settings {
    if (!url || url.length == 0) {
        return nil;
    }
    if ([[NSFileManager defaultManager] fileExistsAtPath:url]) {
        [[NSFileManager defaultManager] removeItemAtPath:url error:nil];
    }
    NSError *err;
    AVAudioRecorder *audioRecorder = [[AVAudioRecorder alloc] initWithURL:[NSURL fileURLWithPath:url] settings:settings error:&err];
    if (err) {
        NSLog(@"create autio recorder occur error : \n%@", err);
    }
    return audioRecorder;
}

- (void)initProgressTimer {
    if (self.progress) {
        __weak typeof(self) weakself = self;
        self.progressTimer = [[GCDTimer alloc] initWithQueue:dispatch_get_main_queue() scheduleTimeInterval:0.1 block:^{
            [weakself detectionVoicePower];
        }];
    }
}

- (void)releaseProgressTimer {
    if (self.progressTimer) {
        [self.progressTimer invalidate];
    }
}

- (void)detectionVoicePower {
    if (self.audioRecorder) {
        [self.audioRecorder updateMeters];//刷新音量数据
        
        //获取音量的平均值  [recorder averagePowerForChannel:0];
        //音量的最大值  [recorder peakPowerForChannel:0];
        float power = [self.audioRecorder peakPowerForChannel:0];
        float average = [self.audioRecorder averagePowerForChannel:0];
        double lowPassResults = pow(10, (0.1 * power)); // 获取峰值
        self.progress(power, average);
        DebugLog(@"*** average : %.3f\n***power : %.3f\n***lowPassResults : %.3f\n", average, power, lowPassResults);
    }
}

#pragma mark - AVAudioRecorderDelegate
- (void)audioRecorderDidFinishRecording:(AVAudioRecorder *)recorder successfully:(BOOL)flag {
    [self resetAudioRecorder];
    if (self.recordCompletion) {
        self.recordCompletion(flag, nil);
    }
}

- (void)audioRecorderEncodeErrorDidOccur:(AVAudioRecorder *)recorder error:(NSError *)error {
    [self resetAudioRecorder];
    if (self.recordCompletion) {
        self.recordCompletion(NO, error);
    }
}

#pragma mark - class method
+ (void)startRecordWithUrl:(NSString *)url duration:(NSTimeInterval)duration completion:(ABCMediaRecordCompletion)completion {
    [ABCAudioRecorder startRecordWithUrl:url duration:duration progress:nil completion:completion];
}

+ (void)startRecordWithUrl:(NSString *)url duration:(NSTimeInterval)duration progress:(ABCMediaRecordProgress)progress completion:(ABCMediaRecordCompletion)completion {
    [ABCAudioRecorder authorizeRecorderWithCompletion:^(BOOL permit) {
        if (permit) {
            [[ABCAudioRecorder sharedInstance] startRecordWithUrl:url duration:duration progress:progress completion:completion];
        }
        else {
            if (completion) {
                completion(NO, nil);
            }
        }
    }];
}

+ (void)authorizeRecorderWithCompletion:(void(^)(BOOL permit))completion {
    switch ([AVAudioSession sharedInstance].recordPermission) {
        case AVAudioSessionRecordPermissionUndetermined:{
            [[AVAudioSession sharedInstance] requestRecordPermission:^(BOOL granted) {
                if (completion) {
                    completion(granted);
                }
            }];
        }
            break;
        case AVAudioSessionRecordPermissionDenied: {
            //TODO: alert for open microphone privileges
            [AlertHelper showAppSettingAlertViewWithTitle:@"要使用语音录制功能，需要打开麦克风。" message:@"是否立即开启麦克风权限" doneTitle:@"Comfirm" cancelTitle:@"Cancel"];
            if (completion) {
                completion(NO);
            }
        }
            break;
        case AVAudioSessionRecordPermissionGranted:{
            if (completion) {
                completion(YES);
            }
        }
            break;
    }
}

+ (void)stopRecordWithDeleteRecording:(BOOL)delete {
    [[ABCAudioRecorder sharedInstance] stopRecordWithDeleteRecording:delete];
}

@end
