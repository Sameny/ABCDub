//
//  SZTPlayerFileHandle.h
//  PlayerWithDub
//
//  Created by 泽泰 舒 on 2018/11/12.
//  Copyright © 2018年 泽泰 舒. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface SZTPlayerFileHandle : NSObject

- (instancetype)initWithUrl:(NSString *)url;
- (BOOL)createTempFile;
- (void)writeTempFileData:(NSData *)data;
- (NSData *)readTempFileDataWithRange:(NSRange)range;
- (void)cacheTempFile;
- (BOOL)clearTempData;

+ (NSString *)cacheFileExistsWithURL:(NSURL *)url;
+ (BOOL)clearAllResourceCaches;

@end

NS_ASSUME_NONNULL_END
