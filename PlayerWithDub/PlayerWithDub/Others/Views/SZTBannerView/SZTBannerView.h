//
//  SZTBannerView.h
//  PlayerWithDub
//
//  Created by 泽泰 舒 on 2018/11/14.
//  Copyright © 2018年 泽泰 舒. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class SZTBannerView;
@protocol SZTBannerViewDelegate <NSObject>
@optional
- (void)banner:(SZTBannerView *)banner didScrollToIndex:(NSInteger)index;
- (void)banner:(SZTBannerView *)banner didSelectedAtIndex:(NSInteger)index;
@end

@interface SZTBannerView : UIView

@property (nonatomic, copy) NSArray <NSString *>*urls;
@property (nonatomic, weak) id<SZTBannerViewDelegate> delegate;

- (void)startScroll;
- (void)stopScroll;

@end

NS_ASSUME_NONNULL_END
