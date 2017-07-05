//
//  BWPushDecorateView.h
//  LiveForMobile
//
//  Created by  Sierra on 2017/6/21.
//  Copyright © 2017年 BaiFuTak. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TXRTMPSDK/TXLivePush.h"

// 滤镜类型
typedef NS_ENUM(NSInteger, BWLiveFilterType) {
    FilterType_none      = 0,
    FilterType_white        , // 美白滤镜
    FilterType_langman 		, // 浪漫滤镜
    FilterType_qingxin 		, // 清新滤镜
    FilterType_weimei 		, // 唯美滤镜
    FilterType_fennen 		, // 粉嫩滤镜
    FilterType_huaijiu 		, // 怀旧滤镜
    FilterType_landiao 		, // 蓝调滤镜
    FilterType_qingliang 	, // 清凉滤镜
    FilterType_rixi 		, // 日系滤镜
};


@protocol BWPushDecorateDelegate <NSObject>

// 结束直播
- (void)closeRTMP;

// 退出直播页面
- (void)closePushViewController;

// 手动聚焦
- (void)clickScreen:(UITapGestureRecognizer *)gestureRecognizer;

// 打开或关闭照明灯
- (void)clickTorch:(UIButton *)button;

// 切换前后摄像头
- (void)clickCameraSwitch:(UIButton *)button;

// 美颜工具滑杆事件
- (void)sliderValueChange:(UISlider *)sender;

// 选择了滤镜类型和滤镜文件名称
- (void)selectedFilter:(BWLiveFilterType)filterType fileName:(NSString *)fileName;

// 选择背景音乐
- (void)selectBGM:(UIButton *)button;

// 关闭背景音乐
- (void)closeBGM:(UIButton *)button;

// 选择音效类型
- (void)selectAudioEffect:(TXReverbType)effectType;

@end


/**
 *  推流模块逻辑view，里面展示了消息列表，弹幕动画，观众列表，美颜，美白等UI，其中与SDK的逻辑交互需要交给主控制器处理。
 */
@interface BWPushDecorateView : UIView

@property (nonatomic, weak) id<BWPushDecorateDelegate>delegate;

/** view所在的控制器 */
@property (nonatomic, strong) UIViewController *parentViewController;

/** 照明灯开关按钮 */
@property (nonatomic, strong) UIButton *torchButton;

/** 大眼参数值 */
@property (nonatomic, assign) float bigEyeLevel;
/** 瘦脸参数值 */
@property (nonatomic, assign) float slimFaceLevel;
/** 美颜参数值 */
@property (nonatomic, assign) float beautyLevel;
/** 美白参数值 */
@property (nonatomic, assign) float whiteningLevel;

/** 滤镜类型 */
@property (nonatomic, assign) BWLiveFilterType filterType;

@end
