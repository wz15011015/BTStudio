//
//  BWHUDHelper.m
//  LiveForMobile
//
//  Created by  Sierra on 2017/7/4.
//  Copyright © 2017年 BaiFuTak. All rights reserved.
//

#import "BWHUDHelper.h"

@implementation BWHUDHelper

SINGLETON_IMPLEMENTATION(BWHUDHelper)

// 显示提示信息 (在KeyWindow上，可设置显示时长)
- (void)showHUDMessageInKeyWindow:(NSString *)message afterDelay:(NSTimeInterval)delay {
    MBProgressHUD *progressHUD = [MBProgressHUD showHUDAddedTo:[UIApplication sharedApplication].keyWindow animated:YES];
    progressHUD.mode = MBProgressHUDModeText;
    progressHUD.bezelView.color = [UIColor blackColor]; // 显示label的view的颜色
    progressHUD.contentColor = [UIColor whiteColor]; // 文字颜色
    progressHUD.removeFromSuperViewOnHide = YES;
    //    progressHUD.margin = 10.0;
    
    if (message.length > 17) { // 字数超过17时，用detailsLabel显示
        progressHUD.detailsLabel.text = message;
    } else {
        progressHUD.label.text = message;
    }
    [progressHUD hideAnimated:YES afterDelay:delay];
}

// 显示提示信息 (在KeyWindow上)
- (void)showHUDMessageInKeyWindow:(NSString *)message {
    [self showHUDMessageInKeyWindow:message afterDelay:1.2];
}

@end
