//
//  Global.h
//  LVDictionaries
//
//  Created by LV on 2018/3/19.
//  Copyright © 2018年 LV. All rights reserved.
//

#ifndef Global_h
#define Global_h

#if DEBUG
#define NSLog(format, ...) fprintf(stderr,"\n%s\r%s\n", [[[NSString stringWithUTF8String:__FILE__] lastPathComponent] UTF8String], [[NSString stringWithFormat:format, ##__VA_ARGS__] UTF8String])
#else
#define NSLog(...)
#endif

#define BgColor [UIColor colorWithRed:0.63 green:0.84 blue:0.92 alpha:1] ///< 淡淡蓝色
#define Color1 [UIColor colorWithRed:0.38 green:0.66 blue:0.86 alpha:1] ///< 淡蓝
#define Color2 [UIColor colorWithRed:0.03 green:0.35 blue:0.6 alpha:1] ///< 深蓝
#define Color3 [UIColor colorWithRed:0.5 green:0.5 blue:0.72 alpha:1] ///< 浅紫

#endif /* Global_h */
