//
//  WebSocketManager.h
//  YiHuiWaiBiDuiHuan
//
//  Created by  Sierra on 2017/5/5.
//  Copyright © 2017年 YIHUALONG Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@class SRWebSocket;


#pragma mark - WebSocketManagerDelegate

@protocol WebSocketManagerDelegate <NSObject>

@optional
// 收到币种报价信息
- (void)webSocketManagerDidReceiveQuotationsMessage:(id)message;

// 止盈转单
- (void)webSocketManagerDidReceiveStopProfitMessage:(id)message;

// 止损转单
- (void)webSocketManagerDidReceiveStopLossMessage:(id)message;

// 提示信息
- (void)webSocketManagerDidReceiveNoticeMessage:(id)message;

@end


/**
 webSocket管理类
 */
@interface WebSocketManager : NSObject

/**
 webSocket
 */
@property (nonatomic, strong) SRWebSocket *webSocket;

/**
 webSocket是否处于连接状态
 */
@property (nonatomic, assign, getter=isConnected) BOOL connected;

// HomeViewController中使用
@property (nonatomic, assign) id <WebSocketManagerDelegate>delegate;

// AppointmentViewController中使用
@property (nonatomic, assign) id <WebSocketManagerDelegate>delegate2;

// QueryViewController中使用
@property (nonatomic, assign) id <WebSocketManagerDelegate>delegate3;


#pragma mark - 回调Block

@property (nonatomic, copy) void(^webSocketBlock)(void);


#pragma mark - 单例实现

+ (instancetype)sharedInstance;


#pragma mark - WebSocket Methods

// 连接webSocket
- (void)connectWebSocket;

// 关闭webSocket
- (void)closeWebSocket;

/**
 发送Json数据到webSocket服务器

 @param jsonString Json格式字符串
 */
- (void)sendMessage:(NSString *)jsonString;

@end
