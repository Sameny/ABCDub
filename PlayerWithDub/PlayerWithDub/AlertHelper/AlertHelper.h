//
//  AlertHelper.h
//  PlayerWithDub
//
//  Created by 泽泰 舒 on 2018/11/1.
//  Copyright © 2018年 泽泰 舒. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface AlertHelper : NSObject

+ (void)showAppSettingAlertViewWithTitle:(NSString *)title
                                 message:(NSString *)message
                               doneTitle:(NSString *)doneTitle
                             cancelTitle:(NSString *)cancelTitle;

@end

NS_ASSUME_NONNULL_END
