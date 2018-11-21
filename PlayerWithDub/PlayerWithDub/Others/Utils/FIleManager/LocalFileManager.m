//
//  LocalFileManager.m
//  CommercialTreadmill
//
//  Created by 泽泰 舒 on 16/9/13.
//  Copyright © 2016年 artiwares. All rights reserved.
//
#import "LocalFileManager.h"

@implementation LocalFileManager

/**
 *  获取Documents目录
 *
 *  @return 路径
 */
+ (NSString *)documentsDirectory {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    return documentsDirectory;
}

/**
 *  获取Library/Cache目录
 *
 *  @return 路径
 */
+ (NSString *)libraryCacheDirectory {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString *libraryCachePath = [paths objectAtIndex:0];
    [LocalFileManager excludedFromBackupAttributeToItemAtPath:libraryCachePath]; // 设置不同步到icould
    return libraryCachePath;
}

/**
 *  获取Temp目录
 *
 *  @return 路径
 */
+ (NSString *)tempDirectory {
    return NSTemporaryDirectory();
}

/**
 *  删除某个目录下指定扩展名的文件
 *
 *  @param filePathDirectory 目录
 *  @param ext               扩展名
 *
 *  @return 删除成功与否
 */
+ (BOOL)removeLocalFileAtDirectory:(NSString *)filePathDirectory withRemovedPathExtension:(NSString *)ext {
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSError *err;
    NSArray *contents = [fileManager contentsOfDirectoryAtPath:filePathDirectory error:&err];
    if (err) {
        return NO;
    }
    NSString *filename;
    for (NSInteger i = 0; i < contents.count; i++) {
        filename = [filePathDirectory stringByAppendingPathComponent:contents[i]];
        if ([filename.pathExtension isEqualToString:ext]) {
            [fileManager removeItemAtPath:filename error:nil];
        }
    }
    
    return YES;
}

+ (BOOL)removeLocalFileAtPath:(NSString *)filePath {
    if (!filePath) {
        return NO;
    }
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if (![fileManager fileExistsAtPath:filePath]) {
        return YES;
    }
    return [fileManager removeItemAtPath:filePath error:nil];
}

+ (BOOL)excludedFromBackupAttributeToItemAtPath:(NSString *)filePath {
    NSURL *URL = [NSURL fileURLWithPath:filePath];
    //assert([[NSFileManager defaultManager] fileExistsAtPath:[URL path]]);
    
    NSError *error = nil;
    BOOL success = [URL setResourceValue:@(YES) forKey:NSURLIsExcludedFromBackupKey error:&error];
    if(!success){
        NSLog(@"Error excluding %@ from backup %@", [URL lastPathComponent], error);
    }
    return success;
}

+ (BOOL)createDirectoryWithDirectory:(NSString *)directory {
    if ([LocalFileManager isDirectoryWithPath:directory]) {
        return YES;
    }
    BOOL isDirectory;
    if ([[NSFileManager defaultManager] fileExistsAtPath:directory isDirectory:&isDirectory]) {
        if (isDirectory) {
            return YES;
        }
    }
    
    NSError *error;
    if ([[NSFileManager defaultManager] createDirectoryAtPath:directory withIntermediateDirectories:YES attributes:nil error:&error]) {
        return YES;
    }
    NSLog(@"生成目录失败");
    return NO;
}

+ (BOOL)isDirectoryWithPath:(NSString *)filePath {
    BOOL isDirectory;
    if (![[NSFileManager defaultManager] fileExistsAtPath:filePath isDirectory:&isDirectory]) {
        return NO;
    }
    return isDirectory;
}

+ (NSUInteger)fileSizeAtPath:(NSString *)filePath {
    BOOL isDirectory;
    if (![[NSFileManager defaultManager] fileExistsAtPath:filePath isDirectory:&isDirectory]) {
        return 0;
    }
    
    NSUInteger cacheSize = 0;
    if (isDirectory) {
        NSArray *components = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:filePath error:nil];
        if (components.count == 0) {
            return 0;
        }
        
        for (NSString *fileName in components) {
            NSString *subPath = [filePath stringByAppendingPathComponent:fileName];
            cacheSize += [LocalFileManager fileSizeAtPath:subPath];
        }
    } else {
        NSDictionary *fileAttributes = [[NSFileManager defaultManager] attributesOfItemAtPath:filePath error:nil];
        if (fileAttributes) {
            cacheSize += fileAttributes.fileSize;
        }
    }
    return cacheSize;
}

@end
