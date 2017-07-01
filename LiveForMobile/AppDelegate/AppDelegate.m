//
//  AppDelegate.m
//  LiveForMobile
//
//  Created by  Sierra on 2017/6/20.
//  Copyright © 2017年 BaiFuTak. All rights reserved.
//

#import "AppDelegate.h"
#import "BWMacro.h"
#import "BWTabBarController.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    // 1. 创建Window根视图
    [self createRootWindow];
    
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


#pragma mark - 创建Window根视图

- (void)createRootWindow {
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor whiteColor];
    
    BOOL isLaunchedApp = [[NSUserDefaults standardUserDefaults] boolForKey:IsLaunchedAppKey];
    isLaunchedApp = YES;
    if (!isLaunchedApp) { // 如果未启动过App，说明是第一次使用App，则进入引导页
//        GuideViewController *guideVC = [[GuideViewController alloc] init];
//        self.window.rootViewController = guideVC;
//        [self.window makeKeyAndVisible];
        
    } else { // 如果启动过App,则直接进入App
        
        //        BOOL isLogin = [[NSUserDefaults standardUserDefaults] boolForKey:IsUserLoginAppKey];
        //        isLogin = YES;
        //        if (!isLogin) { // 如果未登录App，则进入登录页面
        //
        //            LoginViewController *loginVC = [[LoginViewController alloc] init];
        //            self.window.rootViewController = loginVC;
        //            [self.window makeKeyAndVisible];
        //
        //        } else { // 如果已登录App，则进入首页
        
                    BWTabBarController *rootVC = [[BWTabBarController alloc] init];
                    self.window.rootViewController = rootVC;
                    [self.window makeKeyAndVisible];
        //        }
    }
}

@end
