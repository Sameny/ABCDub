//
//  ABCError.m
//  PlayerWithDub
//
//  Created by 泽泰 舒 on 2018/11/2.
//  Copyright © 2018年 泽泰 舒. All rights reserved.
//

#import "ABCError.h"

/* Media compose errors (code 30101~30120) */
NSString * const ABCMediaComposeErrorDomain = @"abc media merge error";
NSString * const kABCMediaComposeErrorExport = @"export occur error";
NSInteger const kABCMediaComposeErrorCodeExport = 30101;


/* Encoder errors (code 30201~30220) */
NSString * const MP3EncoderErrorDomain = @"abc mp3 encoder error";

NSInteger const MP3EncoderErrorCodeFilePathInvalid = 30201;
NSString * const MP3EncoderErrorFilePathInvalid = @"encode file path is invalid";
NSInteger const MP3EncoderErrorCodeOccurException = 30202;
NSString * const MP3EncoderErrorOccurException = @"encode accur exception";

/* Parse srt file errors (code 30301~30320) */
NSString * const ParseSRTFileErrorDomain = @"abc srt file parser error";
NSInteger const ParseSRTFileErrorCodeLoadDataFaild = 30301;
NSString * const ParseSRTFileErrorLoadDataFaild = @"cound not load srt file";
NSInteger const ParseSRTFileErrorCodeOccurException = 30302;
NSString * const ParseSRTFileErrorOccurException = @"parser srt accur exception";

@implementation ABCError

@end
