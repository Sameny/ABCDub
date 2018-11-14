//
//  SZTPlayerView.h
//  PlayerWithDub
//
//  Created by 泽泰 舒 on 2018/11/12.
//  Copyright © 2018年 泽泰 舒. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@class SZTPlayerView;
@protocol SZTPlayerViewScreenDelegate <NSObject>

@required
// 旋转为竖屏时调用
- (void)addPlayerView:(SZTPlayerView *)playerView;


@end

@protocol SZTPlayerViewDelegate <NSObject>

@optional
- (void)didCompletedCacheToUrl:(NSString *)url;

- (void)playerDidPlayAtSeconds:(NSTimeInterval)seconds;
- (void)playerDidReachEnd;

@end

@class AVPlayerLayer;
@interface SZTPlayerView : UIView

@property (nonatomic, weak) UIViewController <SZTPlayerViewScreenDelegate> *presentingViewController;
@property (nonatomic, weak) id<SZTPlayerViewDelegate> delegate;
@property (nonatomic, readonly) BOOL isPlaying;

// in main queue
- (void)configUrl:(NSURL *)url;
- (void)addPlayerLayer:(AVPlayerLayer *)playerLayer;

- (void)play;
- (void)pause;
- (void)stop;
- (void)clear;

- (void)seekToTimeWithSeconds:(NSTimeInterval)seconds completion:(void(^)(BOOL finish))completion;

- (void)changeScreenToPortrait;
- (void)changeScreenToLandscape;

@end

NS_ASSUME_NONNULL_END
