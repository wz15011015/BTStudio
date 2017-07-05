//
//  BWHUDHelper.h
//  LiveForMobile
//
//  Created by  Sierra on 2017/7/4.
//  Copyright © 2017年 BaiFuTak. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BWMacro.h"

@interface BWHUDHelper : NSObject

SINGLETON_INTERFACE(BWHUDHelper)

/**
 显示提示信息 (在KeyWindow上，可设置显示时长)
 
 @param message 提示信息的内容
 @param delay 延时时间
 */
- (void)showHUDMessageInKeyWindow:(NSString *)message afterDelay:(NSTimeInterval)delay;

/**
 显示提示信息 (在KeyWindow上)
 
 @param message 提示信息的内容
 */
- (void)showHUDMessageInKeyWindow:(NSString *)message;

@end
