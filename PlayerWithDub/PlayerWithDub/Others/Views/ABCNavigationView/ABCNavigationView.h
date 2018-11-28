//
//  ABCNavigationView.h
//  PlayerWithDub
//
//  Created by 舒泽泰 on 2018/11/27.
//  Copyright © 2018 泽泰 舒. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ABCNavigationViewDelegate <NSObject>

- (void)leftNavigationButtonDidClicked;
- (void)rightNavigationButtonDidClicked;

@end

NS_ASSUME_NONNULL_BEGIN

@interface ABCNavigationView : UIView

@property (nonatomic, copy) NSString *title;
@property (nonatomic, strong) UIImage *backgroundImage;
@property (nonatomic, weak) id<ABCNavigationViewDelegate> delegate;

// you can set customTitleView to customized some func what you want
@property (nonatomic, strong, nullable) UIView *customTitleView;

- (void)setLeftItemHidden:(BOOL)hidden;

- (void)setRightTitle:(NSString *)title image:(UIImage *)image;

@end

NS_ASSUME_NONNULL_END
