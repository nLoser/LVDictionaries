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

#define MAX_QUEUE_COUNT 30

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
    context->queueCount = queueCount;
    if (name) {
        context->name = strdup(name);
    }
    return context;
}

static void LVDispatchContextRelease(LVDispatchContext *context) {
    if(!context) return;
    if (context->queues) {
        for (NSUInteger i = 0; i < context->queueCount; i++) {
            void * queuePointer = context->queues[i];
            dispatch_queue_t queue = (__bridge_transfer dispatch_queue_t)(queuePointer);
            const char * name = dispatch_queue_get_label(queue);
            if (name) strlen(name);
            queue = nil;
        }
    }
    if (context->name) {
        free((void *)context->name);
    }
}

static dispatch_queue_t LVDispatchContextGetQueue(LVDispatchContext *context) {
    uint32_t counter = OSAtomicIncrement32(&context->counter);
    void * queue = context->queues[counter % context->queueCount];
    return (__bridge dispatch_queue_t)(queue);
}

static LVDispatchContext * LVDisplayContextGetForQos(NSQualityOfService qos) {
    static LVDispatchContext * context[5] = {0};
    switch (qos) {
        case NSQualityOfServiceUserInteractive: {
            static dispatch_once_t onceToken;
            dispatch_once(&onceToken, ^{
                int count = (int)[NSProcessInfo processInfo].activeProcessorCount;
                count = count < 1 ? 1: count > MAX_QUEUE_COUNT ? MAX_QUEUE_COUNT : count;
                context[0] = LVDispatchContextCreate("com.lv.user-interactive", count, qos);
            });
            return context[0];
        }
            break;
        case NSQualityOfServiceUserInitiated:{
            static dispatch_once_t onceToken;
            dispatch_once(&onceToken, ^{
                int count = [NSProcessInfo processInfo].activeProcessorCount;
                count = count < 1 ? 1: count > MAX_QUEUE_COUNT ? MAX_QUEUE_COUNT : count;
                context[1] = LVDispatchContextCreate("com.lv.user-initiated", count, qos);
            });
            return context[1];
        }
            break;
        case NSQualityOfServiceUtility: {
            static dispatch_once_t onceToken;
            dispatch_once(&onceToken, ^{
                int count = [NSProcessInfo processInfo].activeProcessorCount;
                count = count < 1 ? 1: count > MAX_QUEUE_COUNT ? MAX_QUEUE_COUNT : count;
                context[2] = LVDispatchContextCreate("com.lv.user-utility", count, qos);
            });
            return context[2];
        }
            break;
        case NSQualityOfServiceBackground: {
            static dispatch_once_t onceToken;
            dispatch_once(&onceToken, ^{
                int count = [NSProcessInfo processInfo].activeProcessorCount;
                count = count < 1 ? 1: count > MAX_QUEUE_COUNT ? MAX_QUEUE_COUNT : count;
                context[3] = LVDispatchContextCreate("com.lv.user-background", count, qos);
            });
            return context[3];
        }
            break;
        case NSQualityOfServiceDefault:
        default: {
            static dispatch_once_t onceToken;
            dispatch_once(&onceToken, ^{
                int count = [NSProcessInfo processInfo].activeProcessorCount;
                count = count < 1 ? 1: count > MAX_QUEUE_COUNT ? MAX_QUEUE_COUNT : count;
                context[4] = LVDispatchContextCreate("com.lv.user-default", count, qos);
            });
            return context[4];
        }
            break;
    }
}

@interface LVQueuePool() {
    LVDispatchContext * _context;
}
@end

@implementation LVQueuePool

- (void)dealloc {
    if (_context) {
        LVDispatchContextRelease(_context);
        _context = NULL;
    }
}

- (instancetype)initWithName:(NSString *)name queueCount:(NSUInteger)queueCount qos:(NSQualityOfService)qos {
    if(queueCount == 0 || queueCount > MAX_QUEUE_COUNT) return nil;
    self = [super init];
    _context = LVDispatchContextCreate(name.UTF8String, (uint32_t)queueCount, qos);
    if(!_context) return nil;
    _name = name;
    return self;
}

- (dispatch_queue_t)queue {
    return LVDispatchContextGetQueue(_context);
}

@end















