//
//  ABCSRTParser.m
//  PlayerWithDub
//
//  Created by 泽泰 舒 on 2018/11/2.
//  Copyright © 2018年 泽泰 舒. All rights reserved.
//

#import "ABCError.h"
#import "ABCSRTParser.h"

@implementation ABCSRTParser

+ (void)parserWithFilePath:(NSString *)filePath completion:(ABCSRTParserCompletion)completion {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSMutableArray <ABCCaptionSegment *>*captions = [[NSMutableArray alloc] init];
        NSError *error = nil;
        @try {
            NSData *data = [NSData dataWithContentsOfFile:filePath];
            NSString *srtString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
            
            if (srtString.length > 0) {
                // 按行分割，有多少行数据，每5行是一个segment
                NSArray *lines = [srtString componentsSeparatedByString:@"\n"];
                NSInteger segmentNumber = ceil(lines.count / 5.f);
                for (NSInteger i = 0; i < segmentNumber; i++) {
                    NSInteger indexLine = i*5;
                    if (indexLine + 3 < lines.count) {
                        ABCCaptionSegment *caption = [[ABCCaptionSegment alloc] init];
                        [caption setIndexWithIndexLineString:lines[indexLine]];
                        [caption setTimeWithTimeLineString:lines[indexLine + 1]];
                        [caption setEnContentWithEnContentLineString:lines[indexLine + 2]];
                        [caption setChContentWithChContentLineString:lines[indexLine + 3]];
                        if ([caption isValid]) {
                            [captions addObject:caption];
                        }
                    }
                    else {
                        break;
                    }
                }
            }
            else {
                error = [NSError errorWithDomain:ParseSRTFileErrorDomain code:ParseSRTFileErrorCodeLoadDataFaild userInfo:@{NSLocalizedDescriptionKey:ParseSRTFileErrorLoadDataFaild}];
            }
        } @catch (NSException *exception) {
            error = [NSError errorWithDomain:ParseSRTFileErrorDomain code:ParseSRTFileErrorCodeOccurException userInfo:@{NSLocalizedDescriptionKey:ParseSRTFileErrorOccurException, NSLocalizedFailureReasonErrorKey:exception.reason}];
        } @finally {
            if (completion) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    completion(captions, error);
                });
            }
        }
    });
}

@end
