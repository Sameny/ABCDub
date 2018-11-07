//
//  ABCAudioRecord.m
//  PlayerWithDub
//
//  Created by 泽泰 舒 on 2018/10/31.
//  Copyright © 2018年 泽泰 舒. All rights reserved.
//

#import "AlertHelper.h"

#import <AVFoundation/AVFoundation.h>
#import "ABCAudioRecorder.h"

@interface ABCAudioRecorder () <AVAudioRecorderDelegate>

@property (nonatomic, strong) AVAudioRecorder *audioRecorder;
@property (nonatomic, copy) ABCMediaRecordCompletion recordCompletion;

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

- (void)startRecordWithUrl:(NSString *)url duration:(NSTimeInterval)duration completion:(ABCMediaRecordCompletion)completion {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayAndRecord error:nil];
        NSError *sessionError;
        [[AVAudioSession sharedInstance] setActive:YES error:&sessionError];
        
        self.audioRecorder = [self audioRecorderWithUrl:url settings:[self defaultAduioRecorderSettings]];
        self.audioRecorder.delegate = self;
        
        BOOL success = NO;
        if ([self.audioRecorder prepareToRecord]) {
            success = [self.audioRecorder recordForDuration:duration];
        }
        if (success) {
            self.recordCompletion = completion;
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
    [ABCAudioRecorder authorizeRecorderWithCompletion:^(BOOL permit) {
        if (permit) {
            [[ABCAudioRecorder sharedInstance] startRecordWithUrl:url duration:duration completion:completion];
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
