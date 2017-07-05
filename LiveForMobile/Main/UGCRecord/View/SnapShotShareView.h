//
//  SnapShotShareView.h
//  LiveForMobile
//
//  Created by  Sierra on 2017/07/05.
//  Copyright © 2017年 BaiFuTak. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 截屏分享view
 */
@interface SnapShotShareView : UIView

/** view所在的控制器 */
@property (nonatomic, strong) UIViewController *parentViewController;

/** 截图 (UIImage) */
@property (nonatomic, strong) UIImage *snapShotImage;

@property (nonatomic, copy) void(^dismissBlock)(void);


/**
 显示在view上
 */
- (void)showToView:(UIView *)view;

/**
 移除view
 */
- (void)dismiss;

@end
