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

NSString * const kAXRouterUrlKey = @"AXRouterUrlKey";
NSString * const kAXRouterClassKey = @"AXRouterClassKey";
static NSString * const kAXRouterRegularExpression = @"^[+-]?[0-9]+(.[0-9]+)?$";
static NSString * const kAXRouterStorageKey = @"AXRouterStorageKey";

#define WEAKSELF    __weak typeof(self) weakSelf = self
#define STRONGSELF  __strong typeof(weakSelf) self = weakSelf

@interface AXRouterManager ()
@property (nonatomic, copy) NSString *url;
@property (nonatomic) UINavigationController *navigationController;
@property (nonatomic) UIViewController *topViewController;
@property (nonatomic) UIViewController *visibleViewController;
@property (nonatomic) NSMutableArray<NSDictionary<NSString *, NSString *> *> *parameterArray;
@property (nonatomic) dispatch_queue_t registerQueue;
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

- (void)dealloc {
    [self.parameterArray removeAllObjects];
    [[NSUserDefaults standardUserDefaults] setObject:self.parameterArray.copy forKey:kAXRouterStorageKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

#pragma mark - register
- (void)addRegisters:(NSArray<AXRouterRegister *> *)regs {
    WEAKSELF;
    dispatch_async(self.registerQueue, ^{
        STRONGSELF;
        for (AXRouterRegister *reg in regs) {
            [self singleTaskWithRegister:reg];
        }
    });
}

- (void)addRegister:(AXRouterRegister *)reg {
    WEAKSELF;
    dispatch_async(self.registerQueue, ^{
        STRONGSELF;
        [self singleTaskWithRegister:reg];
    });
}

- (void)singleTaskWithRegister:(AXRouterRegister *)reg {
    if (!reg.url || !reg.class) {
        return;
    }
    
    NSArray<NSDictionary<NSString *, NSString *> *> *tmpArray = (NSArray *)[[NSUserDefaults standardUserDefaults] objectForKey:kAXRouterStorageKey];
    for (NSDictionary<NSString *, NSString *> *dic in tmpArray) {
        if ([reg.url isEqualToString:dic[kAXRouterUrlKey]] && [NSStringFromClass(reg.class) isEqualToString:dic[kAXRouterClassKey]]) {
            return;
        }
    }
    
    [self parseUrl:reg.url class:reg.class];
    
    [[NSUserDefaults standardUserDefaults] setObject:self.parameterArray.copy forKey:kAXRouterStorageKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)parseUrl:(NSString *)url class:(nonnull Class)class {
    NSMutableDictionary<NSString *, NSString *> *dictionary = [NSMutableDictionary dictionary];
    
    NSArray<NSString *> *destSchemeArray = [url componentsSeparatedByString:@"://"];
    if (destSchemeArray.count != 2) { return; }
    if (![[self urlSchemes] containsObject:destSchemeArray.firstObject]) { return; }
    
    [dictionary ax_setValue:url forKey:kAXRouterUrlKey];
    [dictionary ax_setValue:NSStringFromClass(class) forKey:kAXRouterClassKey];
    [self.parameterArray addObject:dictionary];
}

- (NSArray<NSString *> *)urlSchemes {
    NSArray *urlTypes = (NSArray *)[[NSBundle mainBundle] infoDictionary][@"CFBundleURLTypes"];
    NSMutableArray *mutableArray = [NSMutableArray array];
    for (NSDictionary *dict in urlTypes) {
        [mutableArray addObjectsFromArray:(NSArray *)dict[@"CFBundleURLSchemes"]];
    }
    return mutableArray.copy;
}

#pragma mark - openUrl
- (void)openUrl:(NSString *)url {
    [self openUrl:url type:AXRouterTypePush];
}

- (void)openUrl:(NSString *)url type:(AXRouterType)type {
    NSArray *storedArray = [[NSUserDefaults standardUserDefaults] objectForKey:kAXRouterStorageKey];
    if (!storedArray || !storedArray.count) { return; }
    
    Class class = nil;
    NSString *formatUrl = [url componentsSeparatedByString:@"?"].firstObject ?: @"";
    for (NSDictionary<NSString *, NSString *> *dic in storedArray) {
        if ([formatUrl isEqualToString:dic[kAXRouterUrlKey]]) {
            class = NSClassFromString(dic[kAXRouterClassKey]);
            break;
        }
    }
    
    if (!class) { return; }
    
    UIViewController *viewController = (UIViewController *)[[class alloc] init];
    viewController.routerParameter = [self routerParameterWithUrl:url];
    viewController.hidesBottomBarWhenPushed = YES;
    
    if (viewController) {
        switch (type) {
            case AXRouterTypePush: {
                [self dismissAllPresentedViewControllers];           //  确保当前没有presentedViewController
                [self.navigationController pushViewController:viewController animated:YES];
                break;
            }
            case AXRouterTypePresent: {
                [self.visibleViewController presentViewController:viewController animated:YES completion:nil];
                break;
            }
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
- (NSMutableArray<NSDictionary<NSString *,NSString *> *> *)parameterArray {
    if (!_parameterArray) {
        _parameterArray = [NSMutableArray array];
    }
    return _parameterArray;
}

- (dispatch_queue_t)registerQueue {
    if (!_registerQueue) {
        _registerQueue = dispatch_queue_create("axrouter.register", DISPATCH_QUEUE_SERIAL);
    }
    return _registerQueue;
}

@end
