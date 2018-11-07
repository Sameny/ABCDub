//
//  ABCMediaMergeUtils.h
//  PlayerWithDub
//
//  Created by 泽泰 舒 on 2018/10/31.
//  Copyright © 2018年 泽泰 舒. All rights reserved.
//

#import "ABCMediaComposeUnit.h"

typedef void(^ABCMediaComposeCompletion)(BOOL success, NSError * _Nullable err);

NS_ASSUME_NONNULL_BEGIN
extern NSString * const ABCMediaComposeErrorDomain;

@interface ABCMediaComposeUtil : NSObject


/**
 将多个音频拼接一个音频

 @param audiosUnits 合成所需的音频的urls
 @param desUrl 合成的音频存放的位置
 @param completion 合成结束后执行的回调
 */
+ (void)composeAudiosWithUnits:(NSArray <ABCMediaComposeUnit *>*)audiosUnits toUrl:(NSURL *)desUrl completion:(ABCMediaComposeCompletion)completion;

/**
 将所有子音频放在同一条音轨上，该音轨和视频、主音轨三者并行
 
 @param video 视频的资源信息
 @param baseAudio 主音轨的资源信息
 @param audiosUnits 子音轨的信息
 @param desUrl 存储的目标路径
 @param completion 合成结束后执行的回调
 */
+ (void)mixComposeMediasWithVideo:(ABCMediaComposeUnit *)video baseAudio:(ABCMediaComposeUnit *)baseAudio subAudios:(NSArray <ABCMediaComposeUnit *>*)audiosUnits toUrl:(NSURL *)desUrl completion:(ABCMediaComposeCompletion)completion;

/**
 将所有子音频放在同一条音轨上，该音轨和主音轨并行

 @param baseAudio 主音轨的资源信息
 @param audiosUnits 子音轨的信息
 @param desUrl 存储的目标路径
 @param completion 合成结束后执行的回调
 */
+ (void)mixComposeAudiosWithBaseAudio:(ABCMediaComposeUnit *)baseAudio subAudios:(NSArray <ABCMediaComposeUnit *>*)audiosUnits toUrl:(NSURL *)desUrl completion:(ABCMediaComposeCompletion)completion;

/**
 将多个音频合成为一个音频，混合播放

 @param audiosUnits 被合成的音频信息
 @param desUrl 合成的音频存放的位置
 @param completion 合成结束后执行的回调
 */
+ (void)mixComposeAudiosWithUnits:(NSArray <ABCMediaComposeUnit *>*)audiosUnits toUrl:(NSURL *)desUrl completion:(ABCMediaComposeCompletion)completion;


/**
 将音频和视频进行合成，该方法会去掉视频的原声

 @param videoUrl 视频url
 @param audioUrl 音频url
 @param desUrl 合成的音频存放的位置
 @param completion 合成结束后执行的回调
 */
+ (void)video:(NSURL *)videoUrl composeWithAudio:(NSURL *)audioUrl toUrl:(NSURL *)desUrl completion:(ABCMediaComposeCompletion)completion;

@end

NS_ASSUME_NONNULL_END
