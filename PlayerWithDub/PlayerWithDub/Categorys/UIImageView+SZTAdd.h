//
//  UIImageView+SZTAdd.h
//  PlayerWithDub
//
//  Created by 泽泰 舒 on 2018/11/20.
//  Copyright © 2018年 泽泰 舒. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIImageView (SZTAdd)

- (void)szt_setCircle;
- (void)szt_setCornerRadius:(CGFloat)radius;
- (void)szt_setCornerRadius:(CGFloat)radius withImage:(nullable UIImage *)image;

- (void)addMaskLayerWithColor:(UIColor *)color;

- (void)addGradientMaskLayerWithColor:(NSArray <UIColor *>*)colors startPoint:(CGPoint)start endPoint:(CGPoint)end;

// self 的frame确定之后才去调用该方法，否则会出现问题
- (void)showBackShadowLayerWithColor:(UIColor *)color size:(CGSize)size radius:(CGFloat)radius;
- (void)hideBackShadowLayer;

@end

NS_ASSUME_NONNULL_END
