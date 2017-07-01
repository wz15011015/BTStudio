//
//  BWTabBarButton.m
//  YiHuiWaiBiDuiHuan
//
//  Created by  Sierra on 2017/4/20.
//  Copyright © 2017年 YIHUALONG Inc. All rights reserved.
//

#import "BWTabBarButton.h"
#import "BWBadgeButton.h"

// 按钮的默认文字颜色
#define BWTabBarButtonTitleColor [UIColor colorWithRed:38 / 255.0 green:38 / 255.0 blue:38 / 255.0 alpha:1.0]
// 按钮的选中文字颜色
#define BWTabBarButtonTitleSelectedColor [UIColor colorWithRed:6 / 255.0 green:139 / 255.0 blue:243 / 255.0 alpha:1.0]

const CGFloat BWTabBarButtonImageRatio = 0.7;


@interface BWTabBarButton ()

@property (nonatomic, strong) BWBadgeButton *badgeButton; // 红点提醒数字

@end

@implementation BWTabBarButton

#pragma mark - Life cycle

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        // 图片居中
        self.imageView.contentMode = UIViewContentModeCenter;
        
        // 文字居中
        self.titleLabel.textAlignment = NSTextAlignmentCenter;
        
        // 文字大小及颜色
        self.titleLabel.font = [UIFont systemFontOfSize:11.0];
        [self setTitleColor:BWTabBarButtonTitleColor forState:UIControlStateNormal];
        [self setTitleColor:BWTabBarButtonTitleSelectedColor forState:UIControlStateSelected];
        
        // 添加一个提醒数字按钮
        [self addSubview:self.badgeButton];
    }
    return self;
}

- (void)dealloc {
    [self.item removeObserver:self forKeyPath:@"badgeValue"];
    [self.item removeObserver:self forKeyPath:@"title"];
    [self.item removeObserver:self forKeyPath:@"image"];
    [self.item removeObserver:self forKeyPath:@"selectedImage"];
}


#pragma mark - Override

/**
 重写去掉高亮状态

 @param highlighted 是否高亮
 */
- (void)setHighlighted:(BOOL)highlighted {
    
}

/**
 调整内部图片的frame

 @param contentRect 内容的frame
 @return 图片的frame
 */
- (CGRect)imageRectForContentRect:(CGRect)contentRect {
    CGFloat imageW = contentRect.size.width;
    CGFloat imageH = contentRect.size.height * BWTabBarButtonImageRatio;
    return CGRectMake(0, 0, imageW, imageH);
}

/**
 调整内部文字的frame

 @param contentRect 内容的frame
 @return 文字的frame
 */
- (CGRect)titleRectForContentRect:(CGRect)contentRect {
    CGFloat titleY = contentRect.size.height * BWTabBarButtonImageRatio;
    CGFloat titleW = contentRect.size.width;
    CGFloat titleH = contentRect.size.height - titleY;
    return CGRectMake(0, titleY, titleW, titleH);
}


#pragma mark - Getters

- (BWBadgeButton *)badgeButton {
    if (!_badgeButton) {
        _badgeButton = [[BWBadgeButton alloc] init];
        _badgeButton.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleBottomMargin;
    }
    return _badgeButton;
}


#pragma mark - Setters

- (void)setItem:(UITabBarItem *)item {
    _item = item;
    
    // KVO属性监听
    [item addObserver:self forKeyPath:@"badgeValue" options:NSKeyValueObservingOptionNew context:nil];
    [item addObserver:self forKeyPath:@"title" options:NSKeyValueObservingOptionNew context:nil];
    [item addObserver:self forKeyPath:@"image" options:NSKeyValueObservingOptionNew context:nil];
    [item addObserver:self forKeyPath:@"selectedImage" options:NSKeyValueObservingOptionNew context:nil];
    
    [self observeValueForKeyPath:nil ofObject:nil change:nil context:nil];
}


#pragma mark - KVO

/**
 *  监听到某个对象的属性改变了,就会调用
 *
 *  @param keyPath 属性名
 *  @param object  哪个对象的属性被改变
 *  @param change  属性发生的改变
 */
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    // 1. 设置文字
    [self setTitle:self.item.title forState:UIControlStateNormal];
    [self setTitle:self.item.title forState:UIControlStateSelected];
    
    // 2. 设置图片
    [self setImage:self.item.image forState:UIControlStateNormal];
    [self setImage:self.item.selectedImage forState:UIControlStateSelected];
    
    // 3. 设置提醒数字
    self.badgeButton.badgeValue = self.item.badgeValue;
    
    // 3.1 设置提醒数字的位置
    CGFloat badgeY = 5;
    CGFloat badgeX = self.frame.size.width - self.badgeButton.frame.size.width - 10;
    CGRect badgeFrame = self.badgeButton.frame;
    badgeFrame.origin.x = badgeX;
    badgeFrame.origin.y = badgeY;
    self.badgeButton.frame = badgeFrame;
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
