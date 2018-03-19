//
//  LVVCControl.m
//  LVDictionaries
//
//  Created by LV on 2018/3/19.
//  Copyright © 2018年 LV. All rights reserved.
//

#import "LVVCControl.h"

#import "MainTabController.h"

@implementation LVVCControl

+ (UIViewController *)MainTabViewController {
    UIViewController * vc = [[MainTabController alloc] init];
    return vc;
}

@end
