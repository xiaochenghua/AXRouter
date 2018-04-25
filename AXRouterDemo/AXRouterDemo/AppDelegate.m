//
//  AppDelegate.m
//  AXRouterDemo
//
//  Created by arnoldxiao on 20/03/2018.
//  Copyright © 2018 arnoldxiao. All rights reserved.
//

#import "AppDelegate.h"
#import "AXRouterManager.h"
#import "AXRouterRegister.h"
#import "AXRouterHomeViewController.h"
#import "AXRouterMeViewController.h"
#import "NSMutableDictionary+AXSemaphore.h"

//  register
#import "AXRouterDetail0ViewController.h"
#import "AXRouterDetail1ViewController.h"

@interface AppDelegate ()

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    [self.window makeKeyAndVisible];
    
    
    AXRouterHomeViewController *homeViewController = [[AXRouterHomeViewController alloc] init];
    AXRouterMeViewController *meViewController = [[AXRouterMeViewController alloc] init];
    
    [[UITabBarItem appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName : AXColor(136, 136, 136)} forState:UIControlStateNormal];
    [[UITabBarItem appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName : AXColor(217, 111, 93)} forState:UIControlStateSelected];
    
    UINavigationController *navigationController1 = [[UINavigationController alloc] initWithRootViewController:homeViewController];
    navigationController1.tabBarItem.title = @"主页";
    navigationController1.tabBarItem.image = [UIImage imageNamed:@"icon_tabbar_home_normal"];
    navigationController1.tabBarItem.selectedImage = [[UIImage imageNamed:@"icon_tabbar_home_active"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    UINavigationController *navigationController2 = [[UINavigationController alloc] initWithRootViewController:meViewController];
    navigationController2.tabBarItem.title = @"我";
    navigationController2.tabBarItem.image = [UIImage imageNamed:@"icon_tabbar_me_normal"];
    navigationController2.tabBarItem.selectedImage = [[UIImage imageNamed:@"icon_tabbar_me_active"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];

    UITabBarController *tabBarController = [[UITabBarController alloc] init];
    tabBarController.viewControllers = @[navigationController1, navigationController2];
    tabBarController.selectedViewController = navigationController1;
    
    self.window.rootViewController = tabBarController;
    
    //  --------------------------------注册router--------------------------------
    [[AXRouterManager manager] addRegister:[AXRouterRegister registerWithUrl:@"xiaochenghua://detail0" class:AXRouterDetail0ViewController.class]];
    [[AXRouterManager manager] addRegister:[AXRouterRegister registerWithUrl:@"xiaochenghua://detail1" class:AXRouterDetail1ViewController.class]];
    
    /**
     ------- Also you can register them by an array of <#AXRouterRegister#> -------
     [[AXRouterManager manager] addRegisters:@[[AXRouterRegister registerWithUrl:@"xiaochenghua://detail0" class:AXRouterDetail0ViewController.class],
     [AXRouterRegister registerWithUrl:@"xiaochenghua://detail1" class:AXRouterDetail1ViewController.class]]];
     */
    
    return YES;
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end
