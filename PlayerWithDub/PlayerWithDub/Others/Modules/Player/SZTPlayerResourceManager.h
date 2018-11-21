//
//  SZTPlayerResourceManager.h
//  PlayerWithDub
//
//  Created by 泽泰 舒 on 2018/11/8.
//  Copyright © 2018年 泽泰 舒. All rights reserved.
//

#import "SZTResourceLoader.h"

NS_ASSUME_NONNULL_BEGIN

@interface SZTPlayerResourceManager : NSObject

+ (instancetype)sharedInstance;

- (NSURLSessionDataTask *)dataTaskWithUrl:(NSString *)url offset:(long long)offet resourceLength:(long long)resourceLength;

// method will new a loader if it now exists
- (SZTResourceLoader *)resourceLoaderWithUrl:(NSString *)url;
// method will return a existing loader 
- (SZTResourceLoader *)existsResourceLoaderWithUrl:(NSString *)url;

- (void)clear;

+ (BOOL)cacheExistsAtVideoPath:(NSString *)videoPath;


@end

NS_ASSUME_NONNULL_END
