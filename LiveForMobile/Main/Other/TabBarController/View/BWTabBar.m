//
//  BWTabBar.m
//  YiHuiWaiBiDuiHuan
//
//  Created by  Sierra on 2017/4/20.
//  Copyright © 2017年 YIHUALONG Inc. All rights reserved.
//

#import "BWTabBar.h"
#import "BWMacro.h"
#import "BWTabBarButton.h"

@interface BWTabBar ()

@property (nonatomic, strong) NSMutableArray *tabBarButtons;

@property (nonatomic, weak) BWTabBarButton *selectedButton;

@property (nonatomic, strong) UIButton *middleButton; // 中间的按钮

@end

@implementation BWTabBar

#pragma mark - Life cycle

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        
//        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, -15, WIDTH, 64)];
//        imageView.contentMode = UIViewContentModeScaleAspectFill;
//        [imageView setImage:[UIImage imageNamed:@"blur"]];
//        [self addSubview:imageView];
        
        // 添加中间按钮
        [self addSubview:self.middleButton];
    }
    return self;
}


#pragma mark - Getters

- (NSMutableArray *)tabBarButtons {
    if (!_tabBarButtons) {
        _tabBarButtons = [NSMutableArray array];
    }
    return _tabBarButtons;
}

- (UIButton *)middleButton {
    if (!_middleButton) {
        CGFloat w = 50;
        CGFloat h = 50;
        _middleButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _middleButton.frame = CGRectMake(0, 0, w, h);
        [_middleButton setImage:[UIImage imageNamed:@"play_normal"] forState:UIControlStateNormal];
        [_middleButton setImage:[UIImage imageNamed:@"play_highlighted"] forState:UIControlStateHighlighted];
        [_middleButton addTarget:self action:@selector(middleButtonEvent) forControlEvents:UIControlEventTouchUpInside];
    }
    return _middleButton;
}


#pragma mark - Override

- (void)layoutSubviews {
    [super layoutSubviews];
    
    // 1. 调整按钮的位置
    CGFloat h = self.frame.size.height;
    CGFloat w = self.frame.size.width;
    
    // 1.1 调整中间按钮的位置
    self.middleButton.center = CGPointMake(w * 0.5, h * 0.5);
    
    // 1.2 按钮的frame数据
    CGFloat buttonH = h;
    CGFloat buttonW = w / self.subviews.count;
    CGFloat buttonY = 0; 
    
    // 1.3
    for (int index = 0; index < self.tabBarButtons.count; index++) {
        // 1. 取出按钮
        BWTabBarButton *button = self.tabBarButtons[index];
        
        // 2. 设置按钮的frame
        CGFloat buttonX = index * buttonW;
        if (index >= 2) { // 第3和第4个按钮的x值需增加一个buttonW
            buttonX += buttonW;
        }
        button.frame = CGRectMake(buttonX, buttonY, buttonW, buttonH);
        
        // 3. 绑定tag
        button.tag = index;
    }
}


#pragma mark - Public Method

- (void)addTabBarButtonWithItem:(UITabBarItem *)item {
    // 1. 创建按钮
    BWTabBarButton *button = [[BWTabBarButton alloc] init];
    [self addSubview:button];
    // 添加按钮到数组中
    [self.tabBarButtons addObject:button];
    
    // 2. 设置数据
    button.item = item;
    
    // 3. 监听按钮点击
    [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchDown];
    
    // 4. 默认选中第0个按钮
    if (self.tabBarButtons.count == 1) {
        [self buttonClick:button];
    }
}


#pragma mark - Event

/**
 *  监听按钮点击
 */
- (void)buttonClick:(BWTabBarButton *)button {
    _selectedButtonIndex = button.tag;
    
    // 1. 通知代理
    if ([self.delegate respondsToSelector:@selector(tabBar:didSelectedButtonFrom:to:)]) {
        [self.delegate tabBar:self didSelectedButtonFrom:self.selectedButton.tag to:button.tag];
    }
    
    // 2. 设置按钮的状态
    self.selectedButton.selected = NO;
    button.selected = YES;
    self.selectedButton = button;
}

- (void)middleButtonEvent {
    if ([self.delegate respondsToSelector:@selector(tabBarDidSelectedMiddleButton:)]) {
        [self.delegate tabBarDidSelectedMiddleButton:self];
    }
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
