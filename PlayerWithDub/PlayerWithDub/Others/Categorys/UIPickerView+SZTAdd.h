//
//  UIPickerView+SZTAdd.h
//  PlayerWithDub
//
//  Created by 舒泽泰 on 2018/11/26.
//  Copyright © 2018 泽泰 舒. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIPickerView (SZTAdd)

- (void)szt_setSeperateLineColor:(UIColor *)lineColor;

- (void)szt_setSeperateLineColor:(UIColor *)lineColor lineHeight:(CGFloat)lineHeight;

@end

NS_ASSUME_NONNULL_END
