//
//  LVFileHelper.m
//  LVDictionaries
//
//  Created by LV on 2018/3/19.
//  Copyright © 2018年 LV. All rights reserved.
//

#import "LVFileManager.h"
#import "MBProgressHUD.h"
#import <sqlite3.h>

static const char * dbpath = "";
static NSString * createsql = @"create table if not exists %@(id integer primary key autoincrement, word text, symbol text, explian text, lookupnum integer)";
static NSString * insertsql = @"insert into %@(word, symbol, explian, lookupnum) values(?,?,?,?)";

@interface LVFileManager() {
    sqlite3 * db;
}
@end

@implementation LVFileManager

+ (instancetype)shareDefault {
    static LVFileManager * helper = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        helper = [LVFileManager new];
    });
    return helper;
}

- (void)checkLocalDatabase {
    BOOL complished = [[[NSUserDefaults standardUserDefaults] valueForKey:@"Accomplished"] boolValue];
    if (!complished) {
        NSString * content = [NSString stringWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"vocabulary" ofType:@"txt"] encoding:NSUTF16StringEncoding error:nil];
        [self updateLocalDataBase:[content componentsSeparatedByString:@"\n"]];
    }
}

- (void)updateLocalDataBase:(NSArray *)contentArray {
    NSArray * prefixArr = @[@"a",@"b",@"c",@"d",@"e",@"f",@"g",@"h",@"i",@"j",@"k",@"l",@"m",
                            @"n",@"o",@"p",@"q",@"r",@"s",@"t",@"u",@"v",@"w",@"x",@"y",@"z"];
    NSMutableArray * array = [NSMutableArray arrayWithCapacity:prefixArr.count];
    for (int i = 0; i < prefixArr.count; i ++) {
        array[i] = [NSMutableArray arrayWithCapacity:0];
    }
    for (NSString * item in contentArray) {
        int code = [item characterAtIndex:0];
        if (code >= 97) {
            [array[[item characterAtIndex:0]-97] addObject:item];
        }else {
            [array[[item characterAtIndex:0]-65] addObject:item];
        }
    }
    NSString * dbPath = [[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"] stringByAppendingPathComponent:@"Data"];
    [[NSFileManager defaultManager] removeItemAtPath:dbPath error:nil];
    [[NSFileManager defaultManager] createDirectoryAtPath:dbPath withIntermediateDirectories:YES attributes:nil error:nil];
    dbpath = [[dbPath stringByAppendingPathComponent:@"word.db"] UTF8String];
    sqlite3_open(dbpath, &db);
    
    for (int i = 0; i < 2; i++) {
        NSString * tablename = [NSString stringWithFormat:@"%@_table",prefixArr[i]];
        sqlite3_exec(db, [[NSString stringWithFormat:createsql,tablename] UTF8String], NULL, NULL, nil);
        createTableWithData(array[i], tablename, self);
    }
    [[NSUserDefaults standardUserDefaults] setValue:@(YES) forKey:@"Accomplished"];
}

static void createTableWithData(NSArray * data , NSString * tablename, LVFileManager * this) {
    const char * insert = [[NSString stringWithFormat:insertsql,tablename] UTF8String];
    for (NSString * item in data) {
        insertLocalDataWord(insert ,item, @"symte哈", @"忙起来", 1, this->db);
    }
}

static void insertLocalDataWord(const char * insertSql ,NSString * word, NSString * symbol, NSString * explian, int lookupnum, sqlite3* db) {
    sqlite3_stmt * stmt;
    int result = sqlite3_prepare_v2(db, insertSql, -1, &stmt, NULL);
    if (result == SQLITE_OK) {
        sqlite3_bind_text(stmt, 1, [word UTF8String], -1, NULL);
        sqlite3_bind_text(stmt, 2, [symbol UTF8String], -1, NULL);
        sqlite3_bind_text(stmt, 3, [explian UTF8String], -1, NULL);
        sqlite3_bind_int(stmt, 4, lookupnum);
    }
    if (sqlite3_step(stmt) != SQLITE_DONE) {
        NSLog(@"Insert failed%@",word);
    }
    sqlite3_finalize(stmt);
}

@end
