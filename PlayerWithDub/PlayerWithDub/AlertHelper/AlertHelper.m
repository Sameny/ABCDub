//
//  AlertHelper.m
//  PlayerWithDub
//
//  Created by 泽泰 舒 on 2018/11/1.
//  Copyright © 2018年 泽泰 舒. All rights reserved.
//

#import "AlertHelper.h"

@implementation AlertHelper

+ (void)showAppSettingAlertViewWithTitle:(NSString *)title
                                 message:(NSString *)message
                               doneTitle:(NSString *)doneTitle
                             cancelTitle:(NSString *)cancelTitle {
    UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:cancelTitle style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        [alertVC dismissViewControllerAnimated:YES completion:nil];
    }];
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:doneTitle style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        NSURL *url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
        if ([[UIApplication sharedApplication] canOpenURL:url]) {
            [[UIApplication sharedApplication] openURL:url options:@{} completionHandler:nil];
        }else{
            NSLog(@"open app setting url error");
        }
    }];
    [alertVC addAction:cancelAction];
    [alertVC addAction:okAction];
    
    [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:alertVC animated:YES completion:nil];
}

@end
