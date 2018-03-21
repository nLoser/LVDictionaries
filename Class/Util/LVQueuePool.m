//
//  LVQueuePool.m
//  LVDictionaries
//
//  Created by LV on 2018/3/20.
//  Copyright © 2018年 LV. All rights reserved.
//

#import "LVQueuePool.h"
#import <UIKit/UIDevice.h>
#import <libkern/OSAtomic.h>

#define MAX_QUEUE_COUNT 26

static inline qos_class_t NSQualityOfServiceToQOSClass(NSQualityOfService qos) {
    switch (qos) {
        case NSQualityOfServiceUserInteractive: return QOS_CLASS_USER_INTERACTIVE;
        case NSQualityOfServiceUserInitiated: return QOS_CLASS_USER_INITIATED;
        case NSQualityOfServiceUtility: return QOS_CLASS_UTILITY;
        case NSQualityOfServiceBackground: return QOS_CLASS_BACKGROUND;
        case NSQualityOfServiceDefault: return QOS_CLASS_DEFAULT;
        default: return QOS_CLASS_DEFAULT;
    }
}

static inline dispatch_queue_priority_t NSQualityOfServiceToDispathPriority(NSQualityOfService qos) {
    switch (qos) {
        case NSQualityOfServiceUserInteractive: return DISPATCH_QUEUE_PRIORITY_HIGH;
        case NSQualityOfServiceUserInitiated: return DISPATCH_QUEUE_PRIORITY_HIGH;
        case NSQualityOfServiceUtility: return DISPATCH_QUEUE_PRIORITY_LOW;
        case NSQualityOfServiceBackground: return DISPATCH_QUEUE_PRIORITY_BACKGROUND;
        case NSQualityOfServiceDefault: return DISPATCH_QUEUE_PRIORITY_DEFAULT;
        default: return DISPATCH_QUEUE_PRIORITY_DEFAULT;
    }
}

typedef struct {
    const char * name;
    void ** queues;
    uint32_t queueCount;
    int32_t counter;
}LVDispatchContext;

static LVDispatchContext * LVDispatchContextCreate(const char * name, uint32_t queueCount, NSQualityOfService qos) {
    LVDispatchContext * context = calloc(1, sizeof(LVDispatchContext));
    if(!context) return NULL;
    context->queues = calloc(queueCount, sizeof(void *));
    if (!context->queues) {
        free(context->queues);
        return NULL;
    }
    
    if ([UIDevice currentDevice].systemVersion.floatValue >= 8.0) {
        dispatch_qos_class_t qosClass = NSQualityOfServiceToQOSClass(qos);
        for (NSUInteger i = 0; i < queueCount; i ++) {
            dispatch_queue_attr_t attr = dispatch_queue_attr_make_with_qos_class(DISPATCH_QUEUE_SERIAL, qosClass, 0);
            dispatch_queue_t queue = dispatch_queue_create(name, attr);
            
            context->queues[i] = (__bridge_retained void *)(queue);
        }
    }else {
        long identifier = NSQualityOfServiceToDispathPriority(qos);
        for (NSUInteger i = 0; i < queueCount; i ++) {
            dispatch_queue_t queue = dispatch_queue_create(name, DISPATCH_QUEUE_SERIAL);
            dispatch_set_target_queue(queue, dispatch_get_global_queue(identifier, 0));
            context->queues[i] = (__bridge_retained void *)(queue);
        }
    }
    
    return context;
}















@implementation LVQueuePool

@end















