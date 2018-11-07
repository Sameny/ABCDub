//
//  UIViewController+PresentAnimation.m
//  PlayerWithDub
//
//  Created by 泽泰 舒 on 2018/11/5.
//  Copyright © 2018年 泽泰 舒. All rights reserved.
//

#import "NSObject+SZTAdd.h"

#import "ABCPresentAnimation.h"
#import "UIViewController+PresentAnimation.h"

@implementation UIViewController (PresentAnimation) 

+ (void)load {
    [UIViewController szt_swizzleInstanceMethod:@selector(presentViewController:animated:completion:) with:@selector(szt_presentViewController:animated:completion:)];
    [UIViewController szt_swizzleInstanceMethod:@selector(dismissViewControllerAnimated:completion:) with:@selector(szt_dismissViewControllerAnimated:completion:)];
}

- (void)szt_presentViewController:(UIViewController *)viewControllerToPresent animated:(BOOL)flag completion:(void (^)(void))completion {
    if (flag) {
        viewControllerToPresent.transitioningDelegate = self;
    }
    [self szt_presentViewController:viewControllerToPresent animated:flag completion:completion];
}

- (void)szt_dismissViewControllerAnimated:(BOOL)flag completion:(void (^)(void))completion {
    if (flag) {
        self.transitioningDelegate = self;
    }
    [self szt_dismissViewControllerAnimated:flag completion:completion];
}

#pragma mark - UIViewControllerTransitioningDelegate
- (id<UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source {
    ABCPresentAnimation *presentAnimation = [[ABCPresentAnimation alloc] init];
    presentAnimation.abc_presentAnimationStyle = ABCPresentAnimationStylePush;
    return presentAnimation;
}

- (id<UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed {
    ABCPresentAnimation *presentAnimation = [[ABCPresentAnimation alloc] init];
    presentAnimation.abc_presentAnimationStyle = ABCPresentAnimationStylePop;
    return presentAnimation;
}

@end
