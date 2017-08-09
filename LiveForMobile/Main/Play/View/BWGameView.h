//
//  BWGameView.h
//  LiveForMobile
//
//  Created by  Sierra on 2017/8/8.
//  Copyright © 2017年 BaiFuTak. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 播放界面 游戏view
 */
@interface BWGameView : UIView

/** view所在的控制器 */
@property (nonatomic, strong) UIViewController *parentViewController;

/**
 显示在view上
 */
- (void)showToView:(UIView *)view;

/**
 移除view
 */
- (void)dismiss;

@end
