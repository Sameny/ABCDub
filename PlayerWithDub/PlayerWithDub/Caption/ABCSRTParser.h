//
//  ABCSRTParser.h
//  PlayerWithDub
//
//  Created by 泽泰 舒 on 2018/11/2.
//  Copyright © 2018年 泽泰 舒. All rights reserved.
//


#import "ABCCaptionSegment.h"

NS_ASSUME_NONNULL_BEGIN

/**
 解析srt文件的回调

 @param captions 解析srt成功后，会返回ABCCaptionSegment类型的数组
 @param error 解析过程中出现的错误
 */
typedef void(^ABCSRTParserCompletion)(NSArray <ABCCaptionSegment *>* captions, NSError * _Nullable error);

@interface ABCSRTParser : NSObject

/**
 解析srt文件

 @param filePath 被解析的srt文件的位置
 @param completion 解析完成的回调
 */
+ (void)parserWithFilePath:(NSString *)filePath completion:(ABCSRTParserCompletion)completion;

@end

NS_ASSUME_NONNULL_END
