//
//  APIRequestObject.m
//  PlayerWithDub
//
//  Created by 泽泰 舒 on 2018/11/20.
//  Copyright © 2018年 泽泰 舒. All rights reserved.
//

#import "APIRequestObject.h"

@implementation APIRequestObject

- (instancetype)initWithUrl:(NSString *)url task:(NSURLSessionDataTask *)task {
    self = [super init];
    if (self) {
        _url = url;
        _task = task;
    }
    return self;
}

@end
