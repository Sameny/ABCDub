//
//  ABCPresentAnimation.m
//  PlayerWithDub
//
//  Created by 泽泰 舒 on 2018/11/5.
//  Copyright © 2018年 泽泰 舒. All rights reserved.
//

#import <UIKit/UIScreen.h>
#import "ABCPresentAnimation.h"

@implementation ABCPresentAnimation

- (NSTimeInterval)transitionDuration:(nullable id <UIViewControllerContextTransitioning>)transitionContext {
    return 0.4;
}

- (void)animateTransition:(id <UIViewControllerContextTransitioning>)transitionContext {
    UIViewController *fromViewController = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIViewController *toViewController = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    UIView *containView;
    UIView *transformView;
    
    BOOL isPresent = _abc_presentAnimationStyle == ABCPresentAnimationStylePush;
    if (isPresent) {
        transformView = toViewController.view;
        [[transitionContext containerView] addSubview:transformView];
        
    }
    else {
        transformView = fromViewController.view;
        [[transitionContext containerView] insertSubview:toViewController.view belowSubview:transformView];
    }
    [containView addSubview:transformView];
    
    NSTimeInterval duration = [self transitionDuration:transitionContext];
    UIScreen *mainScreen = [UIScreen mainScreen];
    CGFloat width = mainScreen.bounds.size.width;
    CGFloat height = mainScreen.bounds.size.height;
    transformView.frame = CGRectMake(isPresent? width:0, 0, width, height);
    
    [UIView animateWithDuration:duration animations:^{
        transformView.frame = CGRectMake(isPresent? 0:width, 0, width, height);
    } completion:^(BOOL finished) {
        [transitionContext completeTransition:!transitionContext.transitionWasCancelled];
    }];
}

@end
