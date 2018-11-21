//
//  APIManager.m
//  PlayerWithDub
//
//  Created by 泽泰 舒 on 2018/11/20.
//  Copyright © 2018年 泽泰 舒. All rights reserved.
//

#import "APIRequestObject.h"

#import "APIClient.h"
#import "APIManager.h"

@interface APIManager ()

@property (nonatomic, strong) NSMapTable <NSString *, APIRequestObject *>*requestObjects;
@property (nonatomic, strong) dispatch_queue_t requestObjectQueue;

@end

@implementation APIManager

- (APIRequestObject *)getRequestObjectWithUrl:(NSString *)url parammeters:(nullable NSDictionary *)parameters responseDataHandler:(nullable NSObject *)responseDataHandler failureDataHandler:(nullable NSObject *)failureDataHandler {
    return [self getRequestObjectWithUrl:url parammeters:parameters responseDataHandler:responseDataHandler progressDataHandler:nil failureDataHandler:failureDataHandler];
}

- (APIRequestObject *)getRequestObjectWithUrl:(NSString *)url parammeters:(nullable NSDictionary *)parameters responseDataHandler:(nullable NSObject *)responseDataHandler progressDataHandler:(nullable NSObject *)progressDataHandler failureDataHandler:(nullable NSObject *)failureDataHandler {
    NSURLSessionDataTask *task = [APIClient getWithUrl:url parameters:parameters success:^(NSURLSessionDataTask *task, id responseObject) {
        if (responseDataHandler) {
            [responseDataHandler handleApiResponseData:responseObject forTask:task];
        }
    } progress:^(NSProgress *progress) {
        if (progressDataHandler) {
            [progressDataHandler handleApiProgress:progress];
        }
    } faliure:^(NSURLSessionDataTask *task, NSError *error) {
        if (failureDataHandler) {
            [failureDataHandler handleApiFailureWithError:error forTask:task];
        }
    }];
    if (!task) {
        return nil;
    }
    APIRequestObject *requestObject = [[APIRequestObject alloc] initWithUrl:url task:task];
//    [self addRequestObject:requestObject forKey:url];
    return requestObject;
}

- (APIRequestObject *)postRequestObjectWithUrl:(NSString *)url parammeters:(nullable NSDictionary *)parameters responseDataHandler:(nullable NSObject *)responseDataHandler failureDataHandler:(nullable NSObject *)failureDataHandler {
    return [self postRequestObjectWithUrl:url parammeters:parameters responseDataHandler:responseDataHandler progressDataHandler:nil failureDataHandler:failureDataHandler];
}

- (APIRequestObject *)postRequestObjectWithUrl:(NSString *)url parammeters:(NSDictionary *)parameters responseDataHandler:(nullable NSObject *)responseDataHandler progressDataHandler:(nullable NSObject *)progressDataHandler failureDataHandler:(nullable NSObject *)failureDataHandler {
    NSURLSessionDataTask *task = [APIClient postWithUrl:url parameters:parameters success:^(NSURLSessionDataTask *task, id responseObject) {
        if (responseDataHandler) {
            [responseDataHandler handleApiResponseData:responseObject forTask:task];
        }
    } progress:^(NSProgress *progress) {
        if (progressDataHandler) {
            [progressDataHandler handleApiProgress:progress];
        }
    } faliure:^(NSURLSessionDataTask *task, NSError *error) {
        if (failureDataHandler) {
            [failureDataHandler handleApiFailureWithError:error forTask:task];
        }
    }];
    if (!task) {
        return nil;
    }
    APIRequestObject *requestObject = [[APIRequestObject alloc] initWithUrl:url task:task];
    //    [self addRequestObject:requestObject forKey:url];
    return requestObject;
}

+ (APIRequestObject *)uploadDataWithUrl:(NSString *)url
                                 parameters:(NSArray <APIUploadParamObject *>*)parameters
                    responseDataHandler:(nullable NSObject *)responseDataHandler
                    progressDataHandler:(nullable NSObject *)progressDataHandler
                     failureDataHandler:(nullable NSObject *)failureDataHandler {
    NSURLSessionDataTask *task = [APIClient uploadDataWithUrl:url parameters:parameters success:^(NSURLSessionDataTask *task, id responseObject) {
        if (responseDataHandler) {
            [responseDataHandler handleApiResponseData:responseObject forTask:task];
        }
    } progress:^(NSProgress *progress) {
        if (progressDataHandler) {
            [progressDataHandler handleApiProgress:progress];
        }
    } faliure:^(NSURLSessionDataTask *task, NSError *error) {
        if (failureDataHandler) {
            [failureDataHandler handleApiFailureWithError:error forTask:task];
        }
    }];
    if (!task) {
        return nil;
    }
    APIRequestObject *requestObject = [[APIRequestObject alloc] initWithUrl:url task:task];
    //    [self addRequestObject:requestObject forKey:url];
    return requestObject;
}

#pragma mark - requestObjects
- (void)addRequestObject:(APIRequestObject *)requestObject forKey:(NSString *)key {
    [self filterRequestObjects];
    dispatch_sync(self.requestObjectQueue, ^{
        [self.requestObjects setObject:requestObject forKey:key];
    });
}

- (void)filterRequestObjects {
    dispatch_sync(self.requestObjectQueue, ^{
        NSEnumerator *enumerator = [self.requestObjects keyEnumerator];
        NSString *key;
        NSMutableArray <NSString *>*removedKeys = [NSMutableArray array];
        while (key = [enumerator nextObject]) {
            if ([self.requestObjects objectForKey:key] == nil) {
                [removedKeys addObject:key];
            }
        }
        [removedKeys enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [self.requestObjects removeObjectForKey:obj];
        }];
    });
}

- (NSMapTable<NSString *, APIRequestObject *> *)requestObjects {
    if (!_requestObjects) {
        _requestObjects = [NSMapTable mapTableWithKeyOptions:(NSMapTableStrongMemory) valueOptions:NSMapTableWeakMemory];
    }
    return _requestObjects;
}

- (dispatch_queue_t)requestObjectQueue {
    if (!_requestObjectQueue) {
        _requestObjectQueue = dispatch_queue_create("api manager request object queue", DISPATCH_QUEUE_SERIAL);
    }
    return _requestObjectQueue;
}

@end


@implementation APIUploadParamObject

- (BOOL)isValid {
    return self.fileUrl.isFileURL;
}

- (NSString *)name {
    return self.fileUrl.path;
}

- (NSString *)fileName {
    NSString *lastPathComponent = [self.fileUrl.pathComponents lastObject];
    if (lastPathComponent.pathExtension.length > 0) {
        return lastPathComponent;
    }
    NSString *pathExtension = szt_pathExtensionWithMineType(self.mineType);
    return [lastPathComponent stringByAppendingPathExtension:pathExtension];
}

@end
