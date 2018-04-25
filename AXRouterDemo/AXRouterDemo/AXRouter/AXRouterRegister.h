//
//  AXRouterRegister.h
//  AXRouterDemo
//
//  Created by arnoldxiao on 2018/4/3.
//  Copyright © 2018年 arnoldxiao. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface AXRouterRegister : NSObject

@property (nonatomic, copy, nullable, readonly) NSString *url;
@property (nonatomic, strong, nullable, readonly) Class class;

+ (instancetype)registerWithUrl:(NSString *)url class:(Class)class;

@end

NS_ASSUME_NONNULL_END
