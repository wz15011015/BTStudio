//
//  BWGameView.m
//  LiveForMobile
//
//  Created by  Sierra on 2017/8/8.
//  Copyright © 2017年 BaiFuTak. All rights reserved.
//

#import "BWGameView.h"
#import <WebKit/WebKit.h>
#import "BWMacro.h"

#import "ShareModel.h"

#define kHomeURL @"http://www.cocoachina.com"

#define CONTENTVIEW_H (216)

NSString *const WKWebViewLoadingKey = @"loading";
NSString *const WKWebViewTitleKey = @"title";
NSString *const WKWebViewProgressKey = @"estimatedProgress";

@interface BWGameView () <WKNavigationDelegate, WKUIDelegate, WKScriptMessageHandler> {
    CGFloat _width;
    CGFloat _height;
    
    NSUInteger _timerCount;
}

@property (nonatomic, strong) UIView *blankView; // 空白view
@property (nonatomic, strong) UIView *contentView;
@property (nonatomic, strong) WKWebView *wkWebView;

@property (nonatomic, weak) UIImageView *imageView1;
@property (nonatomic, weak) UIImageView *imageView2;
@property (nonatomic, weak) UIImageView *imageView3;

@property (nonatomic, strong) NSTimer *timer;

@end

@implementation BWGameView

#pragma mark - Life cycle

- (id)init {
    if (self = [super init]) {
        [self initializeParameters];
        [self addSubViews];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        [self initializeParameters];
        [self addSubViews];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self initializeParameters];
        [self addSubViews];
    }
    return self;
}


#pragma mark - Methods

// 初始化
- (void)initializeParameters {
    _width = WIDTH;
    _height = HEIGHT;
}

// 添加子控件
- (void)addSubViews {
    [self addSubview:self.blankView];
    [self addSubview:self.contentView];
//    [self.contentView addSubview:self.wkWebView];
    
    CGFloat x = 0;
    CGFloat w = 28;
    CGFloat y = 20;
    for (int i = 0; i < 3; i++) {
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(x, y, w, w)];
        y += 40;
        if (!i) {
            imageView.image = [UIImage imageNamed:@"gift_biaobaihuayu"];
            self.imageView1 = imageView;
        } else if (1 == i) {
            imageView.image = [UIImage imageNamed:@"gift_biaobaihuayu"];
            self.imageView2 = imageView;
        } else {
            imageView.image = [UIImage imageNamed:@"gift_biaobaihuayu"];
            self.imageView3 = imageView;
        }
        [self.contentView addSubview:imageView];
    }
    
    // 动画效果
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.25];
    
    CGRect frame = self.contentView.frame;
    frame.origin.y = HEIGHT - frame.size.height;
    self.contentView.frame = frame;
    
    [UIView commitAnimations];
}

// 移除子控件
- (void)removeSubviews {
    [self.blankView removeFromSuperview];
    [self.contentView removeFromSuperview];
}


#pragma mark - Public Methods

/**
 显示在view上
 */
- (void)showToView:(UIView *)view {
    [view addSubview:self];
    
//    [self test];
    
    // 加载数据
//    NSURL *url = [NSURL URLWithString:kHomeURL];
//    NSURLRequest *request = [NSURLRequest requestWithURL:url];
//    [self.wkWebView loadRequest:request];
    
//    NSString *path = [[NSBundle mainBundle] pathForResource:@"index2" ofType:@"html"];
//    NSURL *url = [NSURL fileURLWithPath:path];
//    NSURLRequest *request = [NSURLRequest requestWithURL:url];
//    [self.wkWebView loadRequest:request];
    
    _timerCount = 0;
    self.timer = [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(updatePosition) userInfo:nil repeats:YES];
    NSLog(@"开始!!!!!!!!!!!!!!!");
}

/**
 移除view
 */
- (void)dismiss {
    [UIView animateWithDuration:0.25 animations:^{
        CGRect frame = self.contentView.frame;
        frame.origin.y = HEIGHT;
        self.contentView.frame = frame;
    } completion:^(BOOL finished) {
        if (finished) {
            [self removeSubviews];
            
            [self.timer invalidate];
            
            // 移除self
            [self removeFromSuperview];
        }
    }];
}


- (void)updatePosition {
    _timerCount += 1;
    BOOL end1 = NO;
    BOOL end2 = NO;
    BOOL end3 = NO;
    
    CGFloat spatium = (_width - 28); // 距离
    CGFloat time = 100.0; // 时间 10s
    CGFloat velocity1 = spatium / time;
    
    CGFloat time2 = 110.0; // 时间 11s
    CGFloat velocity2 = spatium / time2;
    
    CGFloat time3 = 106.0; // 时间 10.6s
    CGFloat velocity3 = spatium / time3;
    
    // 动画效果
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.1];
    {
        CGRect frame1 = self.imageView1.frame;
        if (frame1.origin.x < _width - 28) {
            frame1.origin.x += velocity1;
        } else {
            NSLog(@"1111 competition 结束!!!!");
            end1 = YES;
        }
        self.imageView1.frame = frame1;
        
        CGRect frame2 = self.imageView2.frame;
        if (frame2.origin.x < _width - 28) {
            frame2.origin.x += velocity2;
        } else {
            NSLog(@"2222 competition 结束!!!!");
            end2 = YES;
        }
        self.imageView2.frame = frame2;

        CGRect frame3 = self.imageView3.frame;
        if (frame3.origin.x < _width - 28) {
            frame3.origin.x += velocity3;
        } else {
            NSLog(@"3333 competition 结束!!!!");
            end3 = YES;
        }
        self.imageView3.frame = frame3;
        
        
        if (end1 && end2 && end3) {
            NSLog(@"结束!!!!!!!!!!!!!!!");
            [self.timer invalidate];
            _timerCount = 0;
        }
    }
    [UIView commitAnimations];
}


#pragma mark - KVO

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
//    if ([keyPath isEqualToString:WKWebViewTitleKey]) {
//        self.title = self.wkWebView.title;
//    } else if ([keyPath isEqualToString:WKWebViewLoadingKey]) {
//        
//    } else if ([keyPath isEqualToString:WKWebViewProgressKey]) {
//        // 获得进度值
//        CGFloat progress = [change[NSKeyValueChangeNewKey] floatValue];
//        // 显示进度
//        NSLog(@"加载进度：%f", progress);
//        
//        if ([keyPath isEqualToString:WKWebViewProgressKey]) {
//            self.progresslayer.opacity = 1;
//            if ([change[@"new"] floatValue] < [change[@"old"] floatValue]) {
//                return;
//            }
//            self.progresslayer.frame = CGRectMake(0, 0, self.view.bounds.size.width * [change[@"new"] floatValue], 3);
//            if ([change[@"new"] floatValue] == 1) {
//                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(.4 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//                    self.progresslayer.opacity = 0;
//                });
//                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//                    self.progresslayer.frame = CGRectMake(0, 0, 0, 3);
//                });
//            }
//        } else {
//            [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
//        }
//    }
}


#pragma mark - WKNavigationDelegate

/**
 *  每当加载一个请求之前会调用该方法，通过该方法决定是否允许或取消请求的发送
 *
 *  @param navigationAction  导航动作对象
 *  @param decisionHandler   请求处理的决定
 */
- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler {
    // 1. 主机名
    NSString *hostName = navigationAction.request.URL.host.lowercaseString;
    // 2. 获得协议头（http/https, 可以自定义协议头，根据协议头判断是否要执行跳转）
    NSString *scheme = navigationAction.request.URL.scheme;
    
    //    if ([scheme isEqualToString:@"itheima"]) {
    //        // decisionHandler 对请求处理回调
    ////        WKNavigationActionPolicyCancel, // 取消请求
    ////        WKNavigationActionPolicyAllow, // 允许请求
    //
    //        decisionHandler(WKNavigationActionPolicyCancel);
    //        return;
    //    }
    
    
    //    if (navigationAction.targetFrame == nil) {
    //        // 重新加载一个新页面
    //        [webView loadRequest:navigationAction.request];
    //    }
    
    
    //    if (navigationAction.navigationType == WKNavigationTypeLinkActivated && ![hostName containsString:@"192.168.2.140"]) {
    //        // 对于跨域，需要手动跳转
    //        [[UIApplication sharedApplication] openURL:navigationAction.request.URL];
    //        // 不允许web内跳转
    //        decisionHandler(WKNavigationActionPolicyCancel);
    //    } else {
    decisionHandler(WKNavigationActionPolicyAllow);
    //    }
}

/**
 *  当开始发送请求时调用
 */
- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(null_unspecified WKNavigation *)navigation {
    NSLog(@"开始发送请求");
}

/**
 *  当内容开始返回时调用
 */
- (void)webView:(WKWebView *)webView didCommitNavigation:(WKNavigation *)navigation {
    NSLog(@"开始返回内容");
}

/**
 *  当请求过程中出现错误时调用
 */
- (void)webView:(WKWebView *)webView didFailNavigation:(null_unspecified WKNavigation *)navigation withError:(NSError *)error {
    NSLog(@"请求过程中出现错误, %@", error);
}

/**
 *  当开始发送请求时出现错误时调用
 */
- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(null_unspecified WKNavigation *)navigation withError:(NSError *)error {
    NSLog(@"开始发送请求时出现错误, %@", error);
}

/**
 *  当网页加载完毕时调用：该方法使用最频繁
 */
- (void)webView:(WKWebView *)webView didFinishNavigation:(null_unspecified WKNavigation *)navigation {
    // 计算WKWebView高度
    //    [webView evaluateJavaScript:@"document.body.offsetHeight" completionHandler:^(id _Nullable result, NSError * _Nullable error) {
    //        CGRect frame = webView.frame;
    //        frame.size.height = [result doubleValue];
    //        webView.frame = frame;
    //
    //        NSLog(@"(WKWebView *)webView.frame = %@", NSStringFromCGRect(webView.frame));
    //    }];
    
    
    NSLog(@"加载完毕");
    
//    WKBackForwardList *backForwardList = self.wkWebView.backForwardList;
//    NSArray *backList = backForwardList.backList;
//    if (backList.count > 0) {
//        [self.navigationItem setLeftBarButtonItems:@[self.goBackItem, self.closeItem]];
//    } else {
//        [self.navigationItem setLeftBarButtonItems:nil];
//    }
}

/**
 *  每当接收到服务器返回的数据时调用，通过该方法可以决定是否允许或取消导航
 */
- (void)webView:(WKWebView *)webView decidePolicyForNavigationResponse:(WKNavigationResponse *)navigationResponse decisionHandler:(void (^)(WKNavigationResponsePolicy))decisionHandler {
    decisionHandler(WKNavigationResponsePolicyAllow);
}

/**
 *  当收到服务器返回的受保护空间（证书）时调用
 *
 *  @param challenge  安全质询-->包含受保护空间和证书
 *  @param completionHandler   完成回调-->告诉服务器如何处置证书
 */
- (void)webView:(WKWebView *)webView didReceiveAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge completionHandler:(void (^)(NSURLSessionAuthChallengeDisposition disposition, NSURLCredential *__nullable credential))completionHandler {
    // 创建凭据对象
    NSURLCredential *credential = [NSURLCredential credentialForTrust:challenge.protectionSpace.serverTrust];
    // 告诉服务器信任证书
    completionHandler(NSURLSessionAuthChallengeUseCredential, credential);
}


#pragma mark - WKUIDelegate

// alert 警告框
- (void)webView:(WKWebView *)webView runJavaScriptAlertPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(void))completionHandler {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"警告" message:@"调用alert提示框" preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        completionHandler();
    }]];
    [self.parentViewController presentViewController:alert animated:YES completion:nil];
    
    NSLog(@"alert message:%@",message);
}

// confirm 确认框
- (void)webView:(WKWebView *)webView runJavaScriptConfirmPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(BOOL))completionHandler {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"确认框" message:@"调用confirm提示框" preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        completionHandler(YES);
    }]];
    [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        completionHandler(NO);
    }]];
    [self.parentViewController presentViewController:alert animated:YES completion:NULL];
    
    NSLog(@"confirm message:%@", message);
}

- (void)webView:(WKWebView *)webView runJavaScriptTextInputPanelWithPrompt:(NSString *)prompt defaultText:(nullable NSString *)defaultText initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(NSString * __nullable result))completionHandler {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"输入框" message:@"调用输入框" preferredStyle:UIAlertControllerStyleAlert];
    [alert addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.textColor = [UIColor blackColor];
    }];
    [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        completionHandler([[alert.textFields lastObject] text]);
    }]];
    
    [self.parentViewController presentViewController:alert animated:YES completion:NULL];
}


#pragma mark - WKScriptMessageHandler

- (void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message {
    // 这里可以通过name处理多组交互
    if ([message.name isEqualToString:@"senderModel"]) {
        // body只支持NSNumber, NSString, NSDate, NSArray,NSDictionary 和 NSNull类型
        NSLog(@"%@", message.body);
    }
}


#pragma mark - Getters

- (UIView *)blankView {
    if (!_blankView) {
        CGFloat h = HEIGHT - CONTENTVIEW_H;
        _blankView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, _width, h)];
        _blankView.backgroundColor = [UIColor clearColor];
        
        // 添加点击手势
        UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismiss)];
        [_blankView addGestureRecognizer:tapGestureRecognizer];
    }
    return _blankView;
}

- (UIView *)contentView {
    if (!_contentView) {
        _contentView = [[UIView alloc] initWithFrame:CGRectMake(0, HEIGHT, _width, CONTENTVIEW_H)];
//        _contentView.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.85];
        _contentView.backgroundColor = [UIColor whiteColor];
    }
    return _contentView;
}

- (WKWebView *)wkWebView {
    if (!_wkWebView) {
        // 1. 创建网页配置
        WKWebViewConfiguration *config = [[WKWebViewConfiguration alloc] init];
        // 1.1 创建设置
        WKPreferences *preference = [[WKPreferences alloc] init];
        //        preference.minimumFontSize = 10; // 设置字体大小（最小的字体大小）
        preference.javaScriptEnabled = YES; // 是否支持JavaScript
        preference.javaScriptCanOpenWindowsAutomatically = NO; // 不通过用户交互，是否可以打开窗口
        // 1.2 通过JS与webView内容交互
        WKUserContentController *userContentController = [[WKUserContentController alloc] init];
        [userContentController addScriptMessageHandler:self name:@"senderModel"];
        // 1.3 添加设置
        config.preferences = preference;
        config.userContentController = userContentController;
        
        // 2. 创建WKWebView
        _wkWebView = [[WKWebView alloc] initWithFrame:CGRectMake(0, 0, _width, CONTENTVIEW_H - 26) configuration:config];
        _wkWebView.navigationDelegate = self;
        _wkWebView.UIDelegate = self;
        _wkWebView.allowsBackForwardNavigationGestures = YES;
        
        // 3. 添加KVO监听
//        [_wkWebView addObserver:self forKeyPath:WKWebViewLoadingKey options:NSKeyValueObservingOptionNew context:nil];
//        [_wkWebView addObserver:self forKeyPath:WKWebViewTitleKey options:NSKeyValueObservingOptionNew context:nil];
//        [_wkWebView addObserver:self forKeyPath:WKWebViewProgressKey options:NSKeyValueObservingOptionNew context:nil];
    }
    return _wkWebView;
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)test {
    ShareModel *model11 = [[ShareModel alloc] init];
    model11.name = @"C1";
    ShareModel *model12 = [[ShareModel alloc] init];
    model12.name = @"D2";
    NSMutableArray *friendArr = [NSMutableArray arrayWithObjects:model11, model12, nil];
    
    NSMutableArray *nameArr = [NSMutableArray array];
    for (int i = 0; i < friendArr.count; i++) {
        ShareModel *model = friendArr[i];
        [nameArr addObject:model.name];
    }
    
    
    ShareModel * model1 = [[ShareModel alloc] init];
    model1.name = @"C1";
    ShareModel * model2 = [[ShareModel alloc] init];
    model2.name = @"C2";
    ShareModel * model3 = [[ShareModel alloc] init];
    model3.name = @"C3";
    ShareModel * model4 = [[ShareModel alloc] init];
    model4.name = @"D1";
    ShareModel * model5 = [[ShareModel alloc] init];
    model5.name = @"D2";
    ShareModel * model6 = [[ShareModel alloc] init];
    model6.name = @"D3";
    
    NSMutableArray *array = [NSMutableArray array];
    
    NSArray *arr1 = @[@[model1, model2, model3], @[model4, model5, model6]];
    
    for (int i = 0; i < arr1.count; i++) {
        NSMutableArray *tempArr = [NSMutableArray array];
        
        NSArray *arr2 = arr1[i];
        for (int j = 0; j < arr2.count; j++) {
            ShareModel *model = arr2[j];
            NSString *name = model.name;
            NSLog(@"name = %@", name);
            
            if ([nameArr containsObject:name]) {
                [tempArr addObject:model];
            }
        }
        [array addObject:tempArr];
    }
    
    NSLog(@"%@", array);
}

@end
