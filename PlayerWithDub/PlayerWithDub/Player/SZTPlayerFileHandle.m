//
//  SZTPlayerFileHandle.m
//  PlayerWithDub
//
//  Created by 泽泰 舒 on 2018/11/12.
//  Copyright © 2018年 泽泰 舒. All rights reserved.
//

#import "LocalFileManager.h"
#import "SZTPlayerFileHandle.h"

static NSString * const kSZTPlayerVideoDirectoryName = @"video_cache";

NSString * szt_cacheResourceDirectory() {
    NSString *directory = [[LocalFileManager libraryCacheDirectory] stringByAppendingPathComponent:kSZTPlayerVideoDirectoryName];
    if ([LocalFileManager createDirectoryWithDirectory:directory]) {
        return directory;
    }
    return nil;
}

NSString * szt_cacheResourcePath(NSString *fileName) {
    return [szt_cacheResourceDirectory() stringByAppendingString:fileName];
}

@interface SZTPlayerFileHandle ()

@property (nonatomic, strong) NSString *resourceUrl;
@property (nonatomic, strong) NSString *cachedResourcePath;
@property (nonatomic, strong) NSString *tempResourcePath;
@property (nonatomic, strong) NSFileHandle *writeFileHandle;
@property (nonatomic, strong) NSFileHandle *readFileHandle;

@end

@implementation SZTPlayerFileHandle

- (instancetype)initWithUrl:(NSString *)url {
    self = [super init];
    if (self) {
        _resourceUrl = url;
        if (!self.tempResourcePath) {
            return nil;
        }
        _readFileHandle = [NSFileHandle fileHandleForReadingAtPath:self.tempResourcePath];
        _writeFileHandle = [NSFileHandle fileHandleForWritingAtPath:self.tempResourcePath];
    }
    return self;
}

- (void)dealloc {
    [self.readFileHandle closeFile];
    [self.writeFileHandle closeFile];
}

- (BOOL)createTempFile {
    NSFileManager * manager = [NSFileManager defaultManager];
    if ([manager fileExistsAtPath:self.tempResourcePath]) {
        [manager removeItemAtPath:self.tempResourcePath error:nil];
    }
    return [manager createFileAtPath:self.tempResourcePath contents:nil attributes:nil];
}

- (void)writeTempFileData:(NSData *)data {
    [self.writeFileHandle seekToEndOfFile];
    [self.writeFileHandle writeData:data];
    [self.writeFileHandle synchronizeFile];
}

- (NSData *)readTempFileDataWithRange:(NSRange)range {
    [self.readFileHandle seekToFileOffset:range.location];
    return [self.readFileHandle readDataOfLength:range.length];
}

- (void)cacheTempFile {
    if ([LocalFileManager fileSizeAtPath:self.cachedResourcePath] > 0) {
        [LocalFileManager removeLocalFileAtPath:self.cachedResourcePath];
    }

    BOOL success = [[NSFileManager defaultManager] copyItemAtPath:self.tempResourcePath toPath:self.cachedResourcePath error:nil];
    [self clearTempData];
    NSLog(@"cache file : %@", success ? @"success" : @"fail");
}

- (NSString *)cachedResourcePath {
    if (!_cachedResourcePath) {
        if (_resourceUrl.lastPathComponent.length > 0) {
            _cachedResourcePath = szt_cacheResourcePath([NSString stringWithFormat:@"%@", _resourceUrl.lastPathComponent]);
        }
    }
    return _cachedResourcePath;
}

- (NSString *)tempResourcePath {
    if (!_tempResourcePath) {
        _tempResourcePath = szt_cacheResourcePath([NSString stringWithFormat:@"temp_%@", _resourceUrl.lastPathComponent]);
    }
    return _tempResourcePath;
}

- (BOOL)clearTempData {
    NSFileManager * manager = [NSFileManager defaultManager];
    return [manager removeItemAtPath:self.tempResourcePath error:nil];
}


+ (NSString *)cacheFileExistsWithURL:(NSURL *)url {
    NSString *cacheFilePath = szt_cacheResourcePath([NSString stringWithFormat:@"%@_temp", url.path.lastPathComponent]);
    if ([[NSFileManager defaultManager] fileExistsAtPath:cacheFilePath]) {
        return cacheFilePath;
    }
    return nil;
}

+ (BOOL)clearAllResourceCaches {
    NSFileManager * manager = [NSFileManager defaultManager];
    return [manager removeItemAtPath:szt_cacheResourceDirectory() error:nil];
}

@end

