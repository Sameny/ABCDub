//
//  ABCCaptionSegment.h
//  PlayerWithDub
//
//  Created by 泽泰 舒 on 2018/11/2.
//  Copyright © 2018年 泽泰 舒. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ABCCaptionSegment : NSObject

@property (nonatomic, assign, readonly) NSInteger index;
@property (nonatomic, assign, readonly) NSInteger startTime; // 毫秒
@property (nonatomic, assign, readonly) NSInteger endTime; // 毫秒
@property (nonatomic, copy, readonly) NSString *en_content;
@property (nonatomic, copy, readonly) NSString *ch_content;

@property (nonatomic, assign, readonly) NSTimeInterval duration; // 秒


- (void)setIndexWithIndexLineString:(NSString *)indexLine;

// 00:00:08,233 --> 00:00:10,000
- (void)setTimeWithTimeLineString:(NSString *)timeLine;
- (void)setEnContentWithEnContentLineString:(NSString *)enLine;
- (void)setChContentWithChContentLineString:(NSString *)chLine;

- (BOOL)isValid;

@end

NS_ASSUME_NONNULL_END
/*
 3                                  ---- indexLine
 00:00:08,233 --> 00:00:10,000      ---- timeLine
 Yeah, yeah, yeah, no leaping.      ---- enLine
 好好好   不跳                        ---- chLine
 
 */
