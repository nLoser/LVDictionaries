//
//  LVVCControl.m
//  LVDictionaries
//
//  Created by LV on 2018/3/19.
//  Copyright © 2018年 LV. All rights reserved.
//

#import "LVVCControl.h"
#import "LookupController.h"
#import "HistoryController.h"

@implementation LVVCControl

+ (UIViewController *)LoopupController {
    LookupController * vc = [[LookupController alloc] init];
    vc.title = @"Loopup";
    UINavigationController * nc = [[UINavigationController alloc] initWithRootViewController:vc];
    [nc setNavigationBarHidden:YES];
    return nc;
}

+ (UIViewController *)HistoryController {
    HistoryController * vc = [[HistoryController alloc] init];
    vc.title = @"history";
    return vc;
}

@end
