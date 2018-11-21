//
//  SZTResourceLoader.m
//  PlayerWithDub
//
//  Created by 泽泰 舒 on 2018/11/7.
//  Copyright © 2018年 泽泰 舒. All rights reserved.
//

#import <MobileCoreServices/MobileCoreServices.h>
#import "LocalFileManager.h"
#import "SZTPlayerFileHandle.h"
#import "SZTPlayerResourceManager.h"
#import "SZTResourceLoader.h"

@interface SZTLoadingRequestInfo : NSObject

@property (nonatomic, strong) AVAssetResourceLoadingRequest *loadingRequest;
@property (nonatomic, assign) NSInteger requestedOffset;
@property (nonatomic, assign) NSInteger requestedLength;
@property (nonatomic, assign) NSInteger currentOffset;

@property (nonatomic, assign) NSURL *url;

- (instancetype)initWithLoadingRequest:(AVAssetResourceLoadingRequest *)loadingRequest;
- (void)respondWithData:(NSData *)data;
- (void)finishLoading;
- (void)fillInContentInformationWithResourceUrl:(NSString *)url fileLength:(NSUInteger)fileLength;

@end

#define kUnknowStartOffset -1

@interface SZTResourceLoader ()

@property (nonatomic, strong) NSMutableArray <SZTLoadingRequestInfo *>*loadingRequests;
@property (nonatomic, strong) NSString *resourceUrl;
@property (nonatomic, strong) NSURLSessionDataTask *task;

@property (nonatomic, strong) SZTPlayerFileHandle *fileHandle;
@property (nonatomic, assign) NSInteger resourceLength;
@property (nonatomic, assign) NSInteger currentStartOffset; // 本地数据开始的offset

@property (nonatomic, assign) BOOL enableCache;
@property (nonatomic, assign) BOOL canResponseToProgress;
@property (nonatomic, assign) BOOL resetting;
@property (nonatomic, assign) BOOL buffering;

@end

@implementation SZTResourceLoader

- (instancetype)initWithResourceUrl:(NSString *)resourceUrl {
    self = [super init];
    if (self) {
        _resourceUrl = resourceUrl;
        __weak typeof(self) weakself = self;
        _completion = ^(BOOL success, NSError *error) {
            [weakself completionWithSuccess:success error:error];
        };
        _dataHandler = ^(NSData *data, NSURLSessionDataTask *dataTask) {
            [weakself handlerProcessData:data withDataTask:dataTask];
        };
        _receiveHandler = ^(NSURLSessionDataTask *dataTask, NSURLResponse *response){
            [weakself readyForDataTask:dataTask withResponse:response];
        };
        _enableCache = YES;
        _currentStartOffset = kUnknowStartOffset;
        _fileHandle = [[SZTPlayerFileHandle alloc] initWithUrl:resourceUrl];
    }
    return self;
}

- (void)setDelegate:(id<SZTResourceLoaderDelegate>)delegate {
    _delegate = delegate;
    self.canResponseToProgress = [_delegate respondsToSelector:@selector(resourceLoader:didBufferToProgress:)];
}

- (NSString *)getCachedFileUrl {
    return self.fileHandle.cachedResourcePath;
}

- (void)dealloc {
    [self cancelDownloadAndClearTemp];
}

#pragma mark - 处理下载的完成和过程中的数据
- (void)readyForDataTask:(NSURLSessionDataTask *)dataTask withResponse:(NSURLResponse *)response {
    NSHTTPURLResponse * httpResponse = (NSHTTPURLResponse *)response;
    NSString * contentRange = [[httpResponse allHeaderFields] objectForKey:@"Content-Range"];
    NSString *fileLengthString = [[contentRange componentsSeparatedByString:@"/"] lastObject];
    NSInteger fileLength = fileLengthString.integerValue > 0 ? fileLengthString.integerValue : @(response.expectedContentLength).integerValue;
    NSLog(@"ready for download length:%ld", fileLength);
    
    self.resourceLength = fileLength;
}

- (void)handlerProcessData:(NSData *)data withDataTask:(NSURLSessionDataTask *)dataTask {
    while (self.resetting || _cancel) {
        return;
    }
    
    [self.fileHandle writeTempFileData:data];
    
    [self processLoadingRequests];
    if (self.canResponseToProgress) {
        double localNowOffset = self.currentStartOffset + self.fileHandle.fileLength;
        dispatch_async(dispatch_get_main_queue(), ^{
            [self->_delegate resourceLoader:self didBufferToProgress:localNowOffset/self.resourceLength];
        });
    }
}

- (void)completionWithSuccess:(BOOL)success error:(NSError *)error {
    if (success) {
        [self processLoadingRequests];
        if (_enableCache) {
            [self.fileHandle cacheTempFile];
        }
    }
    else {
        if (error.code == -999) {
            // canceled
        }
        else {
            NSLog(@"下载视频出错:%@", error);
            if (_delegate && [_delegate respondsToSelector:@selector(resourceLoader:didCompleteWithSuccess:error:)]) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self->_delegate resourceLoader:self didCompleteWithSuccess:success error:error];
                });
            }
        }
    }
}

- (void)loadResourceWithLoadingRequest:(SZTLoadingRequestInfo *)loadingRequest {
    @synchronized (self) {
        if (self.task) {
            if (loadingRequest.requestedOffset >= self.currentStartOffset
                && loadingRequest.requestedOffset < self.currentStartOffset + self.fileHandle.fileLength) {
                [self processLoadingRequests];
                if (self.isSeek) {
                    self.isSeek = NO;
                }
            }
            else {
                if (self.isSeek) {
                    self.enableCache = NO;
                    self.isSeek = NO;
                    [self newLoadResourceWithLoadingRequest:loadingRequest];
                }
            }
        }
        else {
            [self newLoadResourceWithLoadingRequest:loadingRequest];
        }
    }
}

/**
 建立下载资源的请求
 */
- (void)newLoadResourceWithLoadingRequest:(SZTLoadingRequestInfo *)loadingRequest {
    if (!self.buffering) {
        self.buffering = YES;
        if (_delegate && [_delegate respondsToSelector:@selector(resourceLoaderWillOneStartBuffer:)]) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [self->_delegate resourceLoaderWillOneStartBuffer:self];
            });
        }
    }
    self.resetting = YES;
    if (self.task) {
        [self.task cancel];
    }
    self.task = nil;
    long long requestedOffset = loadingRequest.requestedOffset;
    // ready for download
    self.currentStartOffset = requestedOffset;
    [self.fileHandle createTempFile];

    NSURL *url = loadingRequest.url;
    
    self.task = [[SZTPlayerResourceManager sharedInstance] dataTaskWithUrl:url.absoluteString offset:requestedOffset resourceLength:self.resourceLength];
    [self.task resume];
    self.resetting = NO;
}

- (void)processLoadingRequests {
    while (self.resetting) {
        return;
    }
    @try {
        NSMutableArray <SZTLoadingRequestInfo *>*completedRequests = [[NSMutableArray alloc] init];
        [self.loadingRequests enumerateObjectsUsingBlock:^(SZTLoadingRequestInfo * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([self processLoadingRequest:obj]) {
                [completedRequests addObject:obj];
            }
        }];
        [self.loadingRequests removeObjectsInArray:completedRequests];
    } @catch (NSException *exception) {
        NSError *error = [NSError errorWithDomain:@"player resource loader" code:-1 userInfo:@{NSLocalizedDescriptionKey:exception.description}];
        [self completionWithSuccess:NO error:error];
    }
}

- (BOOL)processLoadingRequest:(SZTLoadingRequestInfo *)loadingRequest {
    @autoreleasepool {
        [loadingRequest fillInContentInformationWithResourceUrl:self.resourceUrl fileLength:self.resourceLength];
        
        if (self.currentStartOffset == kUnknowStartOffset) {
            return NO;
        }
        NSInteger localNowOffset = self.currentStartOffset + self.fileHandle.fileLength;
        
        NSInteger currentOffset = loadingRequest.currentOffset;
        if (currentOffset == 0) {
            currentOffset = loadingRequest.requestedOffset;
        }
        NSInteger unReadLength = localNowOffset - currentOffset;
        if (unReadLength <= 0) {
            return NO; // NO data
        }
        NSInteger canReadLength = MIN(loadingRequest.requestedLength, unReadLength);
        
        NSRange dataRange = NSMakeRange(@(currentOffset - self.currentStartOffset).unsignedIntegerValue, @(canReadLength).unsignedIntegerValue);
        if (dataRange.location + dataRange.length > localNowOffset) {
            return NO; // 超出已下载的数据长度
        }
        else {
            NSData *subData = [self.fileHandle readTempFileDataWithRange:dataRange];
            [loadingRequest respondWithData:subData];
        }
        
        if (self.buffering) {
            self.buffering = YES;
            if (_delegate && [_delegate respondsToSelector:@selector(resourceLoaderDidEndNowBuffer:)]) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self->_delegate resourceLoaderDidEndNowBuffer:self];
                });
            }
        }
        
        NSInteger nowEndOffset = currentOffset + unReadLength;
        NSInteger expectedEndOffset = loadingRequest.requestedOffset + loadingRequest.requestedLength;
        if (nowEndOffset >= expectedEndOffset) {
            [loadingRequest finishLoading];
            return YES;
        }
    }
    return NO;
}

- (void)cancelDownloadAndClearTemp {
    if (self.task && self.task.state == NSURLSessionTaskStateRunning) {
        [self.task cancel];
    }
    self.task = nil;
    [self.fileHandle clearTempData];
}

- (void)setCancel:(BOOL)cancel {
    _cancel = cancel;
    [self cancelDownloadAndClearTemp];
}

#pragma mark - AVAssetResourceLoaderDelegate
- (BOOL)resourceLoader:(AVAssetResourceLoader *)resourceLoader shouldWaitForLoadingOfRequestedResource:(AVAssetResourceLoadingRequest *)loadingRequest {
    if (_cancel) {
        return NO;
    }
    SZTLoadingRequestInfo *requestInfo = [[SZTLoadingRequestInfo alloc] initWithLoadingRequest:loadingRequest];
    [self.loadingRequests addObject:requestInfo];
    [self loadResourceWithLoadingRequest:requestInfo];
    return YES;
}

- (void)resourceLoader:(AVAssetResourceLoader *)resourceLoader didCancelLoadingRequest:(AVAssetResourceLoadingRequest *)loadingRequest {
    @synchronized (self.loadingRequests) {
        __block NSInteger deleteIndex = -1;
        [self.loadingRequests enumerateObjectsUsingBlock:^(SZTLoadingRequestInfo * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([obj.loadingRequest isEqual:loadingRequest]) {
                deleteIndex = idx;
                *stop = YES;
            }
        }];
        if (deleteIndex > -1) {
            [self.loadingRequests removeObjectAtIndex:deleteIndex];
        }
    }
}

#pragma mark - lazy init
- (NSMutableArray<SZTLoadingRequestInfo *> *)loadingRequests {
    if (!_loadingRequests) {
        _loadingRequests = [[NSMutableArray alloc] init];
    }
    return _loadingRequests;
}

@end


@implementation SZTLoadingRequestInfo

- (instancetype)initWithLoadingRequest:(AVAssetResourceLoadingRequest *)loadingRequest
{
    self = [super init];
    if (self) {
        _loadingRequest = loadingRequest;
    }
    return self;
}

- (NSInteger)requestedOffset {
    _currentOffset = @(self.loadingRequest.dataRequest.requestedOffset).integerValue;
    return _currentOffset;
}

- (NSInteger)requestedLength {
    return self.loadingRequest.dataRequest.requestedLength;
}

- (NSInteger)currentOffset {
    return @(self.loadingRequest.dataRequest.currentOffset).integerValue;
}

- (NSURL *)url {
    return self.loadingRequest.request.URL;
}

- (void)respondWithData:(NSData *)data {
    [self.loadingRequest.dataRequest respondWithData:data];
}

- (void)finishLoading {
    if (!self.loadingRequest.isFinished) {
        [self.loadingRequest finishLoading];
    }
}

- (void)fillInContentInformationWithResourceUrl:(NSString *)url fileLength:(NSUInteger)fileLength {
    NSString *mimeType = url.mimeTypeForPathExtension;
    CFStringRef contentType = UTTypeCreatePreferredIdentifierForTag(kUTTagClassMIMEType, (__bridge CFStringRef)(mimeType), NULL);

    self.loadingRequest.contentInformationRequest.byteRangeAccessSupported = YES;
    self.loadingRequest.contentInformationRequest.contentType = CFBridgingRelease(contentType);
    self.loadingRequest.contentInformationRequest.contentLength = fileLength;
}

@end

@implementation NSString (MimeType)

- (NSString *)mimeTypeForPathExtension {
    NSString *extension = [self pathExtension];
    CFStringRef fileExtension = (__bridge  CFStringRef)extension;
    CFStringRef type = UTTypeCreatePreferredIdentifierForTag(kUTTagClassFilenameExtension, fileExtension, NULL);
    NSString *mimeType = (__bridge_transfer NSString *)UTTypeCopyPreferredTagWithClass(type, kUTTagClassMIMEType);
    if (type != NULL){
        CFRelease(type);
    }
    if(!mimeType){
        mimeType = @"application/octet-stream";
    }
    return mimeType;
}


@end
