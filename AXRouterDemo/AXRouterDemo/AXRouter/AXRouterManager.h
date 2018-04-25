//
//  AXRouterManager.h
//  AXRouterDemo
//
//  Created by arnoldxiao on 20/03/2018.
//  Copyright © 2018 arnoldxiao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

extern NSString * const kAXRouterUrlKey;
extern NSString * const kAXRouterClassKey;

typedef NS_ENUM(NSInteger, AXRouterType) {
    AXRouterTypePush,
    AXRouterTypePresent,
};

@class AXRouterRegister;

@interface AXRouterManager : NSObject

/** 返回当前导航容器栈顶的容器，如果没有导航容器，则返回Window的根容器 */
@property (nonatomic, readonly) UIViewController *topViewController;

/** 返回当前屏幕可见的容器 */
@property (nonatomic, readonly) UIViewController *visibleViewController;

+ (instancetype)manager;

- (void)addRegister:(AXRouterRegister *)reg;

- (void)addRegisters:(NSArray<AXRouterRegister *> *)regs;

- (void)openUrl:(NSString *)url;

- (void)openUrl:(NSString *)url type:(AXRouterType)type;

@end

NS_ASSUME_NONNULL_END
