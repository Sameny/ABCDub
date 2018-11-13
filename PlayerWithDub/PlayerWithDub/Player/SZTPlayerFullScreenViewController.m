//
//  SZTPlayerFullScreenViewController.m
//  PlayerWithDub
//
//  Created by 泽泰 舒 on 2018/11/13.
//  Copyright © 2018年 泽泰 舒. All rights reserved.
//

#import "SZTPlayerView.h"
#import "SZTPlayerFullScreenViewController.h"

@interface SZTPlayerFullScreenViewController ()

@end

@implementation SZTPlayerFullScreenViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.1];
    if (self.playerView) {
        [self.view addSubview:self.playerView];
    }
    [self addBackBtn];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    if (self.playerView) {
        self.playerView.frame = self.view.bounds;
        [self.view layoutIfNeeded];
    }
    
    UIInterfaceOrientation orientation = [UIApplication sharedApplication].statusBarOrientation;
    CGFloat angle = orientation == UIInterfaceOrientationLandscapeRight?-M_PI_2:M_PI_2;
    self.view.transform = CGAffineTransformMakeRotation(angle);
    [UIView animateWithDuration:0.3 animations:^{
        self.view.transform = CGAffineTransformIdentity;
    }];
}

- (void)backBtnDidClicked {
    if (self.playerView) {
        [self.playerView changeScreenToPortrait];
    }
    else {
        [self dismissViewControllerAnimated:NO completion:nil];
    }
}


#pragma mark - orientation
- (BOOL)shouldAutorotate {
    return YES;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskLandscape;
}

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation {
    return UIInterfaceOrientationLandscapeRight;
}

@end
