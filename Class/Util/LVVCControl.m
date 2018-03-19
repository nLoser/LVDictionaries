//
//  LVVCControl.m
//  LVDictionaries
//
//  Created by LV on 2018/3/19.
//  Copyright © 2018年 LV. All rights reserved.
//

#import "LVVCControl.h"

#import "MainTabController.h"
#import "LookupController.h"

@implementation LVVCControl

+ (UIViewController *)MainTabViewController {
    UITabBarController * vc = [[MainTabController alloc] init];
    LookupController * lookup = [[LookupController alloc] init];
    lookup.title = @"look";
    vc.viewControllers = @[lookup];
    vc.tabBar.translucent = NO;
    return vc;
}

@end
