//
//  AppDelegate.m
//  人人社交
//
//  Created by mac on 15/10/8.
//  Copyright (c) 2015年 huiwen. All rights reserved.
//

#import "AppDelegate.h"
#import "MainTabBarViewController.h"
#import "CDUserFactory.h"
#import "LeftViewController.h"
#import "RightViewController.h"
#import "MMDrawerController.h"
#import "MMExampleDrawerVisualStateManager.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    self.window = [[UIWindow alloc]initWithFrame:[UIScreen mainScreen].bounds];
    self.window.backgroundColor = [UIColor whiteColor];
    
    [self.window makeKeyAndVisible];
    MainTabBarViewController *mainTabVc = [[MainTabBarViewController alloc]init];
    
    //左右滑动实现
    
    LeftViewController *leftViewController = [[LeftViewController alloc]init];
    RightViewController *rightViewController = [[RightViewController alloc]init];
    
    //设置左右视图
    MMDrawerController *drawerController = [[MMDrawerController alloc]initWithCenterViewController:mainTabVc leftDrawerViewController:leftViewController rightDrawerViewController:rightViewController];
    //设置左右两边宽度
    [drawerController setMaximumLeftDrawerWidth:150.0];
    [drawerController setMaximumRightDrawerWidth:80.0];
    //设置手势区域
    [drawerController setOpenDrawerGestureModeMask:MMOpenDrawerGestureModeAll];
    [drawerController setCloseDrawerGestureModeMask:MMCloseDrawerGestureModeAll];
    //设置动画效果
    [[MMExampleDrawerVisualStateManager sharedManager] setLeftDrawerAnimationType:MMDrawerAnimationTypeParallax];
    MMDrawerControllerDrawerVisualStateBlock block = [MMDrawerVisualState slideAndScaleVisualStateBlock];
    [drawerController setDrawerVisualStateBlock:block];
    
    self.window.rootViewController = drawerController;
    // 初始化 LeanCloud SDK
    [AVOSCloud setApplicationId:kApplicationId clientKey:kClientKey];
    
    [CDChatManager manager].userDelegate = [[CDUserFactory alloc]init];
    
    /** 开启统计功能, 默认是开启状态
     @param value 设置成NO, 就可以关闭统计功能, 防止开发时测试数据污染线上数据.
     */
    [AVAnalytics setAnalyticsEnabled:YES];
    [AVOSCloud setAllLogsEnabled:YES];
    
    
    
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
