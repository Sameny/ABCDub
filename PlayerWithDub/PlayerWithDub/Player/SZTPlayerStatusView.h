//
//  SZTPlayerStatusView.h
//  PlayerWithDub
//
//  Created by 泽泰 舒 on 2018/11/13.
//  Copyright © 2018年 泽泰 舒. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, SZTPlayerStatusViewStatus) {
    SZTPlayerStatusViewStatusNone,
    SZTPlayerStatusViewStatusPlaying,
    SZTPlayerStatusViewStatusPaused,
    SZTPlayerStatusViewStatusSlide,
    SZTPlayerStatusViewStatusLoading,
    SZTPlayerStatusViewStatusError
};

NS_ASSUME_NONNULL_BEGIN

typedef void(^SZTPlayerStatusViewBlock)();
@interface SZTPlayerStatusView : UIView

@property (nonatomic, copy) SZTPlayerStatusViewBlock changePauseStatusBlock;

- (void)setStatus:(SZTPlayerStatusViewStatus)status withDescription:(NSAttributedString * _Nullable)desc;

@end

NS_ASSUME_NONNULL_END
