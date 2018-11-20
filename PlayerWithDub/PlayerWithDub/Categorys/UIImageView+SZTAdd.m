//
//  UIImageView+SZTAdd.m
//  PlayerWithDub
//
//  Created by 泽泰 舒 on 2018/11/20.
//  Copyright © 2018年 泽泰 舒. All rights reserved.
//

#import "UIImageView+SZTAdd.h"

@implementation UIImageView (SZTAdd)

- (void)szt_setCircle {
    [self szt_setCornerRadius:MIN(self.width, self.height)/2 withImage:nil];
}

- (void)szt_setCornerRadius:(CGFloat)radius {
    [self szt_setCornerRadius:radius withImage:nil];
}

- (void)szt_setCornerRadius:(CGFloat)radius withImage:(UIImage *)image {
    if (@available(iOS 9.0, *)) {
        if (image) {
            self.image = image;
        }
        self.layer.cornerRadius = radius;
        self.layer.masksToBounds = YES;
    }
    else {
        if (!image) {
            image = self.image;
        }
        if (image) {
            __block UIImage *result;
            radius = radius*MIN(image.size.width, image.size.height)/MIN(self.width, self.height);
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                result = [image imageByRoundCornerRadius:radius borderWidth:0.0 borderColor:nil];
                dispatch_async(dispatch_get_main_queue(), ^{
                    self.image = result;;
                });
            });
        }
        else {
            self.layer.cornerRadius = radius;
        }
    }
}

- (void)addMaskLayerWithColor:(UIColor *)color {
    CAShapeLayer *layer = [CAShapeLayer layer];
    layer.frame = self.bounds;
    layer.cornerRadius = self.layer.cornerRadius;
    layer.backgroundColor = color.CGColor;
    [self.layer addSublayer:layer];
}

static NSString * const kImageViewGradientMaskLayerName = @"ImageViewGradientMaskLayer";
- (void)addGradientMaskLayerWithColor:(NSArray <UIColor *>*)colors startPoint:(CGPoint)start endPoint:(CGPoint)end {
    NSMutableArray *cg_colors = [[NSMutableArray alloc] init];
    for (NSInteger i = 0; i < colors.count; i++) {
        [cg_colors addObject:(id)colors[i].CGColor];
    }
    
    BOOL added = NO;
    for (CALayer *layer in self.layer.sublayers) {
        if ([layer isKindOfClass:[CAGradientLayer class]] && [layer.name isEqualToString:kImageViewGradientMaskLayerName]) {
            ((CAGradientLayer *)layer).colors = cg_colors;
            ((CAGradientLayer *)layer).startPoint = start;
            ((CAGradientLayer *)layer).endPoint = end;
            added = YES;
        }
    }
    if (!added) {
        CAGradientLayer *layer = [CAGradientLayer layer];
        layer.frame = self.bounds;
        layer.cornerRadius = self.layer.cornerRadius;
        
        layer.colors = cg_colors;
        layer.startPoint = start;
        layer.endPoint = end;
        layer.name = kImageViewGradientMaskLayerName;
        [self.layer addSublayer:layer];
    }
}

static NSInteger kBackShadowViewTag = 998;
- (void)showBackShadowLayerWithColor:(UIColor *)color size:(CGSize)size radius:(CGFloat)radius {
    if (!self.superview) {
        return;
    }
    UIView *layerView = [self.superview viewWithTag:kBackShadowViewTag];
    if (!layerView) {
        layerView = [[UIView alloc] initWithFrame:self.frame];
        layerView.layer.cornerRadius = self.layer.cornerRadius;
        layerView.backgroundColor = [UIColor whiteColor];
        layerView.tag = kBackShadowViewTag;
        [self.superview insertSubview:layerView belowSubview:self];
        [layerView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.top.bottom.equalTo(self);
        }];
    }
    [layerView setLayerShadow:color offset:size radius:radius];
    if (layerView.hidden) {
        layerView.hidden = NO;
    }
}

- (void)hideBackShadowLayer {
    if (!self.superview) {
        return;
    }
    UIView *layerView = [self.superview viewWithTag:kBackShadowViewTag];
    if (!layerView.hidden) {
        layerView.hidden = YES;
    }
}

@end
