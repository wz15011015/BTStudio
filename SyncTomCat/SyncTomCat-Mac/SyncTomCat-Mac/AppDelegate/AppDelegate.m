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
    
    // 注册通知
    NSNotificationCenter *defaultCenter = [NSNotificationCenter defaultCenter];
    [defaultCenter addObserver:self selector:@selector(applicationWindowWillClose:) name:NSWindowWillCloseNotification object:nil];
}

- (void)applicationWillTerminate:(NSNotification *)aNotification {
    // Insert code here to tear down your application
}

/// 当关闭最后一个窗口时,退出应用程序
/// @param sender 应用程序
- (BOOL)applicationShouldTerminateAfterLastWindowClosed:(NSApplication *)sender {
    return YES;
}


#pragma mark - Custom Notification

/// 关闭窗口的通知 (注意: 关闭任意窗口时都会收到通知)
/// @param aNotification 通知
- (void)applicationWindowWillClose:(NSNotification *)aNotification {
//    [NSApp terminate:self];
}

@end
