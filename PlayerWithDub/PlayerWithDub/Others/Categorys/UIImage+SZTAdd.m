//
//  UIImage+SZTAdd.m
//  PlayerWithDub
//
//  Created by 泽泰 舒 on 2018/11/20.
//  Copyright © 2018年 泽泰 舒. All rights reserved.
//

#import "UIImage+SZTAdd.h"

@implementation UIImage (SZTAdd)

static inline CGSize CWSizeReduce(CGSize size, CGFloat limit) {
    CGFloat max = MAX(size.width, size.height);
    if (max < limit) {
        return size;
    }
    CGSize imgSize;
    CGFloat ratio = size.height / size.width;
    if (size.width > size.height) {
        imgSize = CGSizeMake(limit, round(limit*ratio));
    } else {
        imgSize = CGSizeMake(round(limit/ratio), limit);
    }
    return imgSize;
}

- (UIImage *)imageWithMaxSide:(CGFloat)length {
    if (self.size.height > 1080 || self.size.width > 1080) {
        CGFloat scale = 1.0f;
        CGSize imgSize = CWSizeReduce(self.size, length);
        UIImage *img = nil;
        UIGraphicsBeginImageContextWithOptions(imgSize, YES, scale);  // 创建一个 bitmap context
        [self drawInRect:CGRectMake(0, 0, imgSize.width, imgSize.height)
               blendMode:kCGBlendModeNormal alpha:1.0];              // 将图片绘制到当前的 context 上
        img = UIGraphicsGetImageFromCurrentImageContext();            // 从当前 context 中获取刚绘制的图片
        UIGraphicsEndImageContext();
        return img;
    }
    return self;
}

NSString * const PNG_IMAGE_TYPE = @"png";
NSString * const JPG_IMAGE_TYPE = @"jpg";
NSString * const JPEG_IMAGE_TYPE = @"jpeg";

+ (UIImage *)imageNameInMainBundle:(NSString *)name ofType:(NSString *)type {
    NSString *imagePath = [[NSBundle mainBundle] pathForResource:name ofType:type];
    if (!imagePath) { // main bundle大部分都是png
        NSString *newName = [NSString stringWithFormat:@"%@@%@x", name, @([UIScreen mainScreen].scale)];
        imagePath = [[NSBundle mainBundle] pathForResource:newName ofType:type];
    }
    return [UIImage imageWithContentsOfFile:imagePath];
}

+ (UIImage *)pngImageNameInMainBundle:(NSString *)name {
    NSString *imagePath = [[NSBundle mainBundle] pathForResource:name ofType:nil];
    if (!imagePath) {
        imagePath = [UIImage pngImagePathInMainBundle:name];
    }
    return [UIImage imageWithContentsOfFile:imagePath];
}

+ (NSString *)pngImagePathInMainBundle:(NSString *)name {
    NSString *type = [name.pathExtension copy];
    if (type.length > 0) {
        name = [name stringByDeletingPathExtension];
    } else {
        type = [PNG_IMAGE_TYPE copy]; // 默认为png
    }
    
    NSString *imagePath = [[NSBundle mainBundle] pathForResource:name ofType:type];
    if (!imagePath) {
        NSString *newName = [NSString stringWithFormat:@"%@@%@x", name, @([UIScreen mainScreen].scale)];
        imagePath = [[NSBundle mainBundle] pathForResource:newName ofType:type];
    }
    type = nil;
    
    return imagePath;
}

- (UIImage *)compressToSize:(CGSize)size {
    CGFloat scale = [UIScreen mainScreen].scale;
    // 创建一个bitmap的context
    // 并把它设置成为当前正在使用的context
    UIGraphicsBeginImageContextWithOptions(size, NO, scale);
    // 绘制改变大小的图片
    [self drawInRect:CGRectMake(0,0, size.width, size.height)];
    // 从当前context中创建一个改变大小后的图片
    UIImage *scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    // 使当前的context出堆栈
    UIGraphicsEndImageContext();
    //返回新的改变大小后的图片
    return scaledImage;
}

/**
 * 从图片中按指定的位置大小截取图片的一部分
 * UIImage image 原始的图片
 * CGRect rect 要截取的区域
 * CGFloat scale 截图放大的倍数（retine屏为2）
 */
+ (UIImage *)imageFromImage:(UIImage *)image inRect:(CGRect)rect scale:(CGFloat)scale {
    if (!image) {
        return nil;
    }
    CGImageRef sourceImageRef = [image CGImage];
    CGRect cutRect = CGRectMake(rect.origin.x * scale, rect.origin.y * scale, rect.size.width * scale, rect.size.height * scale);
    CGImageRef newImageRef = CGImageCreateWithImageInRect(sourceImageRef, cutRect);
    UIImage *newImage = [UIImage imageWithCGImage:newImageRef];
    CFRelease(newImageRef);
    return newImage;
}

// 压缩图片尺寸大小
- (UIImage *)imageToScale:(CGFloat)scale
{
    UIGraphicsBeginImageContext(CGSizeMake(self.size.width * scale, self.size.height * scale));
    [self drawInRect:CGRectMake(0, 0, self.size.width * scale, self.size.height * scale)];
    UIImage *scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return scaledImage;
}

/**
 *  高斯模糊
 *
 *  @param radius   radius 模糊的深度
 *  @param cutFrame 被裁减的区域
 *
 *  @return 模糊后的image
 */
- (UIImage *)convertToBlurImageWithInputRatius:(CGFloat)radius cutFrame:(CGRect)cutFrame {
    if (!self || !self.CGImage) {
        return nil;
    }
    CIContext *context = [CIContext contextWithOptions:nil];
    CIImage *image = [CIImage imageWithCGImage:self.CGImage];
    CIFilter *filter = [CIFilter filterWithName:@"CIGaussianBlur"]; // 高斯模糊
    [filter setValue:image forKey:kCIInputImageKey];
    [filter setValue:@(radius) forKey:@"inputRadius"];
    CIImage *result = [filter valueForKey:kCIOutputImageKey];
    CGFloat appScale = [UIScreen mainScreen].scale;
    CGImageRef outImage = [context createCGImage:result fromRect:CGRectMake(cutFrame.origin.x*self.scale, cutFrame.origin.y*self.scale, cutFrame.size.width*self.scale, cutFrame.size.height*self.scale)]; // 这里裁剪的scale必须是图片的scale，因为是裁剪图片的，不是裁剪为屏幕的，所以必须是image的scale
    UIImage *blurImage = [UIImage imageWithCGImage:outImage scale:appScale orientation:UIImageOrientationUp];
    CFRelease(outImage);
    return blurImage;
}

+ (UIImage *)imageWithColor:(UIColor *)color size:(CGSize)size isCircle:(BOOL)isCircle {
    if (!color || size.width <= 0 || size.height <= 0) return nil;
    CGRect rect = CGRectMake(0.0f, 0.0f, size.width, size.height);
    UIGraphicsBeginImageContextWithOptions(rect.size, NO, 0);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, color.CGColor);
    if (isCircle) {
        CGContextFillEllipseInRect(context, rect);
    } else {
        CGContextFillRect(context, rect);
    }
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

+ (UIImage *)scaleImage:(UIImage *)image scaleFactor:(float)scaleFloat {
    CGSize size = CGSizeMake((int)(image.size.width * scaleFloat), (int)(image.size.height * scaleFloat));
    
    UIGraphicsBeginImageContext(size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGAffineTransform transform = CGAffineTransformIdentity;
    transform = CGAffineTransformScale(transform, scaleFloat, scaleFloat);
    CGContextConcatCTM(context, transform);
    [image drawAtPoint:CGPointMake(0.0f, 0.0f)];
    UIImage *newimg = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newimg;
}

/*
 *  用于压缩图片
 */
+ (UIImage *)compressImage:(UIImage *)image
             compressRatio:(CGFloat)ratio {
    return [[self class] compressImage:image compressRatio:ratio maxCompressRatio:0.1f];
}

+ (UIImage *)compressImage:(UIImage *)image compressRatio:(CGFloat)ratio maxCompressRatio:(CGFloat)maxRatio
{
    
    //We define the max and min resolutions to shrink to
    int MIN_UPLOAD_RESOLUTION = 1136 * 640;
    int MAX_UPLOAD_SIZE = 50;
    
    float factor;
    float currentResolution = image.size.height * image.size.width;
    
    //We first shrink the image a little bit in order to compress it a little bit more
    if (currentResolution > MIN_UPLOAD_RESOLUTION) {
        factor = sqrt(currentResolution / MIN_UPLOAD_RESOLUTION) * 2;
        image = [self scaleDown:image withSize:CGSizeMake(image.size.width / factor, image.size.height / factor)];
    }
    
    //Compression settings
    CGFloat compression = ratio;
    CGFloat maxCompression = maxRatio;
    
    //We loop into the image data to compress accordingly to the compression ratio
    NSData *imageData = UIImageJPEGRepresentation(image, compression);
    while ([imageData length] > MAX_UPLOAD_SIZE && compression > maxCompression) {
        compression -= 0.10;
        imageData = UIImageJPEGRepresentation(image, compression);
    }
    
    //Retuns the compressed image
    DebugLog(@"compress image:%luKB",[imageData length]/1024);
    return [[UIImage alloc] initWithData:imageData];
}

+ (UIImage*)scaleDown:(UIImage*)image withSize:(CGSize)newSize
{
    
    //We prepare a bitmap with the new size
    UIGraphicsBeginImageContextWithOptions(newSize, YES, 0.0);
    
    //Draws a rect for the image
    [image drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
    
    //We set the scaled image from the context
    UIImage* scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return scaledImage;
}

+ (UIImage *)compoundImageWithTopImage:(UIImage *) topImage bottomImage:(UIImage *) bottomImage {
    CGSize size = CGSizeMake(topImage.size.width, topImage.size.height + bottomImage.size.height);
    UIGraphicsBeginImageContext(size);
    [topImage drawInRect:CGRectMake(0, 0, topImage.size.width, topImage.size.height)];
    [bottomImage drawInRect:CGRectMake(0, topImage.size.height, bottomImage.size.width, bottomImage.size.height)];
    
    UIImage *compoundImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return compoundImage;
}

- (UIImage *)circleImage {    // 获取上下文
    UIImage *result = [self imageByRoundCornerRadius:MIN(self.size.width, self.size.height)/2 borderWidth:0.0 borderColor:[UIColor grayColor]];
    return result;
}

- (UIImage *)imageWithColor:(UIColor *)color
{
    UIGraphicsBeginImageContextWithOptions(self.size, NO, self.scale);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextTranslateCTM(context, 0, self.size.height);
    CGContextScaleCTM(context, 1.0, -1.0);
    CGContextSetBlendMode(context, kCGBlendModeNormal);
    CGRect rect = CGRectMake(0, 0, self.size.width, self.size.height);
    CGContextClipToMask(context, rect, self.CGImage);
    [color setFill];
    CGContextFillRect(context, rect);
    UIImage*newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

@end
