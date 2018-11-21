//
//  ABCDubHelper.h
//  PlayerWithDub
//
//  Created by 泽泰 舒 on 2018/11/6.
//  Copyright © 2018年 泽泰 舒. All rights reserved.
//
/*
 ABCDubHelper is responsible for recording audio, saving audio, encoding audio and uploading audio.
 It also can compose audio with audio, audio with video and return a temp file url for displaying.
 */

#import <Foundation/Foundation.h>

typedef void(^ABCURLHandler)(NSURL * url, NSError * error);

NS_ASSUME_NONNULL_BEGIN

@class ABCCaptionSegment;
@interface ABCDubHelper : NSObject

+ (instancetype)sharedInstance;

/**
 recording audio, saving audio, encoding audio

 @param recourceId unique source id
 @param mp3FileName mp3 file name
 @param duration recorded audio duration
 @param completion call back
 */
- (void)recordAudioWithResourceId:(NSString *)recourceId mp3FileName:(NSString *)mp3FileName duration:(NSTimeInterval)duration completion:(ABCURLHandler)completion;

/**
 compose audio with audio, audio with video and return a temp file url for displaying

 @param resourceId unique source id
 @param audioInfos recorded mp3 file info
 @param completion call back
 */
- (void)composeWithResourceId:(NSString *)resourceId subAudioInfos:(NSArray <ABCCaptionSegment *>*)audioInfos completion:(ABCURLHandler)completion;

- (NSString *)mp3FilePathWithResourceId:(NSString *)recourceId fileName:(NSString *)mp3FileName;


/**
 clear the video by composing.
 */
- (void)clearComposedVideos;

@end

NS_ASSUME_NONNULL_END
