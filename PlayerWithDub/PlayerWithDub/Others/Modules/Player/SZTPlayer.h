//
//  SZTPlayer.h
//  PlayerWithDub
//
//  Created by 泽泰 舒 on 2018/11/9.
//  Copyright © 2018年 泽泰 舒. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVPlayerLayer.h>
#import "SZTKVOSimpleDefine.h"

typedef NS_ENUM(NSUInteger, SZTPlayerStatus) {
    SZTPlayerStatusNotConfigUrl,
    SZTPlayerStatusWaiting,
    SZTPlayerStatusPlaying,
    SZTPlayerStatusPaused,
    SZTPlayerStatusBuffering,
    SZTPlayerStatusError
};

NS_ASSUME_NONNULL_BEGIN

@class SZTPlayer;
@protocol SZTPlayerDelegate <NSObject>

@optional
- (void)player:(SZTPlayer *)player didPlayAtSeconds:(NSTimeInterval)seconds;
- (void)player:(SZTPlayer *)player didUpdateCachedProgress:(double)progress;
- (void)player:(SZTPlayer *)player playerStatusDidChanged:(SZTPlayerStatus)status;

- (void)player:(SZTPlayer *)player didOccurError:(NSError *)error;

- (void)playerWillPauseForStartBuffer;
- (void)playerDidCompletedBuffer;

- (void)player:(SZTPlayer *)player didCompletedCacheToUrl:(NSString *)url;
- (void)playerDidReachEnd:(SZTPlayer *)player;

@end

@interface SZTPlayer : NSObject

@property (nonatomic, strong, readonly) AVPlayerLayer *playerLayer;

@property (nonatomic, readonly) BOOL isPlaying;
@property (nonatomic, readonly) SZTPlayerStatus status;
@property (nonatomic, assign) CGFloat volume;
@property (nonatomic, readonly) NSTimeInterval totalSeconds;

@property (nonatomic, weak) id<SZTPlayerDelegate> delegate;

// in main queue
- (void)configUrl:(NSURL *)url;
- (void)play;
- (void)pause;
- (void)stop;
- (void)clear;

- (void)seekToTimeWithSeconds:(NSTimeInterval)seconds completion:(nullable void(^)(BOOL finish))completion;

@end

NS_ASSUME_NONNULL_END
