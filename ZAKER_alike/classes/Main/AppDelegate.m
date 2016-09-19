//
//  AppDelegate.m
//  ZAKER_alike
//
//  Created by 王思齐 on 16/8/29.
//  Copyright © 2016年 wangsiqi. All rights reserved.
//

#import "AppDelegate.h"
#import "MainTabBarController.h"
//#import <BmobSDK/Bmob.h>
@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    //初始化Bmob
    [Bmob registerWithAppKey:@"7331678d426e14e06e250dee9f69145a"];
    
    //bounds 编程尺寸 ---必写
    self.window = [[UIWindow alloc]initWithFrame:[[UIScreen mainScreen]bounds]];
    //窗口的默认背景是透明，黑色 ---非必须
    self.window.backgroundColor = [UIColor whiteColor];
    //让window出现在屏幕上，并且标记成keyWindow ---必写
    [self. window makeKeyAndVisible];
    //设置根视图控制器 ---必写(注意，这里的根视图控制器要自定，看情况)
    self.window.rootViewController = [[MainTabBarController alloc]init];

    //电池条
    [application setStatusBarStyle:UIStatusBarStyleLightContent];
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
