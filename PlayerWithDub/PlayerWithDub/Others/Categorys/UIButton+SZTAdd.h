//
//  UIButton+SZTAdd.h
//  CommercialTreadmill
//
//  Created by 泽泰 舒 on 16/10/19.
//  Copyright © 2016年 artiwares. All rights reserved.
//

#import <UIKit/UIKit.h>


typedef NS_ENUM(NSUInteger, STContentAlignOrientation) {
    STContentAlignOrientationVertical,
    STContentAlignOrientationHorizontal,
};

typedef NS_ENUM(NSUInteger, STContentAlignment) {
    STContentAlignmentLeft,
    STContentAlignmentCenter,
    STContentAlignmentRight,
    
    STContentAlignmentTopLeft,
    STContentAlignmentTopCenter,
    STContentAlignmentTopRight,
    
    STContentAlignmentBottomLeft,
    STContentAlignmentBottomCenter,
    STContentAlignmentBottomRight,
};

@interface UIButton (SZTAdd)

- (void)verticalCenterAlignmentWithSpace:(CGFloat)space imageAtTop:(BOOL)imageAtTop;

- (void)horizontalAlignmentWithSpace:(CGFloat)space imageAtLeft:(BOOL)imageAtLeft;
- (void)horizontalAlignmentWithSpace:(CGFloat)space imageAtLeft:(BOOL)imageAtLeft alignment:(STContentAlignment)alignment;


/**
 设置UIButton中的文字和图片对齐方式

 @param alignOrientation 垂直／水平放置文案和图片
 @param space 文案和图片之间的间距
 @param imageAtHead YES:图片在前(上／左)
 @param alignment 内容对齐方式
 */
- (void)alignmentWithContentAlignOrientation:(STContentAlignOrientation)alignOrientation space:(CGFloat)space imageAtHead:(BOOL)imageAtHead alignment:(STContentAlignment)alignment;

- (void)addbackLayerByTitleAndImageWithColor:(UIColor *)color cornerRadius:(CGFloat)radius;

- (void)fitiPhoneXBottom;

@end
