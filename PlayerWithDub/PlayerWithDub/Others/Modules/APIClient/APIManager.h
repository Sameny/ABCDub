//
//  APIManager.h
//  PlayerWithDub
//
//  Created by 泽泰 舒 on 2018/11/20.
//  Copyright © 2018年 泽泰 舒. All rights reserved.
//

#import "APIRequestObject.h"
#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@class APIUploadParamObject;
@interface APIManager : NSObject

- (APIRequestObject *)getRequestObjectWithUrl:(NSString *)url parammeters:(nullable NSDictionary *)parameters responseDataHandler:(nullable NSObject *)responseDataHandler failureDataHandler:(nullable NSObject *)failureDataHandler;

- (APIRequestObject *)getRequestObjectWithUrl:(NSString *)url parammeters:(nullable NSDictionary *)parameters responseDataHandler:(nullable NSObject *)responseDataHandler progressDataHandler:(nullable NSObject *)progressDataHandler failureDataHandler:(nullable NSObject *)failureDataHandler;

- (APIRequestObject *)postRequestObjectWithUrl:(NSString *)url parammeters:(nullable NSDictionary *)parameters responseDataHandler:(nullable NSObject *)responseDataHandler failureDataHandler:(nullable NSObject *)failureDataHandler;

- (APIRequestObject *)postRequestObjectWithUrl:(NSString *)url parammeters:(NSDictionary *)parameters responseDataHandler:(nullable NSObject *)responseDataHandler progressDataHandler:(nullable NSObject *)progressDataHandler failureDataHandler:(nullable NSObject *)failureDataHandler;

+ (APIRequestObject *)uploadDataWithUrl:(NSString *)url
                             parameters:(NSArray <APIUploadParamObject *>*)parameters
                    responseDataHandler:(nullable NSObject *)responseDataHandler
                    progressDataHandler:(nullable NSObject *)progressDataHandler
                     failureDataHandler:(nullable NSObject *)failureDataHandler;

@end


extern NSString * const kSZTImageMineType;
extern NSString * const kSZTMP3MineType;
extern NSString * const kSZTMP4MineType;

@interface APIUploadParamObject : NSObject <APIClientUploadDelegate>

@property (nonatomic, strong) NSURL *fileUrl;
@property (nonatomic, copy) NSString *mineType;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *fileName;

- (BOOL)isValid;

@end

NS_ASSUME_NONNULL_END
