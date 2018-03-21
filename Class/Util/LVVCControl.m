//
//  LVVCControl.m
//  LVDictionaries
//
//  Created by LV on 2018/3/19.
//  Copyright © 2018年 LV. All rights reserved.
//

#import "LVVCControl.h"
#import "LookupController.h"

@implementation LVVCControl

+ (UIViewController *)LoopupController {
    LookupController * vc = [[LookupController alloc] init];
    vc.title = @"Loopup";
    return vc;
}

@end
