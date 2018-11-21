//
//  APIRequestObject.h
//  PlayerWithDub
//
//  Created by 泽泰 舒 on 2018/11/20.
//  Copyright © 2018年 泽泰 舒. All rights reserved.
//

#import "APIDefines.h"
#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface APIRequestObject : NSObject

@property (nonatomic, copy, readonly) NSString *url;
@property (nonatomic, strong) NSURLSessionDataTask *task;
//@property (nonatomic, strong) NSPointerArray *responseDataHandlers;
//@property (nonatomic, strong) NSPointerArray *progressDataHandlers;
//@property (nonatomic, strong) NSPointerArray *failureDataHandlers;

- (instancetype)initWithUrl:(NSString *)url task:(NSURLSessionDataTask *)task;

- (void)cancel;

@end

NS_ASSUME_NONNULL_END
