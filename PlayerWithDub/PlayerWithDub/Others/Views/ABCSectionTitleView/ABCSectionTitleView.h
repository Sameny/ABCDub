//
//  ABCSectionTitleView.h
//  PlayerWithDub
//
//  Created by 泽泰 舒 on 2018/11/19.
//  Copyright © 2018年 泽泰 舒. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, ABCSectionTitleViewStyle) {
    ABCSectionTitleViewStyleGreen,
    ABCSectionTitleViewStyleBlue,
};

NS_ASSUME_NONNULL_BEGIN

@interface ABCSectionTitleView : UIView

@property (nonatomic, strong, readonly) UILabel *titleLabel;

@property (nonatomic, assign) ABCSectionTitleViewStyle style;

- (void)setTitle:(NSString *)title;
- (void)setAttributeTitle:(NSAttributedString *)title;

- (void)shwoMoreButtonWithEvent:(ABCHandler)event;

@end

NS_ASSUME_NONNULL_END
