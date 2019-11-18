//
//  AppDelegate.m
//  TouchIDDemo
//
//  Created by WangZhi on 16/6/15.
//  Copyright © 2016年 WangZhi. All rights reserved.
//

#import "AppDelegate.h"
#import "ViewController.h"
#import "BaseNavigationViewController.h"

#import "SettingViewController.h"
#import "DeviceLockViewController.h"
#import "FingerprintSettingViewController.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    
    ViewController *vc = [[ViewController alloc] init];
    BaseNavigationViewController *nav = [[BaseNavigationViewController alloc] initWithRootViewController:vc];
    self.window.rootViewController = nav;
    
    [self.window makeKeyAndVisible];
    
    
//    NSString *title = @"";
//    if ([launchOptions objectForKey:@"UIApplicationLaunchOptionsShortcutItemKey"] != nil) {
//        UIApplicationShortcutItem *shortcutItem = [launchOptions objectForKey:@"UIApplicationLaunchOptionsShortcutItemKey"];
//        if ([shortcutItem.type isEqualToString:@"one"]) {
//            title = @"one  ShortcutItemKey";
//        } else if ([shortcutItem.type isEqualToString:@"two"]) {
//            title = @"two  ShortcutItemKey";
//        } else {
//            title = @"three  ShortcutItemKey"; 
//        }
//    } else {
//        title = @"No ShortcutItemKey";
//    }
//    
//    UIAlertController *alert = [UIAlertController alertControllerWithTitle:title message:nil preferredStyle:UIAlertControllerStyleAlert];
//    [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
//        
//    }]];
//    [self.window.rootViewController presentViewController:alert animated:YES completion:nil];
    
    
    
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

#pragma mark - 3D Touch
- (void)application:(UIApplication *)application performActionForShortcutItem:(UIApplicationShortcutItem *)shortcutItem completionHandler:(void(^)(BOOL succeeded))completionHandler {
    
    BaseNavigationViewController *nav = (BaseNavigationViewController *)self.window.rootViewController;
    
    if ([shortcutItem.type isEqualToString:@"one"]) {
        SettingViewController *settingVC = [[SettingViewController alloc] init];
        settingVC.title = @"设置";
        [nav pushViewController:settingVC animated:YES];
    } else if ([shortcutItem.type isEqualToString:@"two"]) {
        DeviceLockViewController *settingVC = [[DeviceLockViewController alloc] init];
        settingVC.title = @"设备锁、帐号安全";
        [nav pushViewController:settingVC animated:YES];
    } else {
        FingerprintSettingViewController *settingVC = [[FingerprintSettingViewController alloc] init];
        settingVC.title = @"手势、指纹锁定";
        [nav pushViewController:settingVC animated:YES];
    }
    
    
    
//    NSString *title = nil;
//    if ([shortcutItem.type isEqualToString:@"one"]) {
//        title = @"one";
//    } else if ([shortcutItem.type isEqualToString:@"two"]) {
//        title = @"two";
//    } else {
//        title = @"three";
//    }
//    UIAlertController *alert = [UIAlertController alertControllerWithTitle:title message:nil preferredStyle:UIAlertControllerStyleAlert];
//    [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
//
//    }]];
//    [self.window.rootViewController presentViewController:alert animated:YES completion:nil];
}

@end
