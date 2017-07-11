//
//  WebSocketManager.m
//  YiHuiWaiBiDuiHuan
//
//  Created by  Sierra on 2017/5/5.
//  Copyright © 2017年 YIHUALONG Inc. All rights reserved.
//

#import "WebSocketManager.h"
#import "SRWebSocket.h"
#import "BaseViewController.h"

@interface WebSocketManager () <SRWebSocketDelegate>

@end

@implementation WebSocketManager

static WebSocketManager *_instance;

+ (void)load {
    [self sharedInstance];
}

+ (instancetype)sharedInstance {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[self alloc] init];
    });
    return _instance;
}


#pragma mark - WebSocket Methods

// 连接webSocket
- (void)connectWebSocket {
    self.webSocket = [[SRWebSocket alloc] initWithURLRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:kWebSocketURL]]];
    self.webSocket.delegate = self;
    [self.webSocket open];
    
    NSLog(@"* connect webSocket, URL: %@", kWebSocketURL);
}

// 关闭webSocket
- (void)closeWebSocket {
    [self.webSocket close];
    
    self.connected = NO;
    self.webSocket = nil;
    self.webSocket.delegate = nil;
    
//    NSDictionary *dic = @{@"action" : @"loginout"};
//    [self sendMessage:[self jsonStringFromDictionary:dic]];
}

// 发送Json数据到webSocket服务器
- (void)sendMessage:(NSString *)jsonString {
    [self.webSocket send:jsonString];
}


#pragma mark - SRWebSocketDelegate

// message will either be an NSString if the server is using text
// or NSData if the server is using binary.
- (void)webSocket:(SRWebSocket *)webSocket didReceiveMessage:(id)message {
    NSLog(@"* webSocket didReceiveMessage: %@", message);
    self.connected = YES;
    
    // 对接收的消息进行处理
    id responseData = [self dictionaryOrArrayFromJsonString:message];
    if ([responseData isKindOfClass:[NSDictionary class]]) {
        NSDictionary *responseDic = [self dictionaryOrArrayFromJsonString:message];
        
        // 消息头 (0:请求   1:响应)
        NSString *header = responseDic[@"H"];
        // 消息类型
        NSString *type = responseDic[@"T"];
        // 消息内容
        NSDictionary *content = responseDic[@"C"];
        
        switch ([type integerValue]) {
            case 0: { // 获取webSocket的channelId
                // 每次打开应用连接到webSocket，并获取channelId后，即去调用登录接口
                [self autoLogin];
            }
                break;
                
            case 1: { // 行情报价
//                if ([self.delegate respondsToSelector:@selector(webSocketManagerDidReceiveQuotationsMessage:)]) {
//                    [self.delegate webSocketManagerDidReceiveQuotationsMessage:content];
//                }
//                if ([self.delegate2 respondsToSelector:@selector(webSocketManagerDidReceiveQuotationsMessage:)]) {
//                    [self.delegate2 webSocketManagerDidReceiveQuotationsMessage:content];
//                }
            }
                break;
                
            case 2: { // 当日历史行情
                
            }
                break;
                
            case 3: { // 止盈转单
                NSLog(@"止盈转单:  header: %@   type: %@   content: %@", header, type, content);
//                if ([self.delegate2 respondsToSelector:@selector(webSocketManagerDidReceiveStopProfitMessage:)]) {
//                    [self.delegate2 webSocketManagerDidReceiveStopProfitMessage:content];
//                }
//                if ([self.delegate3 respondsToSelector:@selector(webSocketManagerDidReceiveStopProfitMessage:)]) {
//                    [self.delegate3 webSocketManagerDidReceiveStopProfitMessage:content];
//                }
            }
                break;
                
            case 4: { // 止损转单
                NSLog(@"止损转单:  header: %@   type: %@   content: %@", header, type, content);
//                if ([self.delegate2 respondsToSelector:@selector(webSocketManagerDidReceiveStopLossMessage:)]) {
//                    [self.delegate2 webSocketManagerDidReceiveStopLossMessage:content];
//                }
//                if ([self.delegate3 respondsToSelector:@selector(webSocketManagerDidReceiveStopLossMessage:)]) {
//                    [self.delegate3 webSocketManagerDidReceiveStopLossMessage:content];
//                }
            }
                break;
                
            case 5: { // 提示信息
                NSLog(@"提示消息:  header: %@   type: %@   content: %@", header, type, content);
                [self receivedSystemNoticeMessage:content];
            }
                break;
                
            case 6: { // 禁止充值通知
                
            }
                break;
                
            case 7: { // 禁止下单通知
                
            }
                break;
                
            case 8: { // 禁止出金通知
                
            }
                break;
                
            case 9: { // 禁止登录通知
                
            }
                break;
                
            default:
                break;
        }
    }
}

- (void)webSocketDidOpen:(SRWebSocket *)webSocket {
    NSLog(@"* webSocket connected");
}

- (void)webSocket:(SRWebSocket *)webSocket didFailWithError:(NSError *)error {
    NSLog(@"* webSocket failed with error : %@", error);
    /**
     Error Domain=com.squareup.SocketRocket Code=504 "Timeout Connecting to Server" UserInfo={NSLocalizedDescription=Timeout Connecting to Server}*/
//    NSInteger errorCode = error.code; // 504
//    NSString *errorDes = error.localizedDescription; // Timeout Connecting to Server
    
    self.connected = NO;
    self.webSocket = nil;
    self.webSocket.delegate = nil;
    // 重新连接webSocket
    [self connectWebSocket];
}

- (void)webSocket:(SRWebSocket *)webSocket didCloseWithCode:(NSInteger)code reason:(NSString *)reason wasClean:(BOOL)wasClean {
    NSLog(@"* webSocket closed");
    
    self.connected = NO;
    self.webSocket = nil;
    self.webSocket.delegate = nil;
    // 重新连接webSocket
//    [self connectWebSocket];
}

- (void)webSocket:(SRWebSocket *)webSocket didReceivePong:(NSData *)pongPayload {
    NSLog(@"* webSocket received pong");
    
    self.connected = NO;
    self.webSocket = nil;
    self.webSocket.delegate = nil;
    // 重新连接webSocket
//    [self connectWebSocket];
}


#pragma mark - Custom Methods

// MARK: 自动登录
- (void)autoLogin {
}

// MARK: 收到通知或公告
- (void)receivedSystemNoticeMessage:(id)message {
}


#pragma mark - Tool methods

// 字典转Json字符串
- (NSString *)jsonStringFromDictionary:(NSDictionary *)dic {
    NSError *parseError = nil;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:&parseError];
    if (parseError) {
        NSLog(@"Dictionary to jsonString failed with error : %@", parseError);
    }
    NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    return jsonString;
}

// Json字符串转字典或者数组
- (id)dictionaryOrArrayFromJsonString:(NSString *)jsonString {
    if (jsonString == nil) {
        NSLog(@"JsonString is nil.");
        return nil;
    }
    
    NSError *error = nil;
    NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:&error];
    if (error) {
        NSLog(@"jsonString is: %@   解析失败: %@", jsonString, error);
        return nil;
    }
    return dic;
}

@end
