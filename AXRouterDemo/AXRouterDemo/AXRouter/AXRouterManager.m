//
//  AXRouter.m
//  AXRouterDemo
//
//  Created by arnoldxiao on 20/03/2018.
//  Copyright © 2018 arnoldxiao. All rights reserved.
//

#import "AXRouterManager.h"
#import "AXRouterRegister.h"
#import "NSMutableDictionary+AXSemaphore.h"

static NSString * const kAXRouterRegularExpression = @"^[+-]?[0-9]+(.[0-9]+)?$";
static NSString * const kAXRouterRegistersKey = @"AXRouterRegistersKey";

//#define WEAKSELF    __weak typeof(self) weakSelf = self
//#define STRONGSELF  __strong typeof(weakSelf) self = weakSelf

@interface AXRouterManager ()
@property (nonatomic, copy) NSString *url;
@property (nonatomic) UINavigationController *navigationController;
@property (nonatomic) UIViewController *topViewController;
@property (nonatomic) UIViewController *visibleViewController;
@property (nonatomic) dispatch_queue_t registerQueue;
@property (nonatomic) NSMutableArray<NSData *> *registerMutableArray;
@property (nonatomic, copy) NSArray<NSData *> *registers;
@end

@implementation AXRouterManager

static AXRouterManager *_instance = nil;

#pragma mark - creater
+ (instancetype)manager {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[[self class] alloc] init];
    });
    return _instance;
}

+ (instancetype)allocWithZone:(struct _NSZone *)zone {
    if (!_instance) {
        _instance = [super allocWithZone:zone];
    }
    return _instance;
}

#pragma mark - register
- (void)addRegisters:(NSArray<AXRouterRegister *> *)regs {
    for (AXRouterRegister *reg in regs) {
        [self archiveDataWithRegister:reg];
    }
}

- (void)addRegister:(AXRouterRegister *)reg {
    [self archiveDataWithRegister:reg];
}

- (void)archiveDataWithRegister:(AXRouterRegister *)reg {
    if (!reg.url || !reg.className) {
        return;
    }
    
    NSArray<NSData *> *tmpArray = (NSArray<NSData *> *)[[NSUserDefaults standardUserDefaults] objectForKey:kAXRouterRegistersKey];
    
    //  加载已有的注册
//    [self.registerMutableArray addObjectsFromArray:tmpArray];
    
    //  tmpArray有值才需要做以下操作
    for (NSData *data in tmpArray) {
        if (![self.registerMutableArray containsObject:data]) {
            [self.registerMutableArray addObject:data];
        }
        
        AXRouterRegister *rr = (AXRouterRegister *)[NSKeyedUnarchiver unarchiveObjectWithData:data];
        if ([reg.url isEqualToString:rr.url] && [reg.className isEqualToString:rr.className]) {
            return;
        }
        //  url相等，class不等的情况下需要覆盖class，后期再做
    }
    
    [self.registerMutableArray addObject:[NSKeyedArchiver archivedDataWithRootObject:reg]];
    
    [[NSUserDefaults standardUserDefaults] setObject:self.registers forKey:kAXRouterRegistersKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

#pragma mark - openUrl
- (void)openUrl:(NSString *)url {
    [self openUrl:url mode:AXRouterModePush];
}

- (void)openUrl:(NSString *)url mode:(AXRouterMode)mode {
    NSArray<NSData *> *tmpArray = (NSArray<NSData *> *)[[NSUserDefaults standardUserDefaults] objectForKey:kAXRouterRegistersKey];
    if (!tmpArray || !tmpArray.count) { return; }
    
    Class cls = nil;
    NSString *formatUrl = (NSString *)[url componentsSeparatedByString:@"?"].firstObject;
    
    for (NSData *data in tmpArray) {
        AXRouterRegister *rr = (AXRouterRegister *)[NSKeyedUnarchiver unarchiveObjectWithData:data];
        if ([formatUrl isEqualToString:rr.url]) {
            cls = NSClassFromString(rr.className);
            break;
        }
    }
    
    if (!cls) { return; }
    
    UIViewController *viewController = (UIViewController *)[[cls alloc] init];
    viewController.routerParameter = [self routerParameterWithUrl:url];
    viewController.hidesBottomBarWhenPushed = YES;
    
    switch (mode) {
        case AXRouterModePush: {
            [self dismissAllPresentedViewControllers];           //  确保当前没有presentedViewController
            [self.navigationController pushViewController:viewController animated:YES];
            break;
        }
            
        case AXRouterModePresent: {
            [self.visibleViewController presentViewController:viewController animated:YES completion:nil];
            break;
        }
    }
}

- (nullable NSDictionary *)routerParameterWithUrl:(NSString *)url {
    NSArray *tmpArray = [url componentsSeparatedByString:@"?"];
    if (tmpArray.count != 2) { return nil; }
    
    NSArray<NSString *> *parameterArray = [tmpArray.lastObject componentsSeparatedByString:@"&"];
    NSMutableDictionary *tempDictionary = [NSMutableDictionary dictionary];
    
    for (NSString *mapper in parameterArray) {
        if (!mapper.length || ![mapper containsString:@"="]) { continue; }
        NSArray<NSString *> *mapperArray = [mapper componentsSeparatedByString:@"="];
        if (mapperArray.count != 2) { continue; }
        if (!mapperArray.firstObject.length || !mapperArray.lastObject.length) { continue; }
        
        if ([mapperArray.lastObject rangeOfString:kAXRouterRegularExpression options:NSRegularExpressionSearch].location != NSNotFound) {
            //  数字字符串
            if ([mapperArray.lastObject containsString:@"."]) {
                [tempDictionary ax_setValue:@(mapperArray.lastObject.doubleValue) forKey:mapperArray.firstObject];
            } else {
                [tempDictionary ax_setValue:@(mapperArray.lastObject.integerValue) forKey:mapperArray.firstObject];
            }
        } else {
            //  非数字字符串
            [tempDictionary ax_setValue:mapperArray.lastObject forKey:mapperArray.firstObject];
        }
    }
    return tempDictionary.copy;
}

#pragma mark - dismiss
- (void)dismissAllPresentedViewControllers {
    if ([self.visibleViewController isEqual:self.topViewController]) { return; }
    [self.visibleViewController dismissViewControllerAnimated:YES completion:nil];
    [self dismissAllPresentedViewControllers];
}

#pragma mark - view controller
/** Window根容器 */
- (nullable UIViewController *)rootViewController {
    return [UIApplication sharedApplication].delegate.window.rootViewController;
}

/** 当前导航控制器 */
- (nullable UINavigationController *)navigationController {
    if ([[self rootViewController] isKindOfClass:[UITabBarController class]]) {
        UIViewController *viewController = ((UITabBarController *)[self rootViewController]).selectedViewController;
        if ([viewController isKindOfClass:[UINavigationController class]]) {
            return (UINavigationController *)viewController;
        }
        return nil;
    } else if ([[self rootViewController] isKindOfClass:[UINavigationController class]]) {
        return (UINavigationController *)[self rootViewController];
    }
    return nil;
}

- (UIViewController *)topViewController {
    if (!self.navigationController) {
        return [self rootViewController];
    }
    return self.navigationController.topViewController;
}

- (UIViewController *)visibleViewController {
    return [self presentedViewControllerOfViewController:self.topViewController];
}

/** 递归遍历出最后出现的presentedViewController */
- (UIViewController *)presentedViewControllerOfViewController:(UIViewController *)viewController {
    if (viewController.presentedViewController) {
        return [self presentedViewControllerOfViewController:viewController.presentedViewController];
    }
    return viewController;
}

#pragma mark - lazy loading
- (dispatch_queue_t)registerQueue {
    if (!_registerQueue) {
        _registerQueue = dispatch_queue_create("axrouter.register", DISPATCH_QUEUE_SERIAL);
    }
    return _registerQueue;
}

- (NSMutableArray<NSData *> *)registerMutableArray {
    if (!_registerMutableArray) {
        _registerMutableArray = [NSMutableArray array];
    }
    return _registerMutableArray;
}

- (NSArray<NSData *> *)registers {
    return self.registerMutableArray.copy;
}

@end
