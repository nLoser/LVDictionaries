//
//  LVFileHelper.m
//  LVDictionaries
//
//  Created by LV on 2018/3/19.
//  Copyright © 2018年 LV. All rights reserved.
//

#import "LVFileHelper.h"
#import "MBProgressHUD.h"

@implementation LVFileHelper

+ (void)checkLocalDatabase {
    BOOL complished = [[[NSUserDefaults standardUserDefaults] valueForKey:@"Accomplished"] boolValue];
    if (!complished) {
        NSString * content = [NSString stringWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"vocabulary" ofType:@"txt"] encoding:NSUTF16StringEncoding error:nil];
        updateLocalDataBase([content componentsSeparatedByString:@"\n"]);
    }
}

static void updateLocalDataBase(NSArray * contentArray) {
    
}

@end
