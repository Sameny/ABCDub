//
//  ABCMediaMergeUtils.m
//  PlayerWithDub
//
//  Created by 泽泰 舒 on 2018/10/31.
//  Copyright © 2018年 泽泰 舒. All rights reserved.
//

#import "ABCError.h"
#import "ABCMediaComposeUnit.h"
#import <AVFoundation/AVFoundation.h>
#import "ABCMediaComposeUtil.h"

typedef NS_ENUM(NSUInteger, ABCMediaComposeResultType) {
    ABCMediaComposeResultTypeM4A,
    ABCMediaComposeResultTypeQuickTime,
    ABCMediaComposeResultTypeMPEG4,
};

NSString * presetNameWithResultType(ABCMediaComposeResultType resultType) {
    switch (resultType) {
        case ABCMediaComposeResultTypeM4A:
            return AVAssetExportPresetAppleM4A;
        case ABCMediaComposeResultTypeQuickTime:
            return AVAssetExportPresetHighestQuality;
        case ABCMediaComposeResultTypeMPEG4:
            return AVAssetExportPresetHighestQuality;
        default:
            return AVAssetExportPresetAppleM4A;
    }
}

NSString *outputFileTypeWithResultType(ABCMediaComposeResultType resultType) {
    switch (resultType) {
        case ABCMediaComposeResultTypeM4A:
            return AVFileTypeAppleM4A;
        case ABCMediaComposeResultTypeQuickTime:
            return AVFileTypeQuickTimeMovie;
        case ABCMediaComposeResultTypeMPEG4:
            return AVFileTypeMPEG4;
        default:
            return AVFileTypeAppleM4A;
    }
}


@implementation ABCMediaComposeUtil

+ (void)mixComposeAudiosWithUnits:(NSArray <ABCMediaComposeUnit *>*)audiosUnits toUrl:(NSURL *)desUrl completion:(ABCMediaComposeCompletion)completion {
    [ABCMediaComposeUtil mixComposeMediasWithUnits:audiosUnits toUrl:desUrl resultType:ABCMediaComposeResultTypeM4A completion:completion];
}

+ (void)mixComposeMediasWithVideo:(ABCMediaComposeUnit *)video baseAudio:(ABCMediaComposeUnit *)baseAudio subAudios:(NSArray <ABCMediaComposeUnit *>*)audiosUnits toUrl:(NSURL *)desUrl completion:(ABCMediaComposeCompletion)completion {
    if (video.mediaType != AVMediaTypeVideo || !video.url || !baseAudio.url) {
        if (completion) {
            completion(NO, nil);
        }
        return;
    }
    
    // 设置合成轨道
    AVMutableComposition *composition = [AVMutableComposition composition];
    NSError *err;
    // 设置视频轨道
    [ABCMediaComposeUtil addSubTrackWithMediaType:(AVMediaTypeVideo) composeUnit:video onCompositionTrack:nil forComposition:composition error:&err];
    // 设置主音轨
    if (!err) {
        [ABCMediaComposeUtil addSubTrackWithMediaType:(AVMediaTypeAudio) composeUnit:baseAudio onCompositionTrack:nil forComposition:composition error:&err];
    }
    if (err) {
        if (completion) {
            completion(NO, err);
        }
        return;
    }
    // 设置子音轨并将所有子音轨放在同一条音轨上
    AVMutableCompositionTrack *compositionTrack = [composition addMutableTrackWithMediaType:AVMediaTypeAudio preferredTrackID:(kCMPersistentTrackID_Invalid)];
    [audiosUnits enumerateObjectsUsingBlock:^(ABCMediaComposeUnit * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSError *err;
        if (![ABCMediaComposeUtil addSubTrackWithMediaType:obj.mediaType composeUnit:obj onCompositionTrack:compositionTrack forComposition:composition error:&err]) {
            if (completion) {
                completion(NO, err);
            }
            *stop = YES;
            return;
        }
    }];
    
    [ABCMediaComposeUtil exportWithAsset:composition desUrl:desUrl resultType:ABCMediaComposeResultTypeMPEG4 completion:completion];
}

+ (void)mixComposeAudiosWithBaseAudio:(ABCMediaComposeUnit *)baseAudio subAudios:(NSArray <ABCMediaComposeUnit *>*)audiosUnits toUrl:(NSURL *)desUrl completion:(ABCMediaComposeCompletion)completion {
    if (!baseAudio.url) {
        if (completion) {
            completion(NO, nil);
        }
        return;
    }
    // 设置合成轨道
    AVMutableComposition *composition = [AVMutableComposition composition];
    // 设置主音轨
    NSError *err;
    [ABCMediaComposeUtil addSubTrackWithMediaType:(AVMediaTypeAudio) composeUnit:baseAudio onCompositionTrack:nil forComposition:composition error:&err];
    if (err) {
        if (completion) {
            completion(NO, err);
        }
        return;
    }
    // 设置子音轨并将所有子音轨放在同一条音轨上
    AVMutableCompositionTrack *compositionTrack = [composition addMutableTrackWithMediaType:AVMediaTypeAudio preferredTrackID:(kCMPersistentTrackID_Invalid)];
    [audiosUnits enumerateObjectsUsingBlock:^(ABCMediaComposeUnit * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSError *err;
        if (![ABCMediaComposeUtil addSubTrackWithMediaType:obj.mediaType composeUnit:obj onCompositionTrack:compositionTrack forComposition:composition error:&err]) {
            if (completion) {
                completion(NO, err);
            }
            return;
        }
    }];
    
    [ABCMediaComposeUtil exportWithAsset:composition desUrl:desUrl resultType:ABCMediaComposeResultTypeM4A completion:completion];
}

+ (void)video:(NSURL *)videoUrl composeWithAudio:(NSURL *)audioUrl toUrl:(NSURL *)desUrl completion:(ABCMediaComposeCompletion)completion {
    if (!videoUrl || !audioUrl) {
        if (completion) {
            completion(NO, nil);
        }
        return;
    }
    ABCMediaComposeUnit *videoUnit = [[ABCMediaComposeUnit alloc] initWithUrl:videoUrl mediaType:AVMediaTypeVideo beginTime:CMTimeMake(0, 1) timeRange:CMTimeRangeMake(CMTimeMake(0, 1), kABCAssetTime)];
    ABCMediaComposeUnit *audioUnit = [[ABCMediaComposeUnit alloc] initWithUrl:audioUrl mediaType:AVMediaTypeAudio beginTime:CMTimeMake(0, 1) timeRange:CMTimeRangeMake(CMTimeMake(0, 1), kABCAssetTime)];
    [ABCMediaComposeUtil mixComposeMediasWithUnits:@[videoUnit, audioUnit] toUrl:desUrl resultType:ABCMediaComposeResultTypeMPEG4 completion:completion];
}

+ (void)mixComposeMediasWithUnits:(NSArray <ABCMediaComposeUnit *>*)mediaUnits toUrl:(NSURL *)desUrl resultType:(ABCMediaComposeResultType)resultType completion:(ABCMediaComposeCompletion)completion {
    AVMutableComposition *composition = [AVMutableComposition composition];
    
    [mediaUnits enumerateObjectsUsingBlock:^(ABCMediaComposeUnit * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSError *err;
        if (![ABCMediaComposeUtil addSubTrackWithMediaType:obj.mediaType composeUnit:obj onCompositionTrack:nil forComposition:composition error:&err]) {
            if (completion) {
                completion(NO, err);
            }
            return;
        }
    }];
    
    [ABCMediaComposeUtil exportWithAsset:composition desUrl:desUrl resultType:resultType completion:completion];
}

+ (void)composeAudiosWithUnits:(NSArray <ABCMediaComposeUnit *>*)audiosUnits toUrl:(NSURL *)desUrl completion:(ABCMediaComposeCompletion)completion {
    AVMutableComposition *composition = [AVMutableComposition composition];
    // 设置拼接后的音轨
    AVMutableCompositionTrack *compositionTrack = [composition addMutableTrackWithMediaType:AVMediaTypeAudio preferredTrackID:(kCMPersistentTrackID_Invalid)];
    
    [audiosUnits enumerateObjectsUsingBlock:^(ABCMediaComposeUnit * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSError *err;
        if (![ABCMediaComposeUtil addSubTrackWithMediaType:obj.mediaType composeUnit:obj onCompositionTrack:compositionTrack forComposition:composition error:&err]) {
            if (completion) {
                completion(NO, err);
            }
            return;
        }
    }];
    
    [ABCMediaComposeUtil exportWithAsset:composition desUrl:desUrl resultType:ABCMediaComposeResultTypeM4A completion:completion];
}

+ (BOOL)addSubTrackWithMediaType:(AVMediaType)mediaType composeUnit:(ABCMediaComposeUnit *)unit onCompositionTrack:(AVMutableCompositionTrack *)compositionTrack forComposition:(AVMutableComposition *)composition error:(NSError **)error {
    if (!unit || !unit.url || !composition) {
        return NO;
    }
    AVAsset *mediaAsset = [AVAsset assetWithURL:unit.url];
    AVAssetTrack *mediaTrack = [[mediaAsset tracksWithMediaType:mediaType] firstObject];
    CMTimeRange timeRange = unit.timeRange;
    if (0 == CMTimeCompare(kABCAssetTime, timeRange.duration)) {
        timeRange.duration = mediaAsset.duration;
    }
    
    NSError *err;
    if (!compositionTrack) { // 如果传进来的合成轨道是nil，就自动创建一个新的合成轨道。
        compositionTrack = [composition addMutableTrackWithMediaType:mediaType preferredTrackID:(kCMPersistentTrackID_Invalid)];
    }
    BOOL success = [compositionTrack insertTimeRange:timeRange ofTrack:mediaTrack atTime:unit.beginTime error:&err];
    if (!success) {
        *error = err;
        return NO;
    }
    return YES;
}

+ (void)exportWithAsset:(AVAsset *)asset desUrl:(NSURL *)desUrl resultType:(ABCMediaComposeResultType)resultType completion:(ABCMediaComposeCompletion)completion {
    if ([[NSFileManager defaultManager] fileExistsAtPath:desUrl.path]) {
        [[NSFileManager defaultManager] removeItemAtPath:desUrl.path error:nil];
    }
    
    NSString *presetName = presetNameWithResultType(resultType);
    NSString *outputFileType = outputFileTypeWithResultType(resultType);
    
    AVAssetExportSession *exportSession = [[AVAssetExportSession alloc] initWithAsset:asset presetName:presetName];
    exportSession.outputURL = desUrl;
    exportSession.outputFileType = outputFileType;
    exportSession.shouldOptimizeForNetworkUse = YES;
    [exportSession exportAsynchronouslyWithCompletionHandler:^{
        BOOL success = NO;
        switch ([exportSession status]) {
            case AVAssetExportSessionStatusFailed: {} break;
            case AVAssetExportSessionStatusCancelled: {} break;
            case AVAssetExportSessionStatusCompleted: {
                success = YES;
            } break;
            default: {} break; }
        
        NSError *exportError = exportSession.error;
        if (!exportError && ![[NSFileManager defaultManager] fileExistsAtPath:desUrl.path]) {
            exportError = [NSError errorWithDomain:ABCMediaComposeErrorDomain code:kABCMediaComposeErrorCodeExport userInfo:@{NSLocalizedDescriptionKey:kABCMediaComposeErrorExport}];
            NSLog(@"%@", exportSession.error);
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            if (completion) {
                completion(success, exportError);
            }
        });
    }];
}

@end
