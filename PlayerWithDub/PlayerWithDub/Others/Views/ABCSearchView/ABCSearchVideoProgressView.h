//
//  ABCSearchHistoryView.h
//  PlayerWithDub
//
//  Created by 泽泰 舒 on 2018/11/19.
//  Copyright © 2018年 泽泰 舒. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ABCSearchVideoProgressView : UIView

@property (nonatomic, copy) void (^didSelectedKeyWord)(NSString *key);

- (void)addNewHistory:(NSString *)history;

- (void)show;
- (void)hide;

@end

NS_ASSUME_NONNULL_END
