//
//  APIClient.m
//  PlayerWithDub
//
//  Created by 泽泰 舒 on 2018/11/19.
//  Copyright © 2018年 泽泰 舒. All rights reserved.
//

#import "APIClient.h"

@interface APIClient ()



@end

@implementation APIClient
static NSString * const kHttpHeaderAccesstokenKey = @"X-TOKEN";

static APIClient *sharedAPIClient = nil;
+ (instancetype)sharedInstance {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSURL *baseUrl = [NSURL URLWithString:APIClientBaseUrl];
        sharedAPIClient = [[APIClient alloc] initWithBaseURL:baseUrl];
        sharedAPIClient.requestSerializer = [AFJSONRequestSerializer serializer];
        sharedAPIClient.requestSerializer.timeoutInterval = 20;
        sharedAPIClient.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/plain", @"multipart/form-data", @"application/json", @"text/html", @"image/jpeg", @"image/png", @"application/octet-stream", @"text/json", nil];
    });
    return sharedAPIClient;
}

- (NSURLSessionDataTask *)getWithUrl:(NSString *)url
                          parameters:(nullable NSDictionary *)parameters
                             success:(nullable APIClientCompletion)completion
                            progress:(nullable APIClientProgressHandler)progress
                             faliure:(nullable APIClientFaildHandler)failure {
    return [self GET:url parameters:parameters progress:progress success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (completion) {
            completion(task, responseObject);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (failure) {
            failure(task, error);
        }
    }];;
}

- (NSURLSessionDataTask *)postWithUrl:(NSString *)url
                           parameters:(NSDictionary *)parameters
                              success:(nullable APIClientCompletion)completion
                             progress:(nullable APIClientProgressHandler)progress
                              faliure:(nullable APIClientFaildHandler)failure {
    return [self POST:url parameters:parameters progress:progress success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (completion) {
            completion(task, responseObject);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (failure) {
            failure(task, error);
        }
    }];
}

- (NSURLSessionDataTask *)uploadDataWithUrl:(NSString *)url
                                 parameters:(NSArray <id<APIClientUploadDelegate>>*)parameters
                                    success:(APIClientCompletion)completion
                                   progress:(APIClientProgressHandler)progress
                                    faliure:(APIClientFaildHandler)failure {
    return [self POST:url parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        [APIClient appendPartWithParameters:parameters formData:formData];
    } progress:progress success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (completion) {
            completion(task, responseObject);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (failure) {
            failure(task, error);
        }
    }];
}

+ (NSURLSessionDataTask *)getWithUrl:(NSString *)url
                          parameters:(nullable NSDictionary *)parameters
                             success:(nullable APIClientCompletion)completion
                             faliure:(nullable APIClientFaildHandler)failure {
    return [APIClient getWithUrl:url parameters:parameters success:completion progress:nil faliure:failure];
}

+ (NSURLSessionDataTask *)getWithUrl:(NSString *)url
                          parameters:(nullable NSDictionary *)parameters
                             success:(nullable APIClientCompletion)completion
                            progress:(nullable APIClientProgressHandler)progress
                             faliure:(nullable APIClientFaildHandler)failure {
    return [[APIClient sharedInstance] getWithUrl:url parameters:parameters success:completion progress:progress faliure:failure];
}

+ (NSURLSessionDataTask *)postWithUrl:(NSString *)url
                           parameters:(NSDictionary *)parameters
                              success:(nullable APIClientCompletion)completion
                              faliure:(nullable APIClientFaildHandler)failure {
    return [APIClient postWithUrl:url parameters:parameters success:completion progress:nil faliure:failure];
}

+ (NSURLSessionDataTask *)postWithUrl:(NSString *)url
                           parameters:(NSDictionary *)parameters
                              success:(nullable APIClientCompletion)completion
                             progress:(nullable APIClientProgressHandler)progress
                              faliure:(nullable APIClientFaildHandler)failure {
    return [[APIClient sharedInstance] postWithUrl:url parameters:parameters success:completion progress:progress faliure:failure];
}

+ (NSURLSessionDataTask *)uploadDataWithUrl:(NSString *)url
                                 parameters:(NSArray <id<APIClientUploadDelegate>>*)parameters
                                    success:(APIClientCompletion)completion
                                   progress:(APIClientProgressHandler)progress
                                    faliure:(APIClientFaildHandler)failure {
    return [[APIClient sharedInstance] uploadDataWithUrl:url parameters:parameters success:completion progress:progress faliure:failure];
}

+ (void)appendPartWithParameters:(NSArray <id<APIClientUploadDelegate>>*)parameters formData:(id<AFMultipartFormData> _Nonnull)formData {
    [parameters enumerateObjectsUsingBlock:^(id<APIClientUploadDelegate>  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [formData appendPartWithFileURL:obj.fileUrl name:obj.name fileName:obj.fileName mimeType:obj.mineType error:nil];
    }];
}

@end


NSString * const kSZTImageMineType = @"image/jpeg";
NSString * const kSZTMP3MineType = @"audio/mp3";
NSString * const kSZTMP4MineType = @"video/mp4";
NSString *szt_pathExtensionWithMineType(NSString *mineType) {
    if ([mineType isEqualToString:kSZTImageMineType]) {
        return @"jpg";
    }
    else if ([mineType isEqualToString:kSZTMP3MineType]) {
        return @"mp3";
    }
    else if ([mineType isEqualToString:kSZTMP4MineType]) {
        return @"mp4";
    }
    return @"";
}

