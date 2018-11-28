//
//  ABCBaseViewController.m
//  PlayerWithDub
//
//  Created by 舒泽泰 on 2018/11/27.
//  Copyright © 2018 泽泰 舒. All rights reserved.
//

#import "ABCBaseViewController.h"

@interface ABCBaseViewController () <ABCNavigationViewDelegate>

@property (nonatomic, strong) ABCNavigationView *navView;

@end

@implementation ABCBaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.navView];
    
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if (self.navigationController.viewControllers.count > 1) {
        [self.navView setLeftItemHidden:NO];
    }
    else {
        [self.navView setLeftItemHidden:YES];
    }
}

- (void)setNavigationViewHidden:(BOOL)hidden animated:(BOOL)animated {
    if (hidden) {
        [self hideNavigationViewWithAnimated:animated];
    }
    else {
        [self showNavigationViewWithAnimated:animated];
    }
}

- (void)showNavigationViewWithAnimated:(BOOL)animated {
    if (!self.navView.hidden) {
        return;
    }
    if (animated) {
        self.navView.transform = CGAffineTransformMakeTranslation(0, -self.navView.bounds.size.height);
        self.navView.hidden = NO;
        [UIView animateWithDuration:0.3 animations:^{
            self.navView.transform = CGAffineTransformIdentity;
        }];
    }
    else {
        self.navView.hidden = NO;
    }
}

- (void)hideNavigationViewWithAnimated:(BOOL)animated {
    if (self.navView.hidden) {
        return;
    }
    if (animated) {
        [UIView animateWithDuration:0.3 animations:^{
            self.navView.transform = CGAffineTransformMakeTranslation(0, self.navView.bounds.size.height);
        } completion:^(BOOL finished) {
            if (finished) {
                self.navView.hidden = YES;
            }
        }];
    }
    else {
        self.navView.hidden = YES;
    }
}

- (void)setBackgroundStyle:(ABCNavigationViewBackgroundStyle)backgroundStyle {
    _backgroundStyle = backgroundStyle;
    NSArray *backImageNames = @[@"", @"nav_back_stars", @"nav_back_curve", @"nav_back_curve_stars"];
    [self.navView setBackgroundImage:ImageWithName(backImageNames[backgroundStyle])];
}

#pragma mark - ABCNavigationViewDelegate
- (void)leftNavigationButtonDidClicked {
}

- (void)rightNavigationButtonDidClicked {
}

- (ABCNavigationView *)navView {
    if (!_navView) {
        _navView = [[ABCNavigationView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SZT_NAVIGATIONBAR_HEIGHT)];
        _navView.delegate = self;
    }
    return _navView;
}

@end
