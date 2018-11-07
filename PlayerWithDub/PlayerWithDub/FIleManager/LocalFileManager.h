//
//  LocalFileManager.h
//  CommercialTreadmill
//
//  Created by 泽泰 舒 on 16/9/13.
//  Copyright © 2016年 artiwares. All rights reserved.
//

#import <Foundation/Foundation.h>

static NSString *const kAWPlistExtension = @"plist";
static NSString *const kAWMp4Extension = @"mp4";
static NSString *const kAWMp3Extension = @"mp3";
static NSString *const kAWZipExtension = @"zip";
static NSString *const kAWJsonExtension = @"json";

@interface LocalFileManager : NSObject

/**
 *  获取Documents目录
 *
 *  @return 路径
 */
+ (NSString *)documentsDirectory;

/**
 *  获取Library/Cache目录
 *
 *  @return 路径
 */
+ (NSString *)libraryCacheDirectory;

/**
 *  获取Temp目录
 *
 *  @return 路径
 */
+ (NSString *)tempDirectory;

+ (BOOL)createDirectoryWithDirectory:(NSString *)directory;
+ (BOOL)isDirectoryWithPath:(NSString *)filePath;
+ (BOOL)removeLocalFileAtPath:(NSString *)filePath;

/**
 *  删除某个目录下指定扩展名的文件
 *
 *  @param filePathDirectory 目录
 *  @param ext               扩展名
 *
 *  @return 删除成功与否
 */
+ (BOOL)removeLocalFileAtDirectory:(NSString *)filePathDirectory withRemovedPathExtension:(NSString *)ext;

/**
 *  指定文件不进行icould同步
 *
 *  @param filePath 指定文件地址
 *
 *  @return 操作成功
 */
+ (BOOL)excludedFromBackupAttributeToItemAtPath:(NSString *)filePath;

/**
 *  获取本地文件大小
 *
 *  @param filePath 指定文件地址
 *
 *  @return 文件大小 bytes
 */
+ (NSUInteger)fileSizeAtPath:(NSString *)filePath;

@end
