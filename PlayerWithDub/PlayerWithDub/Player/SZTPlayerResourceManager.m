//
//  SZTPlayerResourceManager.m
//  PlayerWithDub
//
//  Created by 泽泰 舒 on 2018/11/8.
//  Copyright © 2018年 泽泰 舒. All rights reserved.
//

#import <AFNetworking/AFURLSessionManager.h>
#import "LocalFileManager.h"

#import "SZTPlayerResourceManager.h"

@interface SZTPlayerResourceManager () <NSURLSessionDataDelegate>

@property (nonatomic, strong) NSMutableDictionary <NSString *,SZTResourceLoader *>*resourceLoaders;
@property (nonatomic, strong) dispatch_queue_t resourceLoaderQueue;

@property (nonatomic, strong) NSURLSession *session;
@property (nonatomic, strong) NSOperationQueue *sessionQueue;

@end

static SZTPlayerResourceManager *sharedPlayerResourceManager;
@implementation SZTPlayerResourceManager

+ (instancetype)sharedInstance {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedPlayerResourceManager = [[SZTPlayerResourceManager alloc] init];
    });
    return sharedPlayerResourceManager;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
        self.session = [NSURLSession sessionWithConfiguration:config delegate:self delegateQueue:[NSOperationQueue mainQueue]];
    }
    return self;
}

- (NSURLSessionDataTask *)dataTaskWithUrl:(NSString *)url offset:(long long)offset resourceLength:(long long)resourceLength  {
    if (!url && url.length == 0) {
        return nil;
    }
    url = [self resourceLoaderUrlWithUrl:url];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url] cachePolicy:(NSURLRequestReloadIgnoringLocalCacheData) timeoutInterval:15.f];
    if (offset > 0 && resourceLength > 0) {
        NSString *range = [NSString stringWithFormat:@"bytes=%ld-%ld",(unsigned long)offset, (unsigned long)resourceLength - 1];
        [request addValue:range forHTTPHeaderField:@"Range"];
    }

    NSURLSessionDataTask *task = [self.session dataTaskWithRequest:request];
    return task;
}

- (SZTResourceLoader *)resourceLoaderWithUrl:(NSString *)url {
    if (!url && url.length == 0) {
        return nil;
    }
    url = [self resourceLoaderUrlWithUrl:url];
    if ([self.resourceLoaders containsObjectForKey:url]) {
        return self.resourceLoaders[url];
    }
    SZTResourceLoader *resourceLoader = [[SZTResourceLoader alloc] initWithResourceUrl:url];
    dispatch_sync(self.resourceLoaderQueue, ^{
        [self.resourceLoaders setObject:resourceLoader forKey:url];
    });
    return resourceLoader;
}

- (BOOL)resourceLoaderExistsWithUrl:(NSString *)url {
    if (!url && url.length == 0) {
        return NO;
    }
    url = [self resourceLoaderUrlWithUrl:url];
    return [self.resourceLoaders containsObjectForKey:url];
}

- (SZTResourceLoader *)existsResourceLoaderWithUrl:(NSString *)url {
    url = [self resourceLoaderUrlWithUrl:url];
    if ([self resourceLoaderExistsWithUrl:url]) {
        return self.resourceLoaders[url];
    }
    return nil;
}

- (BOOL)cancelResourceLoaderWithUrl:(NSString *)url {
    if (!url && url.length == 0) {
        return NO;
    }
    url = [self resourceLoaderUrlWithUrl:url];
    if ([self.resourceLoaders containsObjectForKey:url]) {
        dispatch_sync(self.resourceLoaderQueue, ^{
            [self.resourceLoaders removeObjectForKey:url];
        });
    }
    return YES;
}

- (NSString *)resourceLoaderUrlWithUrl:(NSString *)url {
    if ([url hasPrefix:ABCVideoPrefix]) {
        url = [url substringFromIndex:ABCVideoPrefix.length];
    }
    return url;
}

#pragma mark - NSURLSessionDelegate & NSURLSessionDataDelegate
- (void)URLSession:(NSURLSession *)session didBecomeInvalidWithError:(nullable NSError *)error {
    dispatch_sync(self.resourceLoaderQueue, ^{
        for (SZTResourceLoader *downloader in self.resourceLoaders) {
            if (downloader.completion) {
                downloader.completion(NO, error);
            }
        }
    });
}

- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task didCompleteWithError:(NSError *)error {
    NSString *originUrl = task.originalRequest.URL.absoluteString;
    SZTResourceLoader *resourceLoader = [self existsResourceLoaderWithUrl:originUrl];
    if (resourceLoader && resourceLoader.completion) {
        resourceLoader.completion(error == nil, error);
    }
}

- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask
didReceiveResponse:(NSURLResponse *)response
 completionHandler:(void (^)(NSURLSessionResponseDisposition disposition))completionHandler {
    
    NSString *originUrl = dataTask.originalRequest.URL.absoluteString;
    SZTResourceLoader *resourceLoader = [self existsResourceLoaderWithUrl:originUrl];
    if (resourceLoader && resourceLoader.receiveHandler) {
        resourceLoader.receiveHandler(dataTask, response);
    }
    if (completionHandler) {
        completionHandler(NSURLSessionResponseAllow);
    }
}

- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask
    didReceiveData:(NSData *)data {
    NSString *originUrl = dataTask.originalRequest.URL.absoluteString;
    SZTResourceLoader *resourceLoader = [self existsResourceLoaderWithUrl:originUrl];
    if (resourceLoader && resourceLoader.dataHandler) {
        resourceLoader.dataHandler(data, dataTask);
    }
}

#pragma mark - lazy init
- (NSMutableDictionary<NSString *,SZTResourceLoader *> *)resourceLoaders {
    if (!_resourceLoaders) {
        _resourceLoaders = [[NSMutableDictionary alloc] init];
    }
    return _resourceLoaders;
}

- (dispatch_queue_t)resourceLoaderQueue {
    if (!_resourceLoaderQueue) {
        _resourceLoaderQueue = dispatch_queue_create("com.szt.resourceLoader.queue", DISPATCH_QUEUE_SERIAL);
    }
    return _resourceLoaderQueue;
}

- (NSOperationQueue *)sessionQueue {
    if (!_sessionQueue) {
        _sessionQueue = [[NSOperationQueue alloc] init];
        _sessionQueue.maxConcurrentOperationCount = 1;
    }
    return _sessionQueue;
}

#pragma mark - class methods
+ (BOOL)cacheExistsAtVideoPath:(NSString *)videoPath {
    if (!videoPath || videoPath.length == 0) {
        return NO;
    }
    return [LocalFileManager fileSizeAtPath:videoPath] > 0;
}

@end
