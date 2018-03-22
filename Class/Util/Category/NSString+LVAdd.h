//
//  NSString+LVAdd.h
//  LVDictionaries
//
//  Created by LV on 2018/3/22.
//  Copyright © 2018年 LV. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreGraphics/CGGeometry.h>

@interface NSString (LVAdd)

- (CGFloat)heightWithConstrainSize:(CGSize)size attribute:(NSDictionary *)attr;

@end
