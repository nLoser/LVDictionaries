//
//  LVFileHelper.h
//  LVDictionaries
//
//  Created by LV on 2018/3/19.
//  Copyright © 2018年 LV. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LVFileManager : NSObject

+ (instancetype)shareDefault;
- (void)checkLocalDatabase;

@end