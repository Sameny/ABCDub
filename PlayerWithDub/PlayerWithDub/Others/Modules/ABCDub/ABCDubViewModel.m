//
//  ABCDubViewModel.m
//  PlayerWithDub
//
//  Created by 泽泰 舒 on 2018/11/5.
//  Copyright © 2018年 泽泰 舒. All rights reserved.
//

#import "ABCSRTParser.h"
#import "ABCDubViewModel.h"

@interface ABCDubViewModel ()

@property (nonatomic, strong) NSArray <ABCCaptionSegment *>*captions;

@end

@implementation ABCDubViewModel

- (void)configSrtFile:(NSString *)filePath completion:(ABCSuccessHandler)completion {
    [ABCSRTParser parserWithFilePath:filePath completion:^(NSArray<ABCCaptionSegment *> * _Nonnull captions, NSError * _Nullable error) {
        self->_captions = captions;
        if (completion) {
            completion(error == nil);
        }
    }];
}

- (ABCCaptionSegment *)captionSegmentWithIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row < self.captions.count) {
        return self.captions[indexPath.row];
    }
    return nil;
}

@end
