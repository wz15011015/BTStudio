//
//  BWConst.h
//  LiveForMobile
//
//  Created by  Sierra on 2017/6/20.
//  Copyright © 2017年 BaiFuTak. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>


#pragma mark - 宏

#define MESSAGE_TABLEVIEW_H (120)        // 直播界面和播放界面消息TableView的高度
#define MESSAGE_TABLEVIEW_W (WIDTH - 65) // 直播界面和播放界面消息TableView的宽度


#pragma mark - 字符串常量

UIKIT_EXTERN NSString *const IsLaunchedAppKey; // 是否启动过App

UIKIT_EXTERN NSString *const TipMsgStopPush;

// MARK: 乐视云

UIKIT_EXTERN NSString *const LecloudRTMPPushDomain;
UIKIT_EXTERN NSString *const LecloudRTMPPullDomain;
UIKIT_EXTERN NSString *const LecloudAppSignSecretKey;
UIKIT_EXTERN NSString *const LecloudPublishingPointKey;


// MARK: 礼物资源包

UIKIT_EXTERN NSString *const GiftResourceBundleKey;


#pragma mark - 基本类型常量

UIKIT_EXTERN const CGFloat BottomButtonWidth; // BWPushDecorateView中底部按钮的宽度

UIKIT_EXTERN const CGFloat ChatInputViewHeight; // 直播界面和播放界面聊天输入框view的高度
