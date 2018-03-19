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
static NSString * querysql = @"select * from %@_table where word = '%@' COLLATE NOCASE;";

@interface LVFileManager() {
    sqlite3 * db;
    NSRegularExpression * _divideExpression;
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

#pragma mark - Public Methodd

- (BOOL)checkLocalDatabase {
    BOOL complished = [[[NSUserDefaults standardUserDefaults] valueForKey:@"Accomplished"] boolValue];
    if (!complished) {
        NSError * error = nil;
        _divideExpression = [NSRegularExpression regularExpressionWithPattern:@"\\[[^\\]]*\\]" options:NSRegularExpressionCaseInsensitive error:&error];
        NSString * content = [NSString stringWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"vocabulary" ofType:@"txt"] encoding:NSUTF16StringEncoding error:nil];
        [self updateLocalDataBase:[content componentsSeparatedByString:@"\n"]];
    }else{
        NSString * dbPath = [[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"] stringByAppendingPathComponent:@"Data"];
        dbpath = [[dbPath stringByAppendingPathComponent:@"word.db"] UTF8String];
        sqlite3_open(dbpath, &db);
    }
    return complished;
}

- (void)searchWord:(NSString *)word result:(lookupReult)result{
    if (word.length == 0) return;
    
    int code = [word characterAtIndex:0];
    code += code<97 ? 32:0;
    NSString * prefix = [NSString stringWithFormat:@"%c",code];
    
    const char * sql = [[NSString stringWithFormat:querysql,prefix,word] UTF8String];
    sqlite3_stmt * stmt;
    if (sqlite3_prepare_v2(db, sql, -1, &stmt, NULL) == SQLITE_OK) {
        while (sqlite3_step(stmt) == SQLITE_ROW) {
            LVWordDetail * rt = [LVWordDetail new];
            rt.word = [NSString stringWithUTF8String:(char *)sqlite3_column_text(stmt, 1)];
            rt.symbol = [NSString stringWithUTF8String:(char *)sqlite3_column_text(stmt, 2)];
            rt.explian = [NSString stringWithUTF8String:(char *)sqlite3_column_text(stmt, 3)];
            rt.lookupNum = sqlite3_column_int(stmt, 4);
            result(rt);
            break;
        }
    }
    sqlite3_finalize(stmt);
}

#pragma mark - Private Method

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
    
    for (int i = 0; i < prefixArr.count; i++) {
        NSString * tablename = [NSString stringWithFormat:@"%@_table",prefixArr[i]];
        sqlite3_exec(db, [[NSString stringWithFormat:createsql,tablename] UTF8String], NULL, NULL, nil);
        createTableWithData(array[i], tablename, self);
    }
    [[NSUserDefaults standardUserDefaults] setValue:@(YES) forKey:@"Accomplished"];
}

static void createTableWithData(NSArray * data , NSString * tablename, LVFileManager * this) {
    const char * insert = [[NSString stringWithFormat:insertsql,tablename] UTF8String];
    for (NSString * item in data) {
        @autoreleasepool{
            NSMutableArray * divideData = [NSMutableArray arrayWithCapacity:3];
            [this->_divideExpression enumerateMatchesInString:item options:0 range:NSMakeRange(0, item.length) usingBlock:^(NSTextCheckingResult * _Nullable result, NSMatchingFlags flags, BOOL * _Nonnull stop) {
                [divideData addObject:[item substringToIndex:result.range.location]];
                [divideData addObject:[item substringWithRange:NSMakeRange(result.range.location, result.range.length)]];
                [divideData addObject:[item substringWithRange:NSMakeRange(result.range.location+result.range.length, item.length-(result.range.location+result.range.length))]];
            }];
            insertLocalDataWord(insert ,divideData[0], divideData[1], divideData[2], 1, this->db);
        }
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
