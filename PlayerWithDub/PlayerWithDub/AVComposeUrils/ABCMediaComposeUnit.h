//
//  ABCMediaMergeUnit.h
//  PlayerWithDub
//
//  Created by 泽泰 舒 on 2018/10/31.
//  Copyright © 2018年 泽泰 舒. All rights reserved.
//

#import <CoreMedia/CMTime.h>
#import <CoreMedia/CMTimeRange.h>
#import <AVFoundation/AVMediaFormat.h>
#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

#define kABCAssetTime CMTimeMake(-1, 1)
#define kABCAssetTimeRange CMTimeRangeMake(kCMTimeZero, kABCAssetTime)

@interface ABCMediaComposeUnit : NSObject

@property (nonatomic, strong) NSURL *url; // 插入的合成轨道的资源url
@property (nonatomic, assign) AVMediaType mediaType;
@property (nonatomic, assign) CMTime beginTime; // 在合成轨道上的起始位置
@property (nonatomic, assign) CMTimeRange timeRange; // 待合成资源的起始位置和长度

- (instancetype)initWithUrl:(NSURL *)url mediaType:(AVMediaType)mediaType beginTime:(CMTime)begin timeRange:(CMTimeRange)timeRange;

@end

NS_ASSUME_NONNULL_END
