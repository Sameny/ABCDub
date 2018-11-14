//
//  SZTPlayerViewController.m
//  PlayerWithDub
//
//  Created by 泽泰 舒 on 2018/11/7.
//  Copyright © 2018年 泽泰 舒. All rights reserved.
//

#import "SZTPlayerView.h"
#import "ControlHelper.h"
#import "SZTPlayerViewController.h"

@interface SZTPlayerViewController ()

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

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated {
    if (_url) {
        [self.playerView play];
    }
}

- (void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator {
    self.view.window.frame = CGRectMake(0, 0, size.width, size.height);
    self.navigationController.view.frame = CGRectMake(0, 0, size.width, size.height);
    self.view.frame = CGRectMake(0, 0, size.width, size.height);
    self.playerView.frame = CGRectMake(0, 0, size.width, size.width*9.f/16.f);
}

- (void)setVideoUrl:(NSURL *)url {
    if (url) {
        [self.playerView configUrl:url];
        _url = url;
    }
}

- (void)backBtnDidClicked {
    if (self.navigationController) {
        [self.navigationController popViewControllerAnimated:YES];
    }
    else {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

#pragma mark - player
- (SZTPlayerView *)playerView {
    if (!_playerView) {
        _playerView = [[SZTPlayerView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.width*9.f/16.f)];
    }
    return _playerView;
}

- (UIButton *)backBtn {
    if (!_backBtn) {
        _backBtn = [ControlHelper baseButtonAddtarget:self selector:@selector(backBtnDidClicked) image:nil imagePressed:nil title:@"返回" font:18.f textColor:[UIColor whiteColor] textBold:NO];
    }
    return _backBtn;
}

@end
