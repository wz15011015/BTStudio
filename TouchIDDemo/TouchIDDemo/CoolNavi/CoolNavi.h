//
//  CoolNavi.h
//  CoolNaviDemo
//
//  Created by ian on 15/1/19.
//  Copyright (c) 2015年 . All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 *  炫酷的NavigationBar动画 （个人中心页面经常用）
 * 
 *  技术原理:当你下拉scrollView的时候，会监听scrollView的contentOffset来调整头部背景图片的位置(KVO属性监听功能)，通过CGAffineTransformMakeTranslation和CGAffineTransformScale来实现头像的缩小。
 */
@interface CoolNavi : UIView

@property (nonatomic, weak) UIScrollView *scrollView;
// 返回上一级
@property (nonatomic, copy) void(^backActionBlock)(void);
// image action
@property (nonatomic, copy) void(^imgActionBlock)(void);

- (id)initWithFrame:(CGRect)frame backGroudImage:(NSString *)backImageName headerImageURL:(NSString *)headerImageURL title:(NSString *)title subTitle:(NSString *)subTitle;

- (void)updateSubViewsWithScrollOffset:(CGPoint)newOffset;

@end
