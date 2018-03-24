//
//  LVPushTransition.h
//  LVDictionaries
//
//  Created by LV on 2018/3/23.
//  Copyright © 2018年 LV. All rights reserved.
//  参考:https://www.jianshu.com/p/59224648828b

/*
 1.动画协议: UIViewControllerAnimatedTransitioning
 2.交互协议: UIViewControllerInteractiveTransitioning : UIPercentDrivenInteractiveTransition（官方类遵守了这个协议）
 3.上下文: UIViewControllerContextTransitioning
 */

#import <Foundation/Foundation.h>
#import <UIKit/UIViewControllerTransitioning.h>

/**
 基于UIViewControllerAnimatedTransitioning协议，控制器之间跳转是不可控制和不可交互的!!!
 */
@interface LVViewControllerAnimationTransition : NSObject<UIViewControllerAnimatedTransitioning>
@property (nonatomic, assign) BOOL isPush;
@end
