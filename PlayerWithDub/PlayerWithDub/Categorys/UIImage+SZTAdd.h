//
//  UIImage+SZTAdd.h
//  PlayerWithDub
//
//  Created by 泽泰 舒 on 2018/11/20.
//  Copyright © 2018年 泽泰 舒. All rights reserved.
//

#import <UIKit/UIKit.h>

extern NSString * const PNG_IMAGE_TYPE;
extern NSString * const JPG_IMAGE_TYPE;
extern NSString * const JPEG_IMAGE_TYPE;

NS_ASSUME_NONNULL_BEGIN

@interface UIImage (SZTAdd)

- (UIImage *)imageWithMaxSide:(CGFloat)length;

+ (UIImage *)imageNameInMainBundle:(NSString *)name ofType:(NSString *)type;

+ (UIImage *)pngImageNameInMainBundle:(NSString *)name;

- (UIImage *)compressToSize:(CGSize)size;

+ (UIImage *)imageFromImage:(UIImage *)image inRect:(CGRect)rect scale:(CGFloat)scale;

- (UIImage *)imageToScale:(CGFloat)scale;

+ (UIImage *)compressImage:(UIImage *)image
             compressRatio:(CGFloat)ratio;

+ (UIImage *)compoundImageWithTopImage:(UIImage *) topImage bottomImage:(UIImage *) bottomImage;

/**
 *  高斯模糊
 *
 *  @param radius   radius 模糊的深度
 *  @param cutFrame 被裁减的区域
 *
 *  @return 模糊后的image
 */
- (UIImage *)convertToBlurImageWithInputRatius:(CGFloat)radius cutFrame:(CGRect)cutFrame;

+ (UIImage *)imageWithColor:(UIColor *)color size:(CGSize)size isCircle:(BOOL)isCircle;

- (UIImage *)circleImage;

- (UIImage *)imageWithColor:(UIColor *)color;
@end

NS_ASSUME_NONNULL_END
