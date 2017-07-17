//
//  BWTabBar.h
//  YiHuiWaiBiDuiHuan
//
//  Created by  Sierra on 2017/4/20.
//  Copyright © 2017年 YIHUALONG Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@class BWTabBar;


@protocol BWTabBarDelegate <NSObject>

@optional
// 点击了tabBar按钮
- (void)tabBar:(BWTabBar *)tabBar didSelectedButtonFrom:(NSInteger)from to:(NSInteger)to;

// 点击了中间按钮
- (void)tabBarDidSelectedMiddleButton:(BWTabBar *)tabBar;

@end


/**
 自定义tabBar, 继承自UIView
 */
@interface BWTabBar : UIView

@property (nonatomic, weak) id<BWTabBarDelegate> delegate;

/**
 选中按钮的index
 */
@property (nonatomic, assign) NSUInteger selectedButtonIndex;

/**
 添加tabBar按钮
 */
- (void)addTabBarButtonWithItem:(UITabBarItem *)item;

@end
