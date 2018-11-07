//
//  ABCMediaMergeUnit.m
//  PlayerWithDub
//
//  Created by 泽泰 舒 on 2018/10/31.
//  Copyright © 2018年 泽泰 舒. All rights reserved.
//

#import "ABCMediaComposeUnit.h"

@implementation ABCMediaComposeUnit

- (instancetype)initWithUrl:(NSURL *)url mediaType:(AVMediaType)mediaType beginTime:(CMTime)begin timeRange:(CMTimeRange)timeRange {
    self = [super init];
    if (self) {
        _url = url;
        _mediaType = mediaType;
        _beginTime = begin;
        _timeRange = timeRange;
    }
    return self;
}

@end
