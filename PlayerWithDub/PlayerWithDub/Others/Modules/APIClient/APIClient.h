//
//  APIClient.h
//  PlayerWithDub
//
//  Created by 泽泰 舒 on 2018/11/19.
//  Copyright © 2018年 泽泰 舒. All rights reserved.
//
#import "APIDefines.h"
#import <AFNetworking/AFNetworking.h>

static NSString *APIClientBaseUrl = @"base_url";

NS_ASSUME_NONNULL_BEGIN

@interface APIClient : AFHTTPSessionManager

+ (NSURLSessionDataTask *)getWithUrl:(NSString *)url
                          parameters:(nullable NSDictionary *)parameters
                             success:(nullable APIClientCompletion)completion
                             faliure:(nullable APIClientFaildHandler)failure;
+ (NSURLSessionDataTask *)getWithUrl:(NSString *)url
                          parameters:(nullable NSDictionary *)parameters
                             success:(nullable APIClientCompletion)completion
                            progress:(nullable APIClientProgressHandler)progress
                             faliure:(nullable APIClientFaildHandler)failure;

+ (NSURLSessionDataTask *)postWithUrl:(NSString *)url
                           parameters:(NSDictionary *)parameters
                              success:(nullable APIClientCompletion)completion
                              faliure:(nullable APIClientFaildHandler)failure;

+ (NSURLSessionDataTask *)postWithUrl:(NSString *)url
                           parameters:(NSDictionary *)parameters
                              success:(nullable APIClientCompletion)completion
                             progress:(nullable APIClientProgressHandler)progress
                              faliure:(nullable APIClientFaildHandler)failure;

+ (NSURLSessionDataTask *)uploadDataWithUrl:(NSString *)url
                                 parameters:(NSArray <id<APIClientUploadDelegate>>*)parameters
                                    success:(APIClientCompletion)completion
                                   progress:(APIClientProgressHandler)progress
                                    faliure:(APIClientFaildHandler)failure;

@end

NSString *szt_pathExtensionWithMineType(NSString *mineType);

NS_ASSUME_NONNULL_END
