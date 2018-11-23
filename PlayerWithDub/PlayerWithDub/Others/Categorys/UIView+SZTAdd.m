//
//  UIView+SZTAdd.m
//  PlayerWithDub
//
//  Created by 泽泰 舒 on 2018/11/20.
//  Copyright © 2018年 泽泰 舒. All rights reserved.
//

#import "UIView+SZTAdd.h"

@implementation UIView (SZTAdd)

- (void)becomeRoundRect {
    CGRect bounds = self.bounds;
    [self setCornerRadius:bounds.size.width/2 withCorner:(UIRectCornerAllCorners)];
}

- (void)setCornerRadius:(CGFloat)radius {
    [self setCornerRadius:radius withCorner:(UIRectCornerAllCorners)];
}

- (void)setCornerRadius:(CGFloat)radius withCorner:(UIRectCorner)corner {
    if (@available(iOS 11.0, *)) {
        self.layer.maskedCorners = (CACornerMask)corner;
        self.layer.cornerRadius = radius;
    }
    else {
        UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:self.bounds byRoundingCorners:corner cornerRadii:CGSizeMake(radius, radius)];
        
        CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
        maskLayer.frame = self.bounds;
        maskLayer.path = maskPath.CGPath;
        self.layer.mask = maskLayer;
    }
}

- (void)setLayerShadow:(UIColor*)color offset:(CGSize)offset opacity:(CGFloat) opacity {
    self.layer.shadowColor = color.CGColor;
    self.layer.shadowOffset = offset;
    self.layer.shadowOpacity = opacity;
    self.layer.shadowRadius = 1.f;
    self.layer.shouldRasterize = YES;
    self.layer.rasterizationScale = [UIScreen mainScreen].scale;
}

- (void)setLayerShadow:(UIColor*)color offset:(CGSize)offset opacity:(CGFloat) opacity radius:(CGFloat)radius {
    self.layer.shadowColor = color.CGColor;
    self.layer.shadowOffset = offset;
    self.layer.shadowOpacity = opacity;
    self.layer.shadowRadius = radius;
    self.layer.shouldRasterize = YES;
    self.layer.rasterizationScale = [UIScreen mainScreen].scale;
}

static NSString * const kTRBottomLineName = @"treadmill_bottom_line";
- (void)setBottomLineWithColor:(UIColor *)color left:(CGFloat)left right:(CGFloat)right {
    CALayer *bottomLineLayer = nil;
    for (CALayer *layer in self.layer.sublayers) {
        if ([layer.name isEqualToString:kTRBottomLineName]) {
            bottomLineLayer = layer;
        }
    }
    if (!bottomLineLayer) {
        bottomLineLayer = [CALayer layer];
        [self.layer addSublayer:bottomLineLayer];
    }
    bottomLineLayer.backgroundColor = color.CGColor;
    bottomLineLayer.frame = CGRectMake(left, self.height - SZTCOMMON_SPLIT_LINE_THICKNESS, self.width - left - right, SZTCOMMON_SPLIT_LINE_THICKNESS);
}

- (void)setDashlineSpacing:(int)lineSpacing lineColor:(UIColor *)lineColor {
    CAShapeLayer *shapeLayer = [CAShapeLayer layer];
    [shapeLayer setBounds:self.bounds];
    [shapeLayer setPosition:CGPointMake(self.width/2, self.height/2)];
    [shapeLayer setFillColor:[UIColor clearColor].CGColor];
    [shapeLayer setStrokeColor:lineColor.CGColor];
    [shapeLayer setLineWidth:self.width];
    [shapeLayer setLineJoin:kCALineJoinRound];
    
    [shapeLayer setLineDashPattern:[NSArray arrayWithObjects:[NSNumber numberWithInt:self.width], [NSNumber numberWithInt:lineSpacing], nil]];
    
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathMoveToPoint(path, NULL, self.width/2, 0);
    CGPathAddLineToPoint(path, NULL, self.width/2, self.height);
    [shapeLayer setPath:path];
    CGPathRelease(path);
    [self.layer addSublayer:shapeLayer];
}

- (void)setHorDashLineSpacing:(int)lineSpacing lineColor:(UIColor *)lineColor {
    CAShapeLayer *shapeLayer = [CAShapeLayer layer];
    [shapeLayer setBounds:self.bounds];
    [shapeLayer setPosition:CGPointMake(self.width/2, self.height/2)];
    [shapeLayer setFillColor:[UIColor clearColor].CGColor];
    [shapeLayer setStrokeColor:lineColor.CGColor];
    [shapeLayer setLineWidth:lineSpacing];
    [shapeLayer setLineJoin:kCALineJoinRound];
    
    [shapeLayer setLineDashPattern:[NSArray arrayWithObjects:[NSNumber numberWithInt:lineSpacing], [NSNumber numberWithInt:lineSpacing], nil]];
    
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathMoveToPoint(path, NULL, 0, self.height/2.f);
    CGPathAddLineToPoint(path, NULL, self.width, self.height/2.f);
    [shapeLayer setPath:path];
    CGPathRelease(path);
    [self.layer addSublayer:shapeLayer];
}

- (void)setBorderDashWithBorderColor:(UIColor *) color borderSpace:(CGFloat) borderSpace {
    CAShapeLayer *borderLayer = [CAShapeLayer layer];
    
    borderLayer.strokeColor = color.CGColor;
    borderLayer.fillColor = nil;
    borderLayer.path = [UIBezierPath bezierPathWithRoundedRect:self.bounds cornerRadius:5.f].CGPath;
    borderLayer.frame = self.bounds;
    borderLayer.lineWidth = borderSpace;
    borderLayer.lineDashPattern = @[@1,@1];
    
    [self.layer addSublayer:borderLayer];
}

static NSString *kGradientLayerKey = @"tr_gradientLayer";
- (void)addGradientLayerWithColors:(NSArray <UIColor *>*)colors locations:(NSArray<NSNumber *>*)locations startPoint:(CGPoint)start endPoint:(CGPoint)end {
    CAGradientLayer *gradientLayer;
    for (CALayer *layer in self.layer.sublayers) {
        if ([layer.name isEqualToString:kGradientLayerKey]) {
            gradientLayer = (CAGradientLayer *)layer;
        }
    }
    if (!gradientLayer) {
        gradientLayer = [CAGradientLayer layer];
        gradientLayer.name = kGradientLayerKey;
        gradientLayer.frame = self.bounds;
        [self.layer insertSublayer:gradientLayer atIndex:0];
    }
    NSMutableArray *cg_colors = [[NSMutableArray alloc] init];
    for (UIColor *color in colors) {
        [cg_colors addObject:(id)color.CGColor];
    }
    gradientLayer.startPoint = start;
    gradientLayer.endPoint = end;
    gradientLayer.colors = cg_colors;
    if (locations) {
        gradientLayer.locations = locations;
    }
    gradientLayer.cornerRadius = self.layer.cornerRadius;
}

- (void)setBorderDashWithBorderColor:(UIColor *) color lineWidth:(CGFloat) lineWidth dashPattern:(NSArray<NSNumber *> *) dashPattern {
    CAShapeLayer *borderLayer = [CAShapeLayer layer];
    
    borderLayer.strokeColor = color.CGColor;
    borderLayer.fillColor = nil;
    borderLayer.path = [UIBezierPath bezierPathWithRoundedRect:self.bounds cornerRadius:5.f].CGPath;
    borderLayer.frame = self.bounds;
    borderLayer.lineWidth = lineWidth;
    borderLayer.lineDashPattern = dashPattern;
    
    [self.layer addSublayer:borderLayer];
    
}

// amplitude 振幅
- (void)horShakeAnimationWithAmplitude:(CGFloat)amplitude {
    CALayer *viewLayer = self.layer;
    CGPoint position = viewLayer.position;
    CGPoint right = CGPointMake(position.x + amplitude, position.y);
    CGPoint left = CGPointMake(position.x - amplitude, position.y);
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"position"];
    [animation setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionDefault]];
    [animation setFromValue:[NSValue valueWithCGPoint:right]];
    [animation setToValue:[NSValue valueWithCGPoint:left]];
    [animation setAutoreverses:YES];
    [animation setDuration:.06];
    [animation setRepeatCount:3];
    [viewLayer addAnimation:animation forKey:nil];
}

- (void)addBreathAnimationWithDuration:(CGFloat)duration scaleFrom:(CGFloat)sFrom scaleTo:(CGFloat)sTo opacityFrom:(CGFloat)oFrom opacityFrom:(CGFloat)oTo {
    [self removeBreathAnimation];
    
    CABasicAnimation * scaleAnim = [CABasicAnimation animation];
    scaleAnim.keyPath = @"transform.scale";
    scaleAnim.fromValue = @(sFrom);
    scaleAnim.toValue = @(sTo);
    scaleAnim.duration = duration;
    
    // 透明度动画
    CABasicAnimation *opacityAnim=[CABasicAnimation animationWithKeyPath:@"opacity"];
    opacityAnim.fromValue= @(oFrom);
    opacityAnim.toValue= @(oTo);
    opacityAnim.duration= duration;
    
    // 创建动画组
    CAAnimationGroup *groups =[CAAnimationGroup animation];
    groups.animations = @[scaleAnim,opacityAnim];
    groups.removedOnCompletion = NO;
    groups.fillMode = kCAFillModeForwards;
    groups.duration = duration;
    groups.repeatCount = FLT_MAX;
    
    CALayer *layer = [CALayer layer];
    layer.frame = self.bounds;
    layer.backgroundColor = self.backgroundColor.CGColor;
    layer.cornerRadius = self.layer.cornerRadius;
    layer.borderColor = self.layer.borderColor;
    layer.borderWidth = self.layer.borderWidth;
    layer.name = @"tr.breath.layer";
    
    [layer addAnimation:groups forKey:@"tr.breath"];
    [self.layer insertSublayer:layer atIndex:0];
}

- (void)removeBreathAnimation {
    CALayer *needRemoveLayer;
    for (CALayer *layer in self.layer.sublayers) {
        if ([layer.name isEqualToString:@"tr.breath.layer"]) {
            needRemoveLayer = layer;
            [layer removeAnimationForKey:@"tr.breath"];
        }
    }
    if (needRemoveLayer) {
        [needRemoveLayer removeFromSuperlayer];
    }
}

@end


#import "UIImage+SZTAdd.h"
@implementation UIView (Shot)

#pragma mark 截屏
/**
 * 从图片中按指定的位置大小截取view的一部分
 * UIView view 原始的图片
 * CGRect rect 要截取的区域
 */
+ (UIImage *)takeScreenShotWithView:(UIView *)view inRect:(CGRect)rect
{
    // 这里前往要注意，你截取的是哪个view的内容
    //    UIGraphicsBeginImageContext(self.bossView.frame.size);//不支持retine屏幕，会丢分辨率
    CGFloat scale = [UIScreen mainScreen].scale;
    UIGraphicsBeginImageContextWithOptions(view.bounds.size, NO, scale);//支持retine屏幕
    // 获取图像
    [view.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    if(image) {
        return [UIImage imageFromImage:image inRect:rect scale:scale];
    }
    return nil;
}

+ (UIImage *)takeScreenShotWithScrollView:(UIScrollView *)scrollView inRect:(CGRect)rect {
    UIImage* image = nil;
    UIGraphicsBeginImageContextWithOptions(scrollView.contentSize, NO, 0.0);//支持retine屏幕
    {
        CGPoint savedContentOffset = scrollView.contentOffset;
        CGRect savedFrame = scrollView.frame;
        
        scrollView.contentOffset = CGPointZero;
        scrollView.frame = CGRectMake(0, 0, scrollView.contentSize.width, scrollView.contentSize.height);
        
        [scrollView.layer renderInContext: UIGraphicsGetCurrentContext()];
        image = UIGraphicsGetImageFromCurrentImageContext();
        
        scrollView.contentOffset = savedContentOffset;
        scrollView.frame = savedFrame;
    }
    UIGraphicsEndImageContext();
    
    CGFloat scale = image.scale;
    if(image) {
        return [UIImage imageFromImage:image inRect:rect scale:scale];
    }
    return nil;
}

@end
