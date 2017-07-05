//
//  PlayUGCDecorateView.h
//  LiveForMobile
//
//  Created by  Sierra on 2017/6/29.
//  Copyright © 2017年 BaiFuTak. All rights reserved.
//

#import <UIKit/UIKit.h>

@class PlayUGCDecorateView;

@protocol PlayUGCDecorateViewDelegate <NSObject>

// 关闭录制界面
- (void)closePlayUGCDecorateView;

// 开始录制短视频
- (void)recordVideoStart;

// 结束录制短视频
- (void)recordVideoEnd;

// 重新录制短视频
- (void)recordVideoReset;

// 截屏
- (void)playUGCDecorateViewSnapshot:(PlayUGCDecorateView *)view;

@end


/**
 观众端短视频录制
 */
@interface PlayUGCDecorateView : UIView

@property (nonatomic, weak) id<PlayUGCDecorateViewDelegate>delegate;

/** 录制进度 */
@property (nonatomic, assign) CGFloat recordDuration;


/**
 显示在view上
 */
- (void)showToView:(UIView *)view;

/**
 移除view
 */
- (void)dismiss;

@end
