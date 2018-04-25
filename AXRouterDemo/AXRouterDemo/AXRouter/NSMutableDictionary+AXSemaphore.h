//
//  NSMutableDictionary+AXSemaphore.h
//  AXRouterDemo
//
//  Created by arnoldxiao on 2018/3/22.
//  Copyright © 2018年 arnoldxiao. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSMutableDictionary (AXSemaphore)

/** 线程安全设置字典key&value */
- (void)ax_setValue:(id)value forKey:(NSString *)key;

@end

NS_ASSUME_NONNULL_END
