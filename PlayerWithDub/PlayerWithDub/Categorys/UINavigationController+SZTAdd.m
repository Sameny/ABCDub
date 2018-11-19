//
//  UINavigationController+SZTAdd.m
//  PlayerWithDub
//
//  Created by 泽泰 舒 on 2018/11/15.
//  Copyright © 2018年 泽泰 舒. All rights reserved.
//

#import "UINavigationController+SZTAdd.h"

@implementation UINavigationController (SZTAdd)

// 去掉UINavigationBar底部的分割线
- (void)removeBottomSpliteLine {
    // 导航栏背景透明
    [self.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
    // 导航栏底部线清除
    self.navigationBar.barStyle = UIBarStyleBlack;
    //    self.navigationBar.translucent = YES;
    [self.navigationBar setShadowImage:[UIImage new]];
}

- (void)removeBottomSpliteLineWithBackgroundColor:(UIColor *)backColor {
    // 导航栏背景透明
    [self.navigationBar setBackgroundImage:[UIImage imageWithColor:backColor] forBarMetrics:UIBarMetricsDefault];
    // 导航栏底部线清除
    self.navigationBar.barStyle = UIBarStyleBlack;
    //    self.navigationBar.translucent = YES;
    [self.navigationBar setShadowImage:[UIImage imageWithColor:backColor]];
}

// 显示分割线 UIBarStyleDefault 黑色底线  UIBarStyleBlack 白色底线
- (void)showBottomSpliteLineWithBarStyle:(UIBarStyle)barStyle {
    //    self.navigationBar.translucent = NO;
    if (barStyle == UIBarStyleDefault) {
        [self.navigationBar setShadowImage:nil];
    }
    else {
        [self.navigationBar setShadowImage:nil];
    }
    [self.navigationBar setBackgroundImage:nil forBarMetrics:UIBarMetricsDefault];
    self.navigationBar.barStyle = barStyle;
}

- (void)pushViewControllerWithClassName:(NSString *)className {
    Class vcClass = NSClassFromString(className);
    UIViewController *viewController = [[vcClass alloc] init];
    if (viewController) {
        [self pushViewController:viewController animated:YES];
    } else {
        DebugLog(@"className %@ had no view controller instance", className);
    }
    
}

- (void)pushViewControllerWithClassName:(NSString *)className animated:(BOOL)animted {
    Class vcClass = NSClassFromString(className);
    UIViewController *viewController = [[vcClass alloc] init];
    if (viewController) {
        [self pushViewController:viewController animated:animted];
    } else {
        DebugLog(@"className %@ had no view controller instance", className);
    }
}

- (void)tr_setTitleColor:(UIColor *)color {
    self.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName:color};
}


- (BOOL)shouldAutorotate {
    return self.topViewController.shouldAutorotate;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    return self.topViewController.supportedInterfaceOrientations;
}

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation {
    return self.topViewController.preferredInterfaceOrientationForPresentation;
}

@end
