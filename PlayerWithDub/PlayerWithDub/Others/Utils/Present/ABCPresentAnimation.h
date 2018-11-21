//
//  ABCPresentAnimation.h
//  PlayerWithDub
//
//  Created by 泽泰 舒 on 2018/11/5.
//  Copyright © 2018年 泽泰 舒. All rights reserved.
//

#import <UIKit/UIViewControllerTransitioning.h>
#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, ABCPresentAnimationStyle) {
    ABCPresentAnimationStylePush,
    ABCPresentAnimationStylePop,
    ABCPresentAnimationStylePresent, // not implementation
    ABCPresentAnimationStyleDismiss // not implementation
};

@interface ABCPresentAnimation : NSObject <UIViewControllerAnimatedTransitioning>

@property (nonatomic, assign) ABCPresentAnimationStyle abc_presentAnimationStyle;

@end

NS_ASSUME_NONNULL_END
