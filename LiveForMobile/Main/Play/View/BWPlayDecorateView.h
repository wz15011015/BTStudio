//
//  BWPlayDecorateView.h
//  LiveForMobile
//
//  Created by  Sierra on 2017/6/26.
//  Copyright © 2017年 BaiFuTak. All rights reserved.
//

#import <UIKit/UIKit.h>

#define MESSAGE_TABLEVIEW_H (120)        // 消息TableView的高度
#define MESSAGE_TABLEVIEW_W (WIDTH - 65) // 消息TableView的宽度


@protocol BWPlayDecorateDelegate <NSObject>

// 退出播放页面
- (void)closePlayViewController;

// 点歌
- (void)clickOrderSong:(UIButton *)sender;

// 私信
- (void)clickPrivateMessage:(UIButton *)sender;

// 礼物
- (void)clickGift:(UIButton *)sender;

// 录制视频
- (void)clickRecord:(UIButton *)sender;

// 分享
- (void)clickShare:(UIButton *)sender;

@end


/**
 *  播放模块逻辑view，里面展示了消息列表，弹幕动画，观众列表等UI，其中与SDK的逻辑交互需要交给主控制器处理
 */
@interface BWPlayDecorateView : UIView

@property (nonatomic, weak) id<BWPlayDecorateDelegate>delegate;

/** view所在的控制器 */
@property (nonatomic, strong) UIViewController *parentViewController;

@end
