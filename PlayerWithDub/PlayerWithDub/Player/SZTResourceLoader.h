//
//  SZTResourceLoader.h
//  PlayerWithDub
//
//  Created by 泽泰 舒 on 2018/11/7.
//  Copyright © 2018年 泽泰 舒. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVAssetResourceLoader.h>

@class SZTResourceLoader;
@protocol SZTResourceLoaderDelegate <NSObject>

@optional

// progress
- (void)resourceLoader:(SZTResourceLoader *)loader didBufferToProgress:(double)progress;
- (void)resourceLoader:(SZTResourceLoader *)loader didCompleteWithSuccess:(BOOL)success error:(NSError *)error;

@end


typedef void(^SZTResourceLoaderCompletion)(BOOL success, NSError *error);
typedef void(^SZTResourceLoaderDataHandler)(NSData *data, NSURLSessionDataTask *dataTask);
typedef void(^SZTResourceLoaderReceiveHandler)(NSURLSessionDataTask *dataTask, NSURLResponse *response);
NS_ASSUME_NONNULL_BEGIN

@interface SZTResourceLoader : NSObject <AVAssetResourceLoaderDelegate>

@property (nonatomic, copy, readonly) SZTResourceLoaderCompletion completion;
@property (nonatomic, copy, readonly) SZTResourceLoaderDataHandler dataHandler;
@property (nonatomic, copy, readonly) SZTResourceLoaderReceiveHandler receiveHandler;
@property (nonatomic, assign) BOOL isSeek;
@property (nonatomic, weak) id<SZTResourceLoaderDelegate> delegate;

- (instancetype)initWithResourceUrl:(NSString *)resourceUrl;

- (void)cancelDownloadAndClear:(BOOL)clear;

@end


@interface NSString (MimeType)
- (NSString *)mimeTypeForPathExtension;
@end

NS_ASSUME_NONNULL_END
