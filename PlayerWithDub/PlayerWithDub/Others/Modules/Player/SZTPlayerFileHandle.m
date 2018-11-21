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

@property (nonatomic, assign) NSInteger fileLength;

@end

@implementation SZTPlayerFileHandle

- (instancetype)initWithUrl:(NSString *)url {
    self = [super init];
    if (self) {
        _resourceUrl = url;
        if (!self.tempResourcePath) {
            return nil;
        }
    }
    return self;
}

- (void)dealloc {
    if (_readFileHandle) {
        [self.readFileHandle closeFile];
    }
    if (_writeFileHandle) {
        [self.writeFileHandle closeFile];
    }
}

- (BOOL)createTempFile {
    NSFileManager * manager = [NSFileManager defaultManager];
    if ([manager fileExistsAtPath:self.tempResourcePath]) {
        NSError *error;
        [manager removeItemAtPath:self.tempResourcePath error:&error];
        if (error) {
            NSLog(@"%@", error);
        }
    }
    BOOL success = [manager createFileAtPath:self.tempResourcePath contents:nil attributes:nil];
    if (success) {
        [self updateFileHandle];
    }
    return success;
}

- (void)updateFileHandle {
    if (_readFileHandle) {
        [_readFileHandle closeFile];
    }
    _readFileHandle = [NSFileHandle fileHandleForReadingAtPath:self.tempResourcePath];
    if (_writeFileHandle) {
        [_writeFileHandle closeFile];
    }
    _writeFileHandle = [NSFileHandle fileHandleForWritingAtPath:self.tempResourcePath];
    _fileLength = 0;
}

- (void)writeTempFileData:(NSData *)data {
    [self.writeFileHandle seekToEndOfFile];
    [self.writeFileHandle writeData:data];
    [self.writeFileHandle synchronizeFile];
    _fileLength += data.length;
}

- (NSData *)readTempFileDataWithRange:(NSRange)range {
    if (range.location + range.length > _fileLength) {
        return [NSData data];
    }
    [self.readFileHandle seekToFileOffset:range.location];
    return [self.readFileHandle readDataOfLength:range.length];
}

- (NSData *)allData {
    [self.readFileHandle seekToFileOffset:0];
    return [self.readFileHandle readDataToEndOfFile];
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
    BOOL success = [manager removeItemAtPath:self.tempResourcePath error:nil];
    if (success) {
        [self updateFileHandle];
    }
    return success;
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

