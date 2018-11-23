//
//  UIView+SZTAdd.h
//  PlayerWithDub
//
//  Created by 泽泰 舒 on 2018/11/20.
//  Copyright © 2018年 泽泰 舒. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

static CGFloat SZTCOMMON_SPLIT_LINE_THICKNESS = 0.5;
@interface UIView (SZTAdd)

- (void)becomeRoundRect;
- (void)setCornerRadius:(CGFloat)radius;
- (void)setCornerRadius:(CGFloat)radius withCorner:(UIRectCorner)corner;

- (void)setLayerShadow:(UIColor*)color offset:(CGSize)offset opacity:(CGFloat) opacity;
- (void)setLayerShadow:(UIColor*)color offset:(CGSize)offset opacity:(CGFloat) opacity radius:(CGFloat)radius;

- (void)setBottomLineWithColor:(UIColor *)color left:(CGFloat)left right:(CGFloat)right;

- (void)setDashlineSpacing:(int)lineSpacing lineColor:(UIColor *)lineColor;

- (void)setHorDashLineSpacing:(int)lineSpacing lineColor:(UIColor *)lineColor;

- (void)addGradientLayerWithColors:(NSArray <UIColor *>*)colors locations:(nullable NSArray<NSNumber *>*)locations startPoint:(CGPoint)start endPoint:(CGPoint)end;

- (void)setBorderDashWithBorderColor:(UIColor *) color borderSpace:(CGFloat) borderSpace;
- (void)setBorderDashWithBorderColor:(UIColor *) color lineWidth:(CGFloat) lineWidth dashPattern:(NSArray<NSNumber *> *) dashPattern;

// amplitude 振幅
- (void)horShakeAnimationWithAmplitude:(CGFloat)amplitude;

- (void)addBreathAnimationWithDuration:(CGFloat)duration scaleFrom:(CGFloat)sFrom scaleTo:(CGFloat)sTo opacityFrom:(CGFloat)oFrom opacityFrom:(CGFloat)oTo;
- (void)removeBreathAnimation;

@end

NS_ASSUME_NONNULL_END
