//
//  LVFileHelper.m
//  LVDictionaries
//
//  Created by LV on 2018/3/19.
//  Copyright © 2018年 LV. All rights reserved.
//

#import "LVFileHelper.h"
#import "MBProgressHUD.h"
#import <sqlite3.h>

@implementation LVFileHelper

+ (void)checkLocalDatabase {
    BOOL complished = [[[NSUserDefaults standardUserDefaults] valueForKey:@"Accomplished"] boolValue];
    if (!complished) {
        NSString * content = [NSString stringWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"vocabulary" ofType:@"txt"] encoding:NSUTF16StringEncoding error:nil];
        updateLocalDataBase([content componentsSeparatedByString:@"\n"]);
    }
}

static void updateLocalDataBase(NSArray * contentArray) {
    //创建并且打开数据库
    
    NSString * dbPath = [[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"] stringByAppendingPathComponent:@"word.db"];
    
    sqlite3 * db;
    int rt = sqlite3_open("dsa", &db);
    
    char * errorMsg; //
    char * creatSql = "";
}

@end
