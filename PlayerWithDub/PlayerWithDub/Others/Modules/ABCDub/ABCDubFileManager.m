//
//  ACBDubFileManager.m
//  PlayerWithDub
//
//  Created by 泽泰 舒 on 2018/11/6.
//  Copyright © 2018年 泽泰 舒. All rights reserved.
//

#import "LocalFileManager.h"
#import "ABCDubFileManager.h"

static NSString * const kABCComposeVideoDirectoryName = @"compose_video";
static NSString * const kABCDubMP3DirectoryName = @"dub_mp3";
static NSString * const kABCDubCAFDirectoryName = @"dub_caf";

NSString * dubFileDirectory(NSString *directoryName, BOOL needCached) {
    NSString *directory;
    if (needCached) {
        directory = [[LocalFileManager libraryCacheDirectory] stringByAppendingPathComponent:directoryName];
    }
    else {
        directory = [[LocalFileManager tempDirectory] stringByAppendingPathComponent:directoryName];
    }
    if ([LocalFileManager createDirectoryWithDirectory:directory]) {
        return directory;
    }
    return nil;
}

@implementation ABCDubFileManager

+ (NSString *)mp3DirectoryWithSubDirectory:(NSString *)subDirectory {
    NSString *directory = dubFileDirectory([kABCDubMP3DirectoryName stringByAppendingPathComponent:subDirectory], YES);
    return directory;
}

+ (NSString *)mp3FilePathWithSubDirectory:(NSString *)subDirectory fileName:(NSString *)fileName {
    NSString *directory = dubFileDirectory([kABCDubMP3DirectoryName stringByAppendingPathComponent:subDirectory], YES);
    return [ABCDubFileManager filePathWithDirectory:directory fileName:fileName extension:@"mp3"];
}

+ (NSString *)cafFilePathWithSubDirectory:(NSString *)subDirectory fileName:(NSString *)fileName {
    NSString *directory = dubFileDirectory([kABCDubCAFDirectoryName stringByAppendingPathComponent:subDirectory], YES);
    return [ABCDubFileManager filePathWithDirectory:directory fileName:fileName extension:@"caf"];
}

+ (NSString *)filePathWithDirectory:(NSString *)directory fileName:(NSString *)fileName extension:(NSString *)extension {
    if (directory) {
        NSString *pathExtension = fileName.pathExtension;
        if (pathExtension.length == 0 || ![pathExtension isEqualToString:extension]) {
            fileName = [[fileName stringByDeletingPathExtension] stringByAppendingPathExtension:extension];
        }
        return [directory stringByAppendingPathComponent:fileName];
    }
    return nil;
}

// 合成的视频临时目录，每次退出时清除
+ (NSString *)videoFileDirectory {
    return dubFileDirectory(kABCComposeVideoDirectoryName, YES);
}

@end
