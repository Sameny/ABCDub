//
//  ABCTabBarController.m
//  PlayerWithDub
//
//  Created by 泽泰 舒 on 2018/11/14.
//  Copyright © 2018年 泽泰 舒. All rights reserved.
//

#import "ABCMainViewViewController.h"
#import "ABCFocusViewController.h"
#import "ABCMessageViewController.h"
#import "ABCUserViewController.h"

#import "ABCTabBarController.h"

@interface ABCTabBarController ()

@end

@implementation ABCTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSArray <NSString *>*viewControllers = @[@"ABCMainViewViewController", @"ABCFocusViewController", @"ABCMessageViewController", @"ABCUserViewController"];
    NSArray <NSString *>*titiles = @[@"首页", @"关注", @"消息", @"我的"];
    NSArray <NSString *>*imageNames = @[@"tabbar_home_normal", @"tabbar_focus_normal", @"tabbar_massage_normal", @"tabbar_user_normal"];
    NSArray <NSString *>*selectedImageNames = @[@"tabbar_home_selected", @"tabbar_focus_selected", @"tabbar_massage_selected", @"tabbar_user_selected"];
    
    NSMutableArray <UIViewController *>*vcs = [NSMutableArray array];
    for (NSInteger i = 0; i < viewControllers.count; i++) {
        UIViewController *vc = [[NSClassFromString(viewControllers[i]) alloc] init];
        vc.tabBarItem = [self tabBarItemWithTitle:titiles[i] imageName:imageNames[i] selectedImageName:selectedImageNames[i]];
        [vcs addObject:[[UINavigationController alloc] initWithRootViewController:vc]];
    };
    self.viewControllers = vcs;
}

- (UITabBarItem *)tabBarItemWithTitle:(NSString *)title imageName:(NSString *)imageName selectedImageName:(NSString *)selectedImageName {
    UIImage *normalImage = [[UIImage imageNamed:imageName] imageWithRenderingMode:(UIImageRenderingModeAlwaysOriginal)];
    UIImage *selectedImage = [[UIImage imageNamed:selectedImageName] imageWithRenderingMode:(UIImageRenderingModeAlwaysOriginal)];
    UITabBarItem *tabbar = [[UITabBarItem alloc] initWithTitle:title image:normalImage selectedImage:selectedImage];
    UIFont *font = [UIFont fontWithName:ABCFontNamePingFangSC size:9];
    [tabbar setTitleTextAttributes:@{NSForegroundColorAttributeName:ABCMainColorNormal, NSFontAttributeName:font} forState:(UIControlStateNormal)];
    [tabbar setTitleTextAttributes:@{NSForegroundColorAttributeName:ABCMainColor, NSFontAttributeName:font} forState:(UIControlStateSelected)];
    return tabbar;
}

- (BOOL)shouldAutorotate {
    return self.selectedViewController.shouldAutorotate;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    return self.selectedViewController.supportedInterfaceOrientations;
}

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation {
    return self.selectedViewController.preferredInterfaceOrientationForPresentation;
}


@end
