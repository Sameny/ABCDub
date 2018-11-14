//
//  SZTPlayerView.h
//  PlayerWithDub
//
//  Created by 泽泰 舒 on 2018/11/12.
//  Copyright © 2018年 泽泰 舒. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SZTPlayerView;
@protocol SZTPlayerViewDelegate <NSObject>

@required
// 旋转为竖屏时调用
- (void)addPlayerView:(SZTPlayerView *)playerView;


@end

@protocol SZTPlayerViewLoadDelegate <NSObject>

@optional
- (void)didCompletedCacheToUrl:(NSString *)url;

@end

NS_ASSUME_NONNULL_BEGIN

@class AVPlayerLayer;
@interface SZTPlayerView : UIView

@property (nonatomic, weak) UIViewController <SZTPlayerViewDelegate> *presentingViewController;
@property (nonatomic, weak) id<SZTPlayerViewLoadDelegate> delegate;

// in main queue
- (void)configUrl:(NSURL *)url;
- (void)addPlayerLayer:(AVPlayerLayer *)playerLayer;

- (void)changeScreenToPortrait;
- (void)changeScreenToLandscape;

@end

NS_ASSUME_NONNULL_END
