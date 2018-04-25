//
//  NSMutableDictionary+AXSemaphore.m
//  AXRouterDemo
//
//  Created by arnoldxiao on 2018/3/22.
//  Copyright © 2018年 arnoldxiao. All rights reserved.
//

#import "NSMutableDictionary+AXSemaphore.h"

@implementation NSMutableDictionary (AXSemaphore)

- (void)ax_setValue:(id)value forKey:(NSString *)key {
    dispatch_semaphore_t semaphore = dispatch_semaphore_create(1);
    dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
    [self setValue:value forKey:key];
    dispatch_semaphore_signal(semaphore);
}

@end
