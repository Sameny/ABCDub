//
//  ACBDubFileManager.h
//  PlayerWithDub
//
//  Created by 泽泰 舒 on 2018/11/6.
//  Copyright © 2018年 泽泰 舒. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ABCDubFileManager : NSObject

+ (NSString *)mp3DirectoryWithSubDirectory:(NSString *)subDirectory;
+ (NSString *)mp3FilePathWithSubDirectory:(NSString *)subDirectory fileName:(NSString *)fileName;
+ (NSString *)cafFilePathWithSubDirectory:(NSString *)subDirectory fileName:(NSString *)fileName;

// 合成的视频临时目录，每次退出d时清除
+ (NSString *)videoFileDirectory;

@end

NS_ASSUME_NONNULL_END
