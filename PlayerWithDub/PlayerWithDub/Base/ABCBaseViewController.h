//
//  ABCBaseViewController.h
//  PlayerWithDub
//
//  Created by 舒泽泰 on 2018/11/27.
//  Copyright © 2018 泽泰 舒. All rights reserved.
//

#import "ABCNavigationView.h"
#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, ABCNavigationViewBackgroundStyle) {
    ABCNavigationViewBackgroundStyleDefault,
    ABCNavigationViewBackgroundStyleDefaultWithStars,
    ABCNavigationViewBackgroundStyleCurve,
    ABCNavigationViewBackgroundStyleCurveWithStars,
};

NS_ASSUME_NONNULL_BEGIN

@interface ABCBaseViewController : UIViewController

@property (nonatomic, readonly) ABCNavigationView *navView;
@property (nonatomic, assign) ABCNavigationViewBackgroundStyle backgroundStyle;

- (void)setNavigationViewHidden:(BOOL)hidden animated:(BOOL)animated;
// can override 
- (void)leftNavigationButtonDidClicked;
- (void)rightNavigationButtonDidClicked;

@end

NS_ASSUME_NONNULL_END
