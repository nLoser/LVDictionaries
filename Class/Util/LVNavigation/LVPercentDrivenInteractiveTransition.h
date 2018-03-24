//
//  LVPercentDrivenInteractiveTransition.h
//  LVDictionaries
//
//  Created by LV on 2018/3/23.
//  Copyright © 2018年 LV. All rights reserved.
//

#import <UIKit/UIKit.h>


/**
 UIPercentDrivenInteractiveTranstion 基于 UIViewControllerInteractiveTransitioning协议实现
 */
@interface LVPercentDrivenInteractiveTransition : UIPercentDrivenInteractiveTransition
@property (nonatomic, assign) BOOL isAnimating; ///< 是否正在动画中

/**
 写入下一个控制器
 @param toVC 将要进入的控制器
 */
- (void)writeToViewController:(UIViewController *)toVC;
@end
