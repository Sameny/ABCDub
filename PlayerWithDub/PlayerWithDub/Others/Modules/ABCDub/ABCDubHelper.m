//
//  ABCDubHelper.m
//  PlayerWithDub
//
//  Created by 泽泰 舒 on 2018/11/6.
//  Copyright © 2018年 泽泰 舒. All rights reserved.
//

#import "MP3Endocder.h"
#import "ABCMediaComposeUtil.h"
#import "ABCAudioRecorder.h"
#import "ABCDubFileManager.h"
#import "LocalFileManager.h"

#import "ABCCaptionSegment.h"
#import "ABCDubHelper.h"

@interface ABCDubHelper ()

@property (nonatomic, strong) MP3Endocder *encoder;

@end

static ABCDubHelper *sharedDubHepler;
@implementation ABCDubHelper

+ (instancetype)sharedInstance {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedDubHepler = [[ABCDubHelper alloc] init];
    });
    return sharedDubHepler;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        
    }
    return self;
}

- (void)recordAudioWithResourceId:(NSString *)resourceId mp3FileName:(NSString *)mp3FileName duration:(NSTimeInterval)duration completion:(ABCURLHandler)completion {
    NSString *mp3FilePath = [ABCDubFileManager mp3FilePathWithSubDirectory:resourceId fileName:mp3FileName];
    NSString *cafFileName = [[mp3FileName stringByDeletingPathExtension] stringByAppendingPathExtension:@"caf"];
    NSString *cafFilePath = [ABCDubFileManager cafFilePathWithSubDirectory:resourceId fileName:cafFileName];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        // 开始录音
        [ABCAudioRecorder startRecordWithUrl:cafFilePath duration:duration completion:^(BOOL success, NSError * _Nullable err) {
            if (success) {
                // 开始转码为mp3
                MP3EncodedRequest *request = [[MP3EncodedRequest alloc] initWithPCMFilePath:cafFilePath destionationFilePath:mp3FilePath];
                [self.encoder encodeMP3FileWithPCMFilePath:request completion:^(BOOL success, NSError * _Nullable error) {
                    // 清除caf文件
                    [LocalFileManager removeLocalFileAtPath:cafFilePath];
                    if (success) {
                        if (completion) {
                            dispatch_async(dispatch_get_main_queue(), ^{
                                completion([NSURL fileURLWithPath:mp3FilePath], nil);
                            });
                        }
                    }
                    else {
                        if (completion) {
                            dispatch_async(dispatch_get_main_queue(), ^{
                                completion(nil, err);
                            });
                        }
                    }
                }];
            }
            else {
                // 清除caf文件
                [LocalFileManager removeLocalFileAtPath:cafFilePath];
                if (completion) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        completion(nil, err);
                    });
                }
            }
        }];
    });
}

- (void)composeWithResourceId:(NSString *)resourceId subAudioInfos:(NSArray <ABCCaptionSegment *>*)audioInfos completion:(ABCURLHandler)completion {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        /* TODO: 根据sourceId来获取视频和音频的url ,暂时写死 */
        ABCMediaComposeUnit *videoUnit = [self videoUnitWithResourceId:resourceId];
        ABCMediaComposeUnit *audioUnit = [self baseAudioUnitWithResourceId:resourceId];
        
        NSMutableArray <ABCMediaComposeUnit *>*units = [[NSMutableArray alloc] init];
        for (NSInteger i = 0; i < audioInfos.count; i++) {
            NSString *mp3FileName = [NSString stringWithFormat:@"%ld.mp3", i];
            NSString *mp3FilePath = [ABCDubFileManager mp3FilePathWithSubDirectory:resourceId fileName:mp3FileName];
            if ([LocalFileManager fileSizeAtPath:mp3FilePath] > 0) {
                ABCCaptionSegment *segment = audioInfos[i];
                CMTime begin = CMTimeMakeWithSeconds(segment.startTime/1000.f, 1000);
                ABCMediaComposeUnit *mp3Unit = [[ABCMediaComposeUnit alloc] initWithUrl:[NSURL fileURLWithPath:mp3FilePath] mediaType:(AVMediaTypeAudio) beginTime:begin timeRange:kABCAssetTimeRange];
                [units addObject:mp3Unit];
            }
        }
        if (units.count == 0 && completion) {
            dispatch_async(dispatch_get_main_queue(), ^{
                completion(nil, [NSError errorWithDomain:ABCMediaComposeErrorDomain code:ABCMediaComposeErrorCodeEmptyMedia userInfo:@{NSLocalizedDescriptionKey:ABCMediaComposeErrorEmptyMedia}]);
            });
            return;
        }
        // 合成
        NSString *videoPath = [[[ABCDubFileManager videoFileDirectory] stringByAppendingPathComponent:resourceId] stringByAppendingPathExtension:@"mp4"];
        NSURL *videoUrl = nil;
        if (videoPath) {
            videoUrl = [NSURL fileURLWithPath:videoPath];
        }
        if (!videoUrl && completion) {
            dispatch_async(dispatch_get_main_queue(), ^{
                completion(nil, [NSError errorWithDomain:CreateFilePathErrorDomain code:CreateFilePathErrorCodeDirectoryCreateError userInfo:@{NSLocalizedDescriptionKey:CreateFilePathErrorDirectoryCreateError}]);
            });
            return;
        }
        [ABCMediaComposeUtil mixComposeMediasWithVideo:videoUnit baseAudio:audioUnit subAudios:units toUrl:videoUrl completion:^(BOOL success, NSError * _Nullable err) {
            if (success) {
                if (completion) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        completion(videoUrl, nil);
                    });
                }
            }
            else {
                if (completion) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        completion(nil, err);
                    });
                }
            }
        }];
    });
}

- (void)clearComposedVideos {
    NSString *videoPath = [ABCDubFileManager videoFileDirectory];
    [LocalFileManager removeLocalFileAtPath:videoPath];
}

- (ABCMediaComposeUnit *)videoUnitWithResourceId:(NSString *)resourceId {
    NSString *mp4FilePath = [[NSBundle mainBundle] pathForResource:TestSourceName ofType:@"mp4"];
    ABCMediaComposeUnit *videoUnit = [[ABCMediaComposeUnit alloc] initWithUrl:[NSURL fileURLWithPath:mp4FilePath] mediaType:(AVMediaTypeVideo) beginTime:kCMTimeZero timeRange:kABCAssetTimeRange];
    return videoUnit;
}

- (ABCMediaComposeUnit *)baseAudioUnitWithResourceId:(NSString *)resourceId {
    NSString *mp4FilePath = [[NSBundle mainBundle] pathForResource:TestSourceName ofType:@"mp3"];
    ABCMediaComposeUnit *videoUnit = [[ABCMediaComposeUnit alloc] initWithUrl:[NSURL fileURLWithPath:mp4FilePath] mediaType:(AVMediaTypeAudio) beginTime:kCMTimeZero timeRange:kABCAssetTimeRange];
    return videoUnit;
}

- (NSString *)mp3FilePathWithResourceId:(NSString *)recourceId fileName:(NSString *)mp3FileName {
    NSString *mp3FilePath = [ABCDubFileManager mp3FilePathWithSubDirectory:recourceId fileName:mp3FileName];
    return mp3FilePath;
}

- (MP3Endocder *)encoder {
    if (!_encoder) {
        _encoder = [[MP3Endocder alloc] init];
    }
    return _encoder;
}

@end
