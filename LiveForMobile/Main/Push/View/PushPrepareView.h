//
//  PushPrepareView.h
//  LiveForMobile
//
//  Created by  Sierra on 2017/6/20.
//  Copyright © 2017年 BaiFuTak. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 直播准备 view (放置"直播""小视频"两个按钮)
 */
@interface PushPrepareView : UIView

// 直播回调
@property (nonatomic, copy) void(^pushBlock)(void);

// 录制小视频回调
@property (nonatomic, copy) void(^recordVideoBlock)(void);


/**
 显示在view上
 */
- (void)showToView:(UIView *)view;

/**
 移除view
 */
- (void)dismiss;

@end
