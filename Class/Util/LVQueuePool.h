//
//  LVQueuePool.h
//  LVDictionaries
//
//  Created by LV on 2018/3/20.
//  Copyright © 2018年 LV. All rights reserved.
//  YYDispatchQueuePool

#import <Foundation/Foundation.h>

@interface LVQueuePool : NSObject
@property (nullable, nonatomic, readonly) NSString * name;
- (dispatch_queue_t)queue;
- (instancetype)initWithName:(NSString *)name queueCount:(NSUInteger)queueCount qos:(NSQualityOfService)qos;
@end
