//
//  UINavigationController+SZTAdd.h
//  PlayerWithDub
//
//  Created by 泽泰 舒 on 2018/11/15.
//  Copyright © 2018年 泽泰 舒. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UINavigationController (SZTAdd)
// 去掉UINavigationBar底部的分割线
- (void)removeBottomSpliteLine;
- (void)removeBottomSpliteLineWithBackgroundColor:(UIColor *)backColor;
// 显示分割线 UIBarStyleDefault 黑色底线  UIBarStyleBlack 白色底线
- (void)showBottomSpliteLineWithBarStyle:(UIBarStyle)barStyle;

- (void)pushViewControllerWithClassName:(NSString *)className;
- (void)pushViewControllerWithClassName:(NSString *)className animated:(BOOL)animted;

- (void)szt_setTitleColor:(UIColor *)color;

@end

NS_ASSUME_NONNULL_END
