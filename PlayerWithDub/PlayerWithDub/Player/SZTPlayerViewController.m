//
//  SZTPlayerViewController.m
//  PlayerWithDub
//
//  Created by 泽泰 舒 on 2018/11/7.
//  Copyright © 2018年 泽泰 舒. All rights reserved.
//

#import "ControlHelper.h"
#import "SZTPlayerViewController.h"

@interface SZTPlayerViewController () <SZTPlayerViewScreenDelegate>

@property (nonatomic, strong) SZTPlayerView *playerView;
@property (nonatomic, strong) UIButton *backBtn;

@property (nonatomic, strong) NSURL *url;

@end

@implementation SZTPlayerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.playerView];
    self.navigationController.navigationBar.hidden = YES;
    [self.view addSubview:self.backBtn];
    self.backBtn.frame = CGRectMake(SZTBackItemLeftMargin, SZTBackItemTopMargin, SZTBackItemSize.width, SZTBackItemSize.height);
}

- (void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator {
    self.view.window.frame = CGRectMake(0, 0, PORTRAIT_SCREEN_WIDTH, PORTRAIT_SCREEN_HEIGHT);
    self.navigationController.view.frame = CGRectMake(0, 0, PORTRAIT_SCREEN_WIDTH, PORTRAIT_SCREEN_HEIGHT);
    self.view.frame = CGRectMake(0, 0, PORTRAIT_SCREEN_WIDTH, PORTRAIT_SCREEN_HEIGHT);
    self.playerView.frame = CGRectMake(0, 0, PORTRAIT_SCREEN_WIDTH, size.width*9.f/16.f);
}

- (void)setVideoUrl:(NSURL *)url {
    if (url) {
        [self.playerView configUrl:url];
        _url = url;
    }
}

- (void)backBtnDidClicked {
    self.playerView.presentingViewController = nil;
    if (self.navigationController) {
        [self.navigationController popViewControllerAnimated:YES];
    }
    else {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

#pragma mark - SZTPlayerViewScreenDelegate
// 旋转为竖屏时调用
- (void)addPlayerView:(SZTPlayerView *)playerView {
    [self.view addSubview:playerView];
    [self.view addSubview:self.backBtn];
    playerView.frame = CGRectMake(0, 0, PORTRAIT_SCREEN_WIDTH, PORTRAIT_SCREEN_WIDTH*9.f/16.f);
    self.backBtn.frame = CGRectMake(SZTBackItemLeftMargin, SZTBackItemTopMargin, SZTBackItemSize.width, SZTBackItemSize.height);
}

#pragma mark - player
- (SZTPlayerView *)playerView {
    if (!_playerView) {
        _playerView = [[SZTPlayerView alloc] initWithFrame:CGRectMake(0, 0, PORTRAIT_SCREEN_WIDTH, PORTRAIT_SCREEN_WIDTH*9.f/16.f)];
        _playerView.presentingViewController = self;
    }
    return _playerView;
}

- (UIButton *)backBtn {
    if (!_backBtn) {
        _backBtn = [ControlHelper baseButtonAddtarget:self selector:@selector(backBtnDidClicked) image:nil imagePressed:nil title:@"返回" font:18.f textColor:[UIColor whiteColor] textBold:NO];
    }
    return _backBtn;
}

#pragma mark - orentation
- (BOOL)shouldAutorotate {
    return YES;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskPortrait;
}

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation {
    return UIInterfaceOrientationPortrait;
}

@end
