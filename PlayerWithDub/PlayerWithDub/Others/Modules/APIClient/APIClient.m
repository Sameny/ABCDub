//
//  APIClient.m
//  PlayerWithDub
//
//  Created by 泽泰 舒 on 2018/11/19.
//  Copyright © 2018年 泽泰 舒. All rights reserved.
//

#import "APIClient.h"

typedef NS_ENUM(NSUInteger, APIClientMethod) {
    APIClientMethodGet,
    APIClientMethodPost,
    APIClientMethodPut,
};

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
    });
    return sharedAPIClient;
}

- (NSURLSessionDataTask *)requestWithUrl:(NSString *)url
                              method:(APIClientMethod)method
                          parameters:(NSDictionary *)parameters
                             success:(APIClientCompletion)completion
                            progress:(APIClientProgressHandler)progress
                             faliure:(APIClientFaildHandler)failure {
    DebugLog(@"request path %@\nmethod : %ld\nparams %@\n", url, method, parameters);
    dispatch_async(dispatch_get_main_queue(), ^{
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    });
    
    NSURLSessionDataTask *dataTask;
    switch (method) {
        case APIClientMethodPut: {
            dataTask = [self POST:url parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
                
            } progress:progress success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                // TODO: success handler
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                // TODO: failure handler
            }];
        }
            break;
        case APIClientMethodPost: {
            dataTask = [self POST:url parameters:parameters progress:progress success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                
                // TODO: success handler
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                
                // TODO: failure handler
            }];
        }
            break;
        case APIClientMethodGet: {
             dataTask = [self GET:url parameters:parameters progress:progress success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                
                // TODO: success handler
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                // TODO: failure handler
            }];
        }
            break;
    }
    return dataTask;
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
    return [[APIClient sharedInstance] requestWithUrl:url method:APIClientMethodGet parameters:parameters success:completion progress:progress faliure:failure];
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
    return [[APIClient sharedInstance] requestWithUrl:url method:APIClientMethodPost parameters:parameters success:completion progress:progress faliure:failure];
}

+ (NSURLSessionDataTask *)putWithUrl:(NSString *)url
                          parameters:(NSDictionary *)parameters
                             success:(APIClientCompletion)completion
                            progress:(APIClientProgressHandler)progress
                             faliure:(APIClientFaildHandler)failure {
    return [[APIClient sharedInstance] requestWithUrl:url method:APIClientMethodPut parameters:parameters success:completion progress:progress faliure:failure];
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

