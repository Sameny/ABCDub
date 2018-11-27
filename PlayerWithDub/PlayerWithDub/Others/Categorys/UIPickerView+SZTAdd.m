//
//  UIPickerView+SZTAdd.m
//  PlayerWithDub
//
//  Created by 舒泽泰 on 2018/11/26.
//  Copyright © 2018 泽泰 舒. All rights reserved.
//

#import "UIPickerView+SZTAdd.h"

@implementation UIPickerView (SZTAdd)

- (void)szt_setSeperateLineColor:(UIColor *)lineColor {
    for(UIView *view in self.subviews) {
        if (view.frame.size.height < 1) {
            view.backgroundColor = lineColor;
        }
    }
}

- (void)szt_setSeperateLineColor:(UIColor *)lineColor lineHeight:(CGFloat)lineHeight {
    NSArray *lineNames = @[@"topLine", @"bottomLine"];
    NSInteger index = 0;
    for(UIView *view in self.subviews) {
        if (view.frame.size.height < 1) {
            CGRect frame = view.frame;
            frame.size.height = lineHeight;
            view.backgroundColor = [UIColor clearColor]; // 隐藏自带的
            [self setLineWithColor:lineColor lineFrame:frame name:lineNames[index]];
            index = 1;
        }
    }
}

@end
