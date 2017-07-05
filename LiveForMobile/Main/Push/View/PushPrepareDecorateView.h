//
//  PushPrepareDecorateView.h
//  LiveForMobile
//
//  Created by  Sierra on 2017/07/04.
//  Copyright © 2017年 BaiFuTak. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BWPushDecorateView.h"

@class PushPrepareDecorateView;

@protocol PushPrepareDecorateViewDelegate <NSObject>

// 关闭直播设置页面
- (void)pushPrepareDecorateView:(PushPrepareDecorateView *)view dismissViewController:(UIViewController *)parentViewController;

// 切换前后摄像头
- (void)pushPrepareDecorateView:(PushPrepareDecorateView *)view cameraSwitch:(UIButton *)sender;

// 开始直播
- (void)pushPrepareDecorateView:(PushPrepareDecorateView *)view startPush:(NSString *)title;

// 美颜工具滑杆事件
- (void)pushPrepareDecorateView:(PushPrepareDecorateView *)view sliderValueChange:(UISlider *)sender;

// 选择了滤镜类型和滤镜文件名称
- (void)pushPrepareDecorateView:(PushPrepareDecorateView *)view selectedFilter:(BWLiveFilterType)filterType fileName:(NSString *)fileName;

@end


/**
 *  直播设置页面UI view
 */
@interface PushPrepareDecorateView : UIView

@property (nonatomic, weak) id<PushPrepareDecorateViewDelegate>delegate;

/** view所在的控制器 */
@property (nonatomic, strong) UIViewController *parentViewController;

@end
