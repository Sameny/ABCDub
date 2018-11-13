//
//  SZTPlayerView.m
//  PlayerWithDub
//
//  Created by 泽泰 舒 on 2018/11/12.
//  Copyright © 2018年 泽泰 舒. All rights reserved.
//

#import "SZTPlayerFullScreenViewController.h"
#import <AVFoundation/AVPlayerLayer.h>
#import "SZTFontDefine.h"
#import "SZTPlayerView.h"

@interface SZTPlayerView ()

@property (nonatomic, strong) UIView *statusView;

@property (nonatomic, strong) UIImageView *placeHolderImageView;
@property (nonatomic, strong) UILabel *mediaNameLabel;
@property (nonatomic, strong) UIView *bottomView;
@property (nonatomic, strong) UILabel *currentTimeLabel;
@property (nonatomic, strong) UILabel *restTimeLabel;
@property (nonatomic, strong) UIButton *changeScreenBtn;
@property (nonatomic, strong) UISlider *slider;

@property (nonatomic, weak) AVPlayerLayer *playerLayer;

@property (nonatomic, strong) SZTPlayerFullScreenViewController *playerFullScreenViewController;

@end

@implementation SZTPlayerView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self configUI];
    }
    return self;
}

- (void)dealloc {
    [self removePlayerLayer];
}

- (void)addPlayerLayer:(AVPlayerLayer *)playerLayer {
    if (!playerLayer) {
        return;
    }
    [self removePlayerLayer];
    [self.layer insertSublayer:playerLayer below:self.placeHolderImageView.layer];
    playerLayer.frame = self.bounds;
    self.playerLayer = playerLayer;
}

- (void)setFrame:(CGRect)frame {
    [super setFrame:frame];
    self.playerLayer.frame = frame;
    [self updateFrame:frame];
}

- (void)removePlayerLayer {
    if (self.playerLayer) {
        [self.playerLayer removeFromSuperlayer];
    }
}

- (void)changeScreen {
    CGSize mainScreenSize = [UIScreen mainScreen].bounds.size;
    if (self.frame.size.width == MAX(mainScreenSize.width, mainScreenSize.height)) { // 横屏
        [self changeScreenToPortrait];
    }
    else {
        [self changeScreenToLandscape];
    }
}

#pragma mark - UI
static CGFloat kSZTPlayerViewTimeLabelWidth  = 32.f;
static CGFloat kSZTPlayerViewTimeLabelHeight = 17.f;
static CGFloat kSZTPlayerViewBottomViewHeight = 32.f;
static CGFloat kSZTPlayerViewBottomViewMargin = 8.f;

- (void)configUI {
    [self addSubview:self.placeHolderImageView];
    [self addSubview:self.bottomView];
    [self addSubview:self.mediaNameLabel];
    [self addSubview:self.statusView];
    
    [self.bottomView addSubview:self.currentTimeLabel];
    [self.bottomView addSubview:self.restTimeLabel];
    [self.bottomView addSubview:self.changeScreenBtn];
    [self.bottomView addSubview:self.slider];
}

- (void)updateFrame:(CGRect)frame {
    self.mediaNameLabel.frame = CGRectMake(10, 10, frame.size.width - 20, 20);
    self.bottomView.frame = CGRectMake(kSZTPlayerViewBottomViewMargin, frame.size.height - kSZTPlayerViewBottomViewHeight, frame.size.width - kSZTPlayerViewBottomViewMargin*2, kSZTPlayerViewBottomViewHeight);
    self.currentTimeLabel.frame = CGRectMake(0, (self.bottomView.bounds.size.height - kSZTPlayerViewTimeLabelHeight)/2, kSZTPlayerViewTimeLabelWidth, kSZTPlayerViewTimeLabelHeight);
    self.slider.frame = CGRectMake(kSZTPlayerViewTimeLabelWidth + 8, (kSZTPlayerViewBottomViewHeight - 16.f)/2, self.bottomView.frame.size.width - kSZTPlayerViewTimeLabelWidth*2 - 18 - 8*3, 16);
    self.restTimeLabel.frame = CGRectMake(self.bottomView.frame.size.width - kSZTPlayerViewTimeLabelWidth - 18.f - 8, (self.bottomView.bounds.size.height - kSZTPlayerViewTimeLabelHeight)/2, kSZTPlayerViewTimeLabelWidth, kSZTPlayerViewTimeLabelHeight);
    self.changeScreenBtn.frame = CGRectMake(self.bottomView.frame.size.width - 18, (kSZTPlayerViewBottomViewHeight - 18.f)/2, 18, 18);
}

CGFloat kChangeScreenAnimateDuration = 0.3;
- (void)changeScreenToPortrait {
    if (!self.presentingViewController) {
        return;
    }
    
    [self.presentingViewController addPlayerView:self.playerFullScreenViewController.playerView];
    [self.playerFullScreenViewController dismissViewControllerAnimated:NO completion:nil];
    
    UIInterfaceOrientation orientation = [UIApplication sharedApplication].statusBarOrientation;
    CGFloat angle = orientation == UIInterfaceOrientationLandscapeRight?-M_PI_2:M_PI_2;
    self.transform = CGAffineTransformMakeRotation(angle);
    [UIView animateWithDuration:kChangeScreenAnimateDuration animations:^{
        self.transform = CGAffineTransformIdentity;
        self.playerFullScreenViewController = nil;
    }];
}

- (void)changeScreenToLandscape {
    if (!self.presentingViewController) {
        return;
    }
    if (!self.playerFullScreenViewController.isBeingPresented) {
        self.playerFullScreenViewController.playerView = self;
        // 推出透明的视图控制器
        self.playerFullScreenViewController.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
        self.playerFullScreenViewController.modalPresentationStyle = UIModalPresentationOverFullScreen;
        
        [self.presentingViewController presentViewController:self.playerFullScreenViewController animated:NO completion:nil];
    }
}

- (SZTPlayerFullScreenViewController *)playerFullScreenViewController {
    if (!_playerFullScreenViewController) {
        _playerFullScreenViewController = [[SZTPlayerFullScreenViewController alloc] init];
    }
    return _playerFullScreenViewController;
}

- (UIView *)bottomView {
    if (!_bottomView) {
        _bottomView = [[UIView alloc] initWithFrame:CGRectMake(kSZTPlayerViewBottomViewMargin, self.frame.size.height - kSZTPlayerViewBottomViewHeight, self.frame.size.width - kSZTPlayerViewBottomViewMargin*2, kSZTPlayerViewBottomViewHeight)];
    }
    return _bottomView;
}

- (UIImageView *)placeHolderImageView {
    if (!_placeHolderImageView) {
        _placeHolderImageView = [[UIImageView alloc] initWithFrame:self.bounds];
    }
    return _placeHolderImageView;
}

- (UILabel *)mediaNameLabel {
    if (!_mediaNameLabel) {
        _mediaNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, self.frame.size.width - 20, 20)];
        _mediaNameLabel.textColor = [UIColor whiteColor];
        _mediaNameLabel.font = [UIFont fontWithName:SZTFontNamePingFangSCMedium size:14.f];
    }
    return _mediaNameLabel;
}

- (UILabel *)currentTimeLabel {
    if (!_currentTimeLabel) {
        _currentTimeLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, (self.bottomView.bounds.size.height - kSZTPlayerViewTimeLabelHeight)/2, kSZTPlayerViewTimeLabelWidth, kSZTPlayerViewTimeLabelHeight)];
        _currentTimeLabel.textColor = [UIColor whiteColor];
        _currentTimeLabel.font = [UIFont fontWithName:SZTFontNamePingFangSC size:12.f];
        _currentTimeLabel.textAlignment = NSTextAlignmentCenter;
        _currentTimeLabel.text = @"00:00";
    }
    return _currentTimeLabel;
}

- (UILabel *)restTimeLabel {
    if (!_restTimeLabel) {
        _restTimeLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.bottomView.frame.size.width - kSZTPlayerViewTimeLabelWidth - 18.f - 8, (self.bottomView.bounds.size.height - kSZTPlayerViewTimeLabelHeight)/2, kSZTPlayerViewTimeLabelWidth, kSZTPlayerViewTimeLabelHeight)];
        _restTimeLabel.textColor = [UIColor whiteColor];
        _restTimeLabel.font = [UIFont fontWithName:SZTFontNamePingFangSC size:12.f];
        _restTimeLabel.textAlignment = NSTextAlignmentCenter;
        _restTimeLabel.text = @"00:00";
    }
    return _restTimeLabel;
}

- (UIButton *)changeScreenBtn {
    if (!_changeScreenBtn) {
        _changeScreenBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
        _changeScreenBtn.frame = CGRectMake(self.bottomView.frame.size.width - 18, (kSZTPlayerViewBottomViewHeight - 18.f)/2, 18, 18);
        [_changeScreenBtn setImage:[UIImage imageNamed:@"player_full_screen"] forState:(UIControlStateNormal)];
        [_changeScreenBtn addTarget:self action:@selector(changeScreen) forControlEvents:(UIControlEventTouchUpInside)];
    }
    return _changeScreenBtn;
}

- (UISlider *)slider {
    if (!_slider) {
        _slider = [[UISlider alloc] initWithFrame:CGRectMake(kSZTPlayerViewTimeLabelWidth + 8, (kSZTPlayerViewBottomViewHeight - 16.f)/2, self.bottomView.frame.size.width - kSZTPlayerViewTimeLabelWidth*2 - 18 - 8*3, 16)];
        _slider.value = 0;
    }
    return _slider;
}

@end
