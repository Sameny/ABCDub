//
//  APIDefines.h
//  PlayerWithDub
//
//  Created by 泽泰 舒 on 2018/11/20.
//  Copyright © 2018年 泽泰 舒. All rights reserved.
//

#ifndef APIDefines_h
#define APIDefines_h

#import "NSObject+APIAdd.h"
typedef void(^APIClientCompletion)(NSURLSessionDataTask *task, id responseObject);
typedef void(^APIClientFaildHandler)(NSURLSessionDataTask *task, NSError *error);
typedef void(^APIClientProgressHandler)(NSProgress *progress);

NS_ASSUME_NONNULL_BEGIN
@protocol APIClientUploadDelegate <NSObject>

@required
@property (nonatomic, strong) NSURL *fileUrl;
@property (nonatomic, copy) NSString *mineType;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *fileName;

@end
NS_ASSUME_NONNULL_END

#endif /* APIDefines_h */
