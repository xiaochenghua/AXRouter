//
//  UIViewController+AXRouterParameter.m
//  AXRouterDemo
//
//  Created by arnoldxiao on 2018/4/2.
//  Copyright © 2018年 arnoldxiao. All rights reserved.
//

#import "UIViewController+AXRouterParameter.h"
#import <objc/runtime.h>

static NSString *const kAXRouterParameterKey;

@implementation UIViewController (AXRouterParameter)

- (NSDictionary *)routerParameter {
    return objc_getAssociatedObject(self, &kAXRouterParameterKey);
}

- (void)setRouterParameter:(NSDictionary *)routerParameter {
    objc_setAssociatedObject(self, &kAXRouterParameterKey, routerParameter, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

@end
