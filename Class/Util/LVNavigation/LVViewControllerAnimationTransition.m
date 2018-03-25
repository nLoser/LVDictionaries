//
//  LVPushTransition.m
//  LVDictionaries
//
//  Created by LV on 2018/3/23.
//  Copyright © 2018年 LV. All rights reserved.
//

#import "LVViewControllerAnimationTransition.h"
#import <UIKit/UIScreen.h>

@implementation LVViewControllerAnimationTransition

// This is used for percent driven interactive transitions, as well as for
// container controllers that have companion animations that might need to
// synchronize with the main animation.
- (NSTimeInterval)transitionDuration:(nullable id <UIViewControllerContextTransitioning>)transitionContext {
    return 0.8;
}

// This method can only  be a nop if the transition is interactive and not a percentDriven interactive transition.
- (void)animateTransition:(id <UIViewControllerContextTransitioning>)transitionContext {
    UIViewController * fromVC = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIViewController * toVC = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    
    CGRect finalFrameForVC = [transitionContext finalFrameForViewController:toVC];
    CGRect bounds = [[UIScreen mainScreen] bounds];
    
    if (_isPush) {
        toVC.view.frame = CGRectOffset(finalFrameForVC, -bounds.size.width, 0);
        [[transitionContext containerView] addSubview:toVC.view];
        
        [UIView animateWithDuration:0.8
                              delay:0.0
             usingSpringWithDamping:0.5
              initialSpringVelocity:0.0
                            options:UIViewAnimationOptionCurveLinear
                         animations:^{
                             fromVC.view.alpha = 0.8;
                             toVC.view.frame = finalFrameForVC;
                         } completion:^(BOOL finished) {
                             [transitionContext completeTransition:YES];
                             fromVC.view.alpha = 1.0;
                         }];
    }else {
        toVC.view.frame = CGRectOffset(finalFrameForVC, -200, 0);
        [[transitionContext containerView] addSubview:toVC.view];
        
        [UIView animateWithDuration:0.8
                              delay:0.0
             usingSpringWithDamping:0.5
              initialSpringVelocity:0.0
                            options:UIViewAnimationOptionCurveLinear
                         animations:^{
                             fromVC.view.alpha = 0.8;
                             toVC.view.frame = finalFrameForVC;
                         }
                         completion:^(BOOL finished) {
                             [transitionContext completeTransition:![transitionContext transitionWasCancelled]];
                             fromVC.view.alpha = 1.0;
                         }];
    }
}

@end
