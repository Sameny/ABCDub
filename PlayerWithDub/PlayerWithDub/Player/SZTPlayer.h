//
//  SZTPlayer.h
//  PlayerWithDub
//
//  Created by 泽泰 舒 on 2018/11/9.
//  Copyright © 2018年 泽泰 舒. All rights reserved.
//

#import <Foundation/Foundation.h>
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
- (void)player:(SZTPlayer *)player playerStatusDidChanged:(int)status;

@end

@interface SZTPlayer : NSObject

@property (nonatomic, strong, readonly) AVPlayerLayer *playerLayer;

@property (nonatomic, readonly) BOOL isPlaying;
@property (nonatomic, readonly) SZTPlayerStatus status;


// in main queue
- (void)configUrl:(NSURL *)url;
- (void)play;
- (void)pause;
- (void)stop;
- (void)clear;

- (void)seekToTimeWithSeconds:(double)seconds;

@end

NS_ASSUME_NONNULL_END
