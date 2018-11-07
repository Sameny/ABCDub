//
//  ABCCaptionSegment.m
//  PlayerWithDub
//
//  Created by 泽泰 舒 on 2018/11/2.
//  Copyright © 2018年 泽泰 舒. All rights reserved.
//

#import "ABCCaptionSegment.h"

@implementation ABCCaptionSegment

- (void)setIndexWithIndexLineString:(NSString *)indexLine {
    if (indexLine.length > 0) {
        _index = indexLine.integerValue;
    }
}

// 00:00:08,233 --> 00:00:10,000
- (void)setTimeWithTimeLineString:(NSString *)timeLine {
    if (timeLine.length == 0) {
        return;
    }
    NSArray <NSString *>*times = [timeLine componentsSeparatedByString:@"-->"];
    if (times.count != 2) {
        return;
    }
    
    __block NSInteger startMSeconds = 0;
    __block NSInteger endMSeconds = 0;
    [times enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSArray <NSString *>*seconds = [obj componentsSeparatedByString:@","];
        if (seconds.count != 2) {
            *stop = YES;
        }
        else {
            NSArray <NSString *>*dates = [seconds[0] componentsSeparatedByString:@":"];
            if (dates.count != 3) {
                *stop = YES;
            }
            else {
                if (idx == 0) {
                    startMSeconds = (dates[0].integerValue * 3600 + dates[1].integerValue * 60 + dates[2].integerValue)*1000 + seconds[1].integerValue;
                }
                else {
                    endMSeconds = (dates[0].integerValue * 3600 + dates[1].integerValue * 60 + dates[2].integerValue)*1000 + seconds[1].integerValue;
                }
            }
        }
    }];
    
    _startTime = startMSeconds;
    _endTime = endMSeconds;
}

- (void)setEnContentWithEnContentLineString:(NSString *)enLine {
    _en_content = enLine;
}

- (void)setChContentWithChContentLineString:(NSString *)chLine {
    _ch_content = chLine;
}

- (NSTimeInterval)duration {
    if ([self isValid]) {
        return (_endTime - _startTime)/1000.f;
    }
    return 0;
}

- (BOOL)isValid {
    return _index > 0 && _endTime > _startTime;
}

- (NSString *)debugDescription {
    return [NSString stringWithFormat:@"index : %d, startTime:%d to endTime:%d, en:%@, ch:%@", _index, _startTime, _endTime, _en_content, _ch_content];
}

@end
/*
 3
 00:00:08,233 --> 00:00:10,000
 Yeah, yeah, yeah, no leaping.
 好好好   不跳
 
 */
