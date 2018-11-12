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
@property (nonatomic, assign) NSUInteger requestedOffset;
@property (nonatomic, assign) NSUInteger requestedLength;
@property (nonatomic, assign) NSUInteger currentOffset;

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
@property (nonatomic, assign) long long resourceLength;
@property (nonatomic, assign) long long completedDownloadSize;
@property (nonatomic, assign) long long currentStartOffset; // 本地数据开始的offset

@property (nonatomic, assign) BOOL enableCache;
@property (nonatomic, assign) BOOL canResponseToProgress;

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

- (void)dealloc {
    [self cancelDownloadAndClear:NO];
}

#pragma mark - 处理下载的完成和过程中的数据
- (void)readyForDataTask:(NSURLSessionDataTask *)dataTask withResponse:(NSURLResponse *)response {
    NSHTTPURLResponse * httpResponse = (NSHTTPURLResponse *)response;
    NSString * contentRange = [[httpResponse allHeaderFields] objectForKey:@"Content-Range"];
    NSString *fileLengthString = [[contentRange componentsSeparatedByString:@"/"] lastObject];
    NSUInteger fileLength = fileLengthString.integerValue > 0 ? fileLengthString.integerValue : response.expectedContentLength;
    NSLog(@"ready for download length:%ld", fileLength);
    
    self.resourceLength = fileLength;
}

- (void)handlerProcessData:(NSData *)data withDataTask:(NSURLSessionDataTask *)dataTask {
    [self.fileHandle writeTempFileData:data];
    self.completedDownloadSize += data.length;
    
    [self processLoadingRequests];
    if (self.canResponseToProgress) {
        double localNowOffset = self.currentStartOffset + self.completedDownloadSize;
        [_delegate resourceLoader:self didBufferToProgress:localNowOffset/self.resourceLength];
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
        }
    }
    if (_delegate && [_delegate respondsToSelector:@selector(resourceLoader:didCompleteWithSuccess:error:)]) {
        [_delegate resourceLoader:self didCompleteWithSuccess:success error:error];
    }
}

- (void)loadResourceWithLoadingRequest:(SZTLoadingRequestInfo *)loadingRequest {
    @synchronized (self) {
        if (self.task) {
            if (loadingRequest.requestedOffset >= self.currentStartOffset
                && loadingRequest.requestedOffset < self.currentStartOffset + self.completedDownloadSize) {
                [self processLoadingRequests];
            }
            else {
                if (self.isSeek) {
                    self.enableCache = NO;
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
    long long requestedOffset = loadingRequest.requestedOffset;
    if (requestedOffset == 0) {
        [self cancelDownloadAndClear:YES];
    }
    else {
        [self cancelDownloadAndClear:!_enableCache];
    }
    // ready for download
    self.currentStartOffset = requestedOffset;
    self.completedDownloadSize = 0;
    [self.fileHandle createTempFile];

    NSURL *url = loadingRequest.url;
    
    self.task = [[SZTPlayerResourceManager sharedInstance] dataTaskWithUrl:url.absoluteString offset:requestedOffset resourceLength:self.resourceLength];
    [self.task resume];
}

- (void)processLoadingRequests {
    NSMutableArray <SZTLoadingRequestInfo *>*completedRequests = [[NSMutableArray alloc] init];
    [self.loadingRequests enumerateObjectsUsingBlock:^(SZTLoadingRequestInfo * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([self processLoadingRequest:obj]) {
            [completedRequests addObject:obj];
        }
    }];
    [self.loadingRequests removeObjectsInArray:completedRequests];
}

- (BOOL)processLoadingRequest:(SZTLoadingRequestInfo *)loadingRequest {
    @autoreleasepool {
        [loadingRequest fillInContentInformationWithResourceUrl:self.resourceUrl fileLength:self.resourceLength];
        
        if (self.currentStartOffset == kUnknowStartOffset) {
            return NO;
        }
        NSUInteger localNowOffset = self.currentStartOffset + self.completedDownloadSize;
        
        NSInteger currentOffset = loadingRequest.currentOffset;
        if (currentOffset == 0) {
            currentOffset = loadingRequest.requestedOffset;
        }
        NSUInteger unReadLength = localNowOffset - currentOffset;
        NSInteger canReadLength = MIN(loadingRequest.requestedLength, unReadLength);
        
        NSRange dataRange = NSMakeRange(currentOffset - self.currentStartOffset, canReadLength);
        if (dataRange.location + dataRange.length > self.completedDownloadSize) {
//            NSLog(@"超出已下载的数据长度");
            return NO;
//            NSData *subData = [fileData subdataWithRange:NSMakeRange(MIN(dataRange.location, fileData.length), 0)];
//            [loadingRequest respondWithData:subData];
        }
        else {
            NSData *subData = [self.fileHandle readTempFileDataWithRange:dataRange];
            [loadingRequest respondWithData:subData];
        }
        
        NSUInteger nowEndOffset = currentOffset + unReadLength;
        NSUInteger expectedEndOffset = loadingRequest.requestedOffset + loadingRequest.requestedLength;
        if (nowEndOffset >= expectedEndOffset) {
            [loadingRequest finishLoading];
            return YES;
        }
    }
    return NO;
}

- (void)cancelDownloadAndClear:(BOOL)clear {
    if (self.task && self.task.state == NSURLSessionTaskStateRunning) {
        [self.task cancel];
    }
    self.task = nil;
    if (clear) {
        if (self.task.state != NSURLSessionTaskStateCompleted) {
            [self.fileHandle clearTempData];
        }
    }
}

#pragma mark - AVAssetResourceLoaderDelegate
- (BOOL)resourceLoader:(AVAssetResourceLoader *)resourceLoader shouldWaitForLoadingOfRequestedResource:(AVAssetResourceLoadingRequest *)loadingRequest {
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

- (NSUInteger)requestedOffset {
    _currentOffset = self.loadingRequest.dataRequest.requestedOffset;
    return _currentOffset;
}

- (NSUInteger)requestedLength {
    return self.loadingRequest.dataRequest.requestedLength;
}

- (NSUInteger)currentOffset {
    return self.loadingRequest.dataRequest.currentOffset;
}

- (NSURL *)url {
    return self.loadingRequest.request.URL;
}

- (void)respondWithData:(NSData *)data {
    [self.loadingRequest.dataRequest respondWithData:data];
}

- (void)finishLoading {
    [self.loadingRequest finishLoading];
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
