//
//  LVFileHelper.h
//  LVDictionaries
//
//  Created by LV on 2018/3/19.
//  Copyright © 2018年 LV. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LVWord.h"

typedef void(^lookupReult) (LVWordDetail *);

@interface LVFileManager : NSObject
+ (instancetype)shareDefault;
- (BOOL)checkLocalDatabase;
- (void)searchWord:(NSString *)word result:(lookupReult)result;
@end
