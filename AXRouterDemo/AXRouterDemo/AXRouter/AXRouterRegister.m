//
//  AXRouterRegister.m
//  AXRouterDemo
//
//  Created by arnoldxiao on 2018/4/3.
//  Copyright © 2018年 arnoldxiao. All rights reserved.
//

#import "AXRouterRegister.h"

@interface AXRouterRegister ()
@property (nonatomic, copy, nullable) NSString *url;
@property (nonatomic, copy, nullable) NSString *className;
@end

static NSString * const kPropertyUrlKey     = @"url";
static NSString * const kPropertyClassKey   = @"class";

@implementation AXRouterRegister

+ (instancetype)registerWithUrl:(NSString *)url class:(Class)class {
    return [[self alloc] initWithUrl:url class:class];
}

- (instancetype)initWithUrl:(NSString *)url class:(Class)class {
    if (self = [super init]) {
        _url = [self formatUrlWithUrl:url];
        _className = [self formatClassWithClass:class];
    }
    return self;
}

- (nullable NSString *)formatUrlWithUrl:(NSString *)url {
    NSArray<NSString *> *urlArray = [url componentsSeparatedByString:@"?"];
    if (urlArray.count != 1 && urlArray.count != 2) { return nil; }
    if (!urlArray.firstObject.length) { return nil; }
    
    NSArray<NSString *> *schemeArray = [url componentsSeparatedByString:@"://"];
    if (schemeArray.count != 2) { return nil; }
    if (!schemeArray.firstObject.length) { return nil; }
    if (![[self schemes] containsObject:schemeArray.firstObject]) { return nil; }
    
    return urlArray.firstObject;
}

- (NSArray *)schemes {
    NSArray *urlTypes = (NSArray *)[[NSBundle mainBundle] infoDictionary][@"CFBundleURLTypes"];
    NSMutableArray *mutableSchemes = [NSMutableArray array];
    for (NSDictionary *dict in urlTypes) {
        [mutableSchemes addObjectsFromArray:(NSArray *)dict[@"CFBundleURLSchemes"]];
    }
    return mutableSchemes.copy;
}

- (nullable NSString *)formatClassWithClass:(Class)cls {
    return [cls isSubclassOfClass:UIViewController.class] ? NSStringFromClass(cls) : nil;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super init]) {
        self.url = [aDecoder decodeObjectForKey:kPropertyUrlKey];
        self.className = [aDecoder decodeObjectForKey:kPropertyClassKey];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:self.url forKey:kPropertyUrlKey];
    [aCoder encodeObject:self.className forKey:kPropertyClassKey];
}

- (NSString *)description {
    return [NSString stringWithFormat:@"url: %@, class: %@", self.url, self.className];
}

@end
