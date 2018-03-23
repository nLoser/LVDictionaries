//
//  LVPushTransition.h
//  LVDictionaries
//
//  Created by LV on 2018/3/23.
//  Copyright © 2018年 LV. All rights reserved.
//

/*
 1.动画协议: UIViewControllerAnimatedTransitioning
 2.交互协议: UIViewControllerInteractiveTransitioning
 3.上下文: UIViewControllerContextTransitioning
 4.遵守交互协议的官方协议: UIPercentDrivenInteractiveTransition
 */

#import <Foundation/Foundation.h>
#import <UIKit/UIViewControllerTransitioning.h>

@interface LVPushTransition<UIViewControllerAnimatedTransitioning> : NSObject

@end
