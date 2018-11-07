//
//  AppDelegate.m
//  PlayerWithDub
//
//  Created by 泽泰 舒 on 2018/10/30.
//  Copyright © 2018年 泽泰 舒. All rights reserved.
//

#import "ABCDubHelper.h"
#import "ABCNavigationViewController.h"
#import "ViewController.h"
#import "AppDelegate.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    ViewController *vc = [[ViewController alloc] init];
    self.window.rootViewController = [[ABCNavigationViewController alloc] initWithRootViewController:vc];
    
    [self.window makeKeyAndVisible];
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    
}


- (void)applicationWillTerminate:(UIApplication *)application {
    [[ABCDubHelper sharedInstance] clearComposedVideos];
}


@end
