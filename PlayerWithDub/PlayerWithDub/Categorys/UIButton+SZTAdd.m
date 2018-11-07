//
//  UIButton+SZTAdd.m
//  CommercialTreadmill
//
//  Created by 泽泰 舒 on 16/10/19.
//  Copyright © 2016年 artiwares. All rights reserved.
//

#import "UIButton+SZTAdd.h"

@interface UIButton ()

@property (nonatomic, strong) CAShapeLayer *backLayer;

@end

@implementation UIButton (SZTAdd)

- (void)verticalCenterAlignmentWithSpace:(CGFloat)space imageAtTop:(BOOL)imageAtTop {
    [self alignmentWithContentAlignOrientation:STContentAlignOrientationVertical space:space imageAtHead:imageAtTop alignment:STContentAlignmentCenter];
}

- (void)horizontalAlignmentWithSpace:(CGFloat)space imageAtLeft:(BOOL)imageAtLeft {
    [self alignmentWithContentAlignOrientation:STContentAlignOrientationHorizontal space:space imageAtHead:imageAtLeft alignment:STContentAlignmentCenter];
}

- (void)horizontalAlignmentWithSpace:(CGFloat)space imageAtLeft:(BOOL)imageAtLeft alignment:(STContentAlignment)alignment {
    [self alignmentWithContentAlignOrientation:STContentAlignOrientationHorizontal space:space imageAtHead:imageAtLeft alignment:alignment];
        
}

- (void)alignmentWithContentAlignOrientation:(STContentAlignOrientation)alignOrientation space:(CGFloat)space imageAtHead:(BOOL)imageAtHead alignment:(STContentAlignment)alignment {
    NSString *title = self.titleLabel.text;
    UIFont *font = self.titleLabel.font;
    UIImage *image = self.imageView.image;
    
    if (!title && !image) return;
    
    CGFloat h_delta = 0;
    CGFloat v_delta = 0;
    CGFloat centerOffsetY = 0; // 只在STContentAlignOrientationVertical时生效
    //    CGSize textSize = title?[title sizeWithAttributes:@{NSFontAttributeName:font}]:CGSizeZero;
    CGSize textSize = self.titleLabel.intrinsicContentSize;
    if (CGSizeEqualToSize(CGSizeZero, textSize) && title.length) {
        textSize = [title sizeWithAttributes:@{NSFontAttributeName:font}];
    }
    CGSize imageSize = image?image.size:CGSizeZero;
    
    space = space/2; // 文字和图像各移动一半，保证整体对齐
    if (alignOrientation == STContentAlignOrientationHorizontal) {
        if (imageAtHead) {
            [self setImageEdgeInsets:UIEdgeInsetsMake(0, -space, 0, space)];
            [self setTitleEdgeInsets:UIEdgeInsetsMake(0, space, 0, -space)];
        }
        else {
            [self setImageEdgeInsets:UIEdgeInsetsMake(0, textSize.width + space, 0, -textSize.width - space)];
            [self setTitleEdgeInsets:UIEdgeInsetsMake(0, -imageSize.width - space, 0, imageSize.width + space)];
        }
        
        h_delta = (self.bounds.size.width - textSize.width - imageSize.width)/2.f - space;
        v_delta = (self.bounds.size.height - MAX(textSize.height, imageSize.height))/2.f;
    }
    else {
        if (imageAtHead) {
            [self setImageEdgeInsets:UIEdgeInsetsMake(-imageSize.height/2 - space, textSize.width/2, imageSize.height/2 + space, -textSize.width/2)];
            [self setTitleEdgeInsets:UIEdgeInsetsMake(textSize.height/2 + space, -imageSize.width/2, -textSize.height/2 - space, imageSize.width/2)];
        }
        else {
            [self setImageEdgeInsets:UIEdgeInsetsMake(imageSize.height/2 + space, textSize.width/2, -imageSize.height/2 - space, -textSize.width/2)];
            [self setTitleEdgeInsets:UIEdgeInsetsMake(-textSize.height/2 - space, -imageSize.width/2, textSize.height/2 + space, imageSize.width/2)];
        }
        h_delta = (self.bounds.size.width - MAX(textSize.width, imageSize.width))/2.f;
        v_delta = (self.bounds.size.height - textSize.height - imageSize.height)/2.f - space;
        
        /** 思想
         1. 假定offset > 0
         a.当我们的整体需要往上偏移的时候，top = -offset，bottom = offset
         b.当我们的整体需要往下偏移的时候，top = offset，bottom = -offset
         2. 假定offset < 0
         a.当我们的整体需要往上偏移的时候，top = offset，bottom = -offset
         b.当我们的整体需要往下偏移的时候，top = -offset，bottom = offset
         */
        centerOffsetY = (textSize.height - imageSize.height)/2.f; // 中心相对偏移量,如果centerOffsetY > 0，说明需要整体向image方向移动；反之向text方向移动
        if (!imageAtHead) {
            centerOffsetY *= -1.f; // 这样就转换成 centerOffsetY > 0,则往上移动；centerOffsetY < 0,则往下移动。这样就使offset = abs（centerOffsetY），centerOffsetY的正负性就代表了需要移动的方向。这样就和思想重合了
        }
    }
    
    switch (alignment) {
        case STContentAlignmentLeft:
            [self setContentEdgeInsets:UIEdgeInsetsMake(-centerOffsetY, -h_delta, centerOffsetY, h_delta)];
            break;
        case STContentAlignmentCenter:
            [self setContentEdgeInsets:UIEdgeInsetsMake(-centerOffsetY, 0, centerOffsetY, 0)];
            break;
        case STContentAlignmentRight:
            [self setContentEdgeInsets:UIEdgeInsetsMake(-centerOffsetY, h_delta, centerOffsetY, -h_delta)];
            break;
            
        case STContentAlignmentTopLeft:
            [self setContentEdgeInsets:UIEdgeInsetsMake(-v_delta - centerOffsetY, -h_delta, v_delta + centerOffsetY, h_delta)];
            break;
        case STContentAlignmentTopCenter:
            [self setContentEdgeInsets:UIEdgeInsetsMake(-v_delta - centerOffsetY, 0, v_delta + centerOffsetY, 0)];
            break;
        case STContentAlignmentTopRight:
            [self setContentEdgeInsets:UIEdgeInsetsMake(-v_delta - centerOffsetY, h_delta, v_delta + centerOffsetY, -h_delta)];
            break;
            
        case STContentAlignmentBottomLeft:
            [self setContentEdgeInsets:UIEdgeInsetsMake(v_delta - centerOffsetY, -h_delta, -v_delta + centerOffsetY, h_delta)];
            break;
        case STContentAlignmentBottomCenter:
            [self setContentEdgeInsets:UIEdgeInsetsMake(v_delta - centerOffsetY, 0, -v_delta + centerOffsetY, 0)];
            break;
        case STContentAlignmentBottomRight:
            [self setContentEdgeInsets:UIEdgeInsetsMake(v_delta - centerOffsetY, h_delta, -v_delta + centerOffsetY, -h_delta)];
            break;
    }
}


-(void)setBackLayer:(CAShapeLayer *)backLayer {
    if (backLayer) {
        objc_setAssociatedObject(self, @"backLayer", backLayer, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    else {
        objc_removeAssociatedObjects(self);
    }
}

- (CAShapeLayer *)backLayer {
    return objc_getAssociatedObject(self, @"backLayer");
}

- (void)addbackLayerByTitleAndImageWithColor:(UIColor *)color cornerRadius:(CGFloat)radius {
    CGRect imageFrame = self.imageView.frame;
    CGRect titleFrame = self.titleLabel.frame;
    
    CGFloat rectX = fminf(imageFrame.origin.x, titleFrame.origin.x);
    CGFloat rectY = fminf(imageFrame.origin.y, titleFrame.origin.y);
    CGFloat rectWidth = fmaxf(CGRectGetMaxX(imageFrame), CGRectGetMaxX(titleFrame)) - fminf(CGRectGetMinX(imageFrame), CGRectGetMinX(titleFrame)) + radius/2;
    CGFloat rectHeight = fmaxf(CGRectGetMaxY(imageFrame), CGRectGetMaxY(titleFrame)) - fminf(CGRectGetMinY(imageFrame), CGRectGetMinY(titleFrame));
    
    if (!self.backLayer) {
        self.backLayer = [CAShapeLayer layer];
        [self.layer insertSublayer:self.backLayer below:self.imageView.layer];
    }
    self.backLayer.backgroundColor = color.CGColor;
    self.backLayer.cornerRadius = radius;
    self.backLayer.frame = CGRectMake(rectX, rectY, rectWidth, rectHeight);
}

- (void)fitiPhoneXBottom {
//    if (iPhoneX) {
//        [self setContentEdgeInsets:UIEdgeInsetsMake(-SZT_TABBAR_BOTTOM_HEIGHT/2, 0, SZT_TABBAR_BOTTOM_HEIGHT/2, 0)];
//    }
}

@end
