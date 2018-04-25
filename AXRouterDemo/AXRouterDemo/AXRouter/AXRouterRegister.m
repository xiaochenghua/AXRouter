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
@property (nonatomic, strong, nullable) Class class;
@end

@implementation AXRouterRegister

+ (instancetype)registerWithUrl:(NSString *)url class:(Class)class {
    return [[self alloc] initWithUrl:url class:class];
}

- (instancetype)initWithUrl:(NSString *)url class:(Class)class {
    if (self = [super init]) {
        _url = [self formatUrlWithUrl:url];
        _class = [self formatClassWithClass:class];
    }
    return self;
}

- (nullable NSString *)formatUrlWithUrl:(NSString *)url {
    NSArray<NSString *> *tmpArray = [url componentsSeparatedByString:@"?"];
    if (tmpArray.firstObject && tmpArray.firstObject.length) {
        return tmpArray.firstObject;
    }
    return nil;
}

- (nullable Class)formatClassWithClass:(Class)cls {
    return [cls isSubclassOfClass:UIViewController.class] ? cls : nil;
}

- (NSString *)description {
    return [NSString stringWithFormat:@"url: %@, class: %@", self.url, NSStringFromClass(self.class)];
}

@end
