//
//  AXRouterDetailViewController.h
//  AXRouterDemo
//
//  Created by xiaochenghua on 2018/4/23.
//  Copyright © 2018 arnoldxiao. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface AXRouterDetailViewController : UIViewController

/**
 子类需要重写此方法
 */
- (NSString *)navigationItemTitle;

@end

NS_ASSUME_NONNULL_END
