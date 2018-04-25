//
//  UIViewController+AXRouterParameter.h
//  AXRouterDemo
//
//  Created by arnoldxiao on 2018/4/2.
//  Copyright © 2018年 arnoldxiao. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIViewController (AXRouterParameter)

@property (nonatomic, copy, nullable) NSDictionary *routerParameter;

@end

NS_ASSUME_NONNULL_END
