//
//  LVPercentDrivenInteractiveTransition.m
//  LVDictionaries
//
//  Created by LV on 2018/3/23.
//  Copyright © 2018年 LV. All rights reserved.
//

#import "LVPercentDrivenInteractiveTransition.h"

@interface LVPercentDrivenInteractiveTransition()
@property (nonatomic, assign) BOOL canReceive;
@property (nonatomic, weak) UIViewController * remVC;
@end

@implementation LVPercentDrivenInteractiveTransition

- (void)writeToViewController:(UIViewController *)toVC {
    self.remVC = toVC;
    [self.remVC.view addGestureRecognizer:[[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panRecognizer:)]];
}

#pragma mark - Target Action

- (void)panRecognizer:(UIPanGestureRecognizer *)gesture {
    CGPoint panPoint = [gesture translationInView:gesture.view.superview];
    CGPoint locationPoint = [gesture locationInView:gesture.view.superview];
    
    if (gesture.state == UIGestureRecognizerStateBegan) {
        _isAnimating = YES;
        if (locationPoint.x <= self.remVC.view.bounds.size.width/2.0) {
            [self.remVC.navigationController popViewControllerAnimated:YES];
        }
    }else if (gesture.state == UIGestureRecognizerStateChanged) {
        if (locationPoint.x >= self.remVC.view.bounds.size.width/2.0) {
            _canReceive = YES;
        }else {
            _canReceive = NO;
        }
        [self updateInteractiveTransition:panPoint.x / self.remVC.view.bounds.size.width];
    }else if (gesture.state == UIGestureRecognizerStateCancelled || gesture.state == UIGestureRecognizerStateEnded) {
        _isAnimating = NO;
        if (!_canReceive || gesture.state == UIGestureRecognizerStateCancelled) {
            [self cancelInteractiveTransition];
        }else {
            [self finishInteractiveTransition];
        }
    }
}

@end
