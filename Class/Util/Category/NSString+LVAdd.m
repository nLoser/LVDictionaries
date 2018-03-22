//
//  NSString+LVAdd.m
//  LVDictionaries
//
//  Created by LV on 2018/3/22.
//  Copyright © 2018年 LV. All rights reserved.
//

#import "NSString+LVAdd.h"
#import <UIKit/NSStringDrawing.h>

@implementation NSString (LVAdd)

- (CGFloat)heightWithConstrainSize:(CGSize)size attribute:(NSDictionary *)attr {
    NSLog(@"\n计算:%@",self);
    CGFloat height = 0;
    NSArray * stringArray = [self componentsSeparatedByCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"\n\r"]];
    for (NSString * str in stringArray) {
        NSLog(@"%@",str);
        if (str.length > 0) {
            height += [str boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading attributes:attr context:nil].size.height;
        }
    }
    return height;
}

@end
