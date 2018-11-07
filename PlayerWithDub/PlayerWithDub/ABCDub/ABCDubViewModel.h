//
//  ABCDubViewModel.h
//  PlayerWithDub
//
//  Created by 泽泰 舒 on 2018/11/5.
//  Copyright © 2018年 泽泰 舒. All rights reserved.
//

#import "ABCSimpleDefines.h"
#import "ABCCaptionSegment.h"

NS_ASSUME_NONNULL_BEGIN

@interface ABCDubViewModel : NSObject

@property (nonatomic, strong, readonly) NSArray <ABCCaptionSegment *>*captions;

- (void)configSrtFile:(NSString *)filePath completion:(ABCSuccessHandler)completion;

- (ABCCaptionSegment *)captionSegmentWithIndexPath:(NSIndexPath *)indexPath;

@end

NS_ASSUME_NONNULL_END
