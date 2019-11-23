//
//  AppDelegate.m
//  SyncTomCat-Mac
//
//  Created by  Sierra on 2017/7/19.
//  Copyright © 2017年 BTStudio. All rights reserved.
//

#import "AppDelegate.h"

@interface AppDelegate ()

@end

@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    // Insert code here to initialize your application
    
    // 1. 点击关闭按钮时,直接让应用程序退出
    // 注册 NSWindowWillCloseNotification 通知,然后在通知方法中退出应用程序
    NSNotificationCenter *defaultCenter = [NSNotificationCenter defaultCenter];
    [defaultCenter addObserver:self selector:@selector(applicationWindowWillClose:) name:NSWindowWillCloseNotification object:nil];
}

- (void)applicationWillTerminate:(NSNotification *)aNotification {
    // Insert code here to tear down your application
}


#pragma mark - Custom Notification

- (void)applicationWindowWillClose:(NSNotification *)aNotification {
    [NSApp terminate:self];
}

@end
