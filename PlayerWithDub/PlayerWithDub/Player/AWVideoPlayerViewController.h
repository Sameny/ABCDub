//
//  AWVideoPlayerViewController.h
//  Treadmill
//
//  Created by 泽泰 舒 on 16/8/3.
//  Copyright © 2016年 杭州匠物科技. All rights reserved.
//

#import <UIKit/UIKit.h>

@class AWVideoPlayerViewController;
@protocol AWVideoPlayerDelegate <NSObject>

@optional
- (void)player:(AWVideoPlayerViewController *)player playingAtTime:(NSTimeInterval)milliSeconds;
- (void)playerPlayingAtEnd:(AWVideoPlayerViewController *)player;

- (void)playerCenterPlayButtonDidClicked:(AWVideoPlayerViewController *)player;
- (void)playerLeftBottomButtonDidClicked:(AWVideoPlayerViewController *)player;

@end

typedef NS_ENUM(NSUInteger, AWVideoPlayerControl) {
    AWVideoPlayerControlNone, // 不需要任何控制播放器的tool
    AWVideoPlayerControlCenterPlay, // 只需要中间的播放按钮
    AWVideoPlayerControlAll, // 全部控制
};

static CGFloat const kVideoHeightToWidthRate = 1080.0/1920;

@interface AWVideoPlayerViewController : UIViewController

@property (nonatomic, readonly) NSTimeInterval totalDuration;
@property (nonatomic, readonly) NSTimeInterval playedDuration;
@property (nonatomic, assign) CGFloat volume;
@property (nonatomic, readonly) BOOL isPlaying;
@property (nonatomic, assign) BOOL enableTouch;

@property (nonatomic) AWVideoPlayerControl playerControl;
@property (nonatomic, weak) id<AWVideoPlayerDelegate> delegate;

+ (instancetype)playerViewControllerWithFrame:(CGRect)frame;

+ (instancetype)playerViewControllerWithFrame:(CGRect)frame playerControl:(AWVideoPlayerControl)control;

- (void)readyForPlayVideoWithURLString:(NSString *)urlString;
- (void)playVideoWithURLString:(NSString *)urlString;
- (void)readyForPlayingVideoWithURL:(NSURL *)url;

- (void)play;
- (void)pause;
/**
 播放视频
 @param begin 从begin开始播放
 */
- (void)playWithBeginMilliSeconds:(NSTimeInterval)begin;

- (void)setPlayerFrame:(CGRect)frame;

- (void)showLoadingView;
- (void)hiddenLoadingView;
- (void)setPlaceHolderImage:(UIImage *)image;

- (void)releaseMySelf;

@end



@interface AWVideoPlayerViewController (PlayWithLoading)

/**
 支持在下载时播放视频

 @param urlString 视频路径
 @param atLoading 是否在下载时播放
 @Param cachedFilePath 如果已经缓存过，就直接从缓存播放，如果没有缓存，就在下载完成后，存储到该缓存地址
 */
- (void)playVideoWithURLString:(NSString *)urlString atLoading:(BOOL)atLoading cachedFilePath:(NSString *)cachedFilePath;

@end
