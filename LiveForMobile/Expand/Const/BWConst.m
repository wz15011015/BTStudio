//
//  BWConst.m
//  LiveForMobile
//
//  Created by  Sierra on 2017/6/20.
//  Copyright © 2017年 BaiFuTak. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>


#pragma mark - 字符串常量

NSString *const IsLaunchedAppKey = @"IsLaunchedApp";

NSString *const TipMsgStopPush = @"您当前正在直播，是否退出直播？";

// MARK: 乐视云
/**
 应用名称: 测试
 域名信息:
 推流域名:20994.mpush.live.lecloud.com
 播放域名:20994.mpull.live.lecloud.com
 发布点名称: live
 签名密钥: 7XBALF3GB6BIZM1JRSC8
 */
NSString *const LecloudRTMPPushDomain = @"20994.mpush.live.lecloud.com";
NSString *const LecloudRTMPPullDomain = @"20994.mpull.live.lecloud.com";
NSString *const LecloudPublishingPointKey = @"live";
NSString *const LecloudAppSignSecretKey = @"7XBALF3GB6BIZM1JRSC8";


#pragma mark - 基本类型常量

const CGFloat BottomButtonWidth = 35;
