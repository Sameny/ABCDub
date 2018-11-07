//
//  ABCError.h
//  PlayerWithDub
//
//  Created by 泽泰 舒 on 2018/11/2.
//  Copyright © 2018年 泽泰 舒. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/* Media compose errors (code 30101~30120) */
extern NSString * const ABCMediaComposeErrorDomain;
extern NSString * const kABCMediaComposeErrorExport;
extern NSInteger const kABCMediaComposeErrorCodeExport;

/* MP3 Encoder errors (code 30201~30220) */
extern NSString * const MP3EncoderErrorDomain;

extern NSString * const MP3EncoderErrorFilePathInvalid;
extern NSInteger const MP3EncoderErrorCodeFilePathInvalid;
extern NSInteger const MP3EncoderErrorCodeOccurException;
extern NSString * const MP3EncoderErrorOccurException;

/* Parse srt file errors (code 30301~30320) */
extern NSString * const ParseSRTFileErrorDomain;
extern NSInteger const ParseSRTFileErrorCodeLoadDataFaild;
extern NSString * const ParseSRTFileErrorLoadDataFaild;
extern NSInteger const ParseSRTFileErrorCodeOccurException;
extern NSString * const ParseSRTFileErrorOccurException;

@interface ABCError : NSObject

@end

NS_ASSUME_NONNULL_END
