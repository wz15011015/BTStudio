//
//  PushPrepareView.m
//  LiveForMobile
//
//  Created by  Sierra on 2017/6/20.
//  Copyright © 2017年 BaiFuTak. All rights reserved.
//

#import "PushPrepareView.h"
#import <QuartzCore/QuartzCore.h>
#import "BWMacro.h"

@interface PushPrepareView ()

@property (nonatomic, strong) UIButton *pushButton; // 直播按钮

@property (nonatomic, strong) UIButton *videoButton; // 小视频按钮

@property (nonatomic, strong) UIButton *closeButton; // 关闭按钮

@end

@implementation PushPrepareView

#pragma mark - Life cycle

- (id)init {
    if (self = [super init]) {
        [self initializeParameters];
        [self addSubViews];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        [self initializeParameters];
        [self addSubViews];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self initializeParameters];
        [self addSubViews];
    }
    return self;
}


#pragma mark - Getters

- (UIButton *)pushButton {
    if (!_pushButton) {
        CGFloat w = 72;
        CGFloat h = 86;
        CGFloat x = (WIDTH / 2) - (w / 2);
        CGFloat y = HEIGHT;
        _pushButton = [[UIButton alloc] initWithFrame:CGRectMake(x, y, w, h)];
        _pushButton.titleLabel.font = [UIFont systemFontOfSize:16];
        [_pushButton setTitle:@"直播" forState:UIControlStateNormal];
        [_pushButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_pushButton setTitleColor:RGB(206, 246, 237) forState:UIControlStateHighlighted];
        [_pushButton setImage:[UIImage imageNamed:@"live_push"] forState:UIControlStateNormal];
        [_pushButton setImage:[UIImage imageNamed:@"live_push_highlighted"] forState:UIControlStateHighlighted];
        [_pushButton addTarget:self action:@selector(pushEvent) forControlEvents:UIControlEventTouchUpInside];
        
        _pushButton.titleEdgeInsets = UIEdgeInsetsMake(33, -59, -33, 0);
        _pushButton.imageEdgeInsets = UIEdgeInsetsMake(-12, 6, 12, 6);
    }
    return _pushButton;
}

- (UIButton *)videoButton {
    if (!_videoButton) {
        CGFloat w = CGRectGetWidth(self.pushButton.frame);
        CGFloat x = CGRectGetMinX(self.pushButton.frame);
        CGFloat y = CGRectGetMinY(self.pushButton.frame);
        _videoButton = [[UIButton alloc] initWithFrame:CGRectMake(x, y, w, CGRectGetHeight(self.pushButton.frame))];
        _videoButton.titleLabel.font = self.pushButton.titleLabel.font;
        [_videoButton setTitle:@"小视频" forState:UIControlStateNormal];
        [_videoButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_videoButton setTitleColor:RGB(196, 222, 255) forState:UIControlStateHighlighted];
        [_videoButton setImage:[UIImage imageNamed:@"video_push"] forState:UIControlStateNormal];
        [_videoButton setImage:[UIImage imageNamed:@"video_push_highlighted"] forState:UIControlStateHighlighted];
        [_videoButton addTarget:self action:@selector(videoEvent) forControlEvents:UIControlEventTouchUpInside];
        
        _videoButton.titleEdgeInsets = self.pushButton.titleEdgeInsets;
        _videoButton.imageEdgeInsets = self.pushButton.imageEdgeInsets;
    }
    return _videoButton;
}

- (UIButton *)closeButton {
    if (!_closeButton) {
        CGFloat h = 65;
        CGFloat y = HEIGHT - h;
        _closeButton = [[UIButton alloc] initWithFrame:CGRectMake(0, y, WIDTH, h)];
        _closeButton.titleLabel.font = [UIFont systemFontOfSize:32];
        [_closeButton setTitle:@"✕" forState:UIControlStateNormal];
        [_closeButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_closeButton setTitleColor:RGB(202, 202, 202) forState:UIControlStateHighlighted];
        [_closeButton addTarget:self action:@selector(dismiss) forControlEvents:UIControlEventTouchUpInside];
    }
    return _closeButton;
}


#pragma mark - Methods

- (void)initializeParameters {
    self.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.58];
    
    // 1. 添加点击手势
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismiss)];
    [self addGestureRecognizer:tapGestureRecognizer];
}

/**
 添加子控件
 */
- (void)addSubViews {
    [self addSubview:self.pushButton];
    [self addSubview:self.videoButton];
//    [self addSubview:self.closeButton];
    
    // 添加动画效果
    [UIView animateWithDuration:0.3 delay:0.0 usingSpringWithDamping:1.0 initialSpringVelocity:5.0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        
        CGFloat bottomMargin = 125 * HEIGHT_SCALE;
        
        CGRect frame1 = self.pushButton.frame;
        CGFloat w = frame1.size.width;
        CGFloat h = frame1.size.height;
        CGFloat x = (WIDTH - (2 * w)) / 3.0;
        CGFloat y = HEIGHT - h - bottomMargin;
        
        frame1.origin.x = x;
        frame1.origin.y = y;
        self.pushButton.frame = frame1;
        
        CGRect frame2 = self.videoButton.frame;
        frame2.origin.x = CGRectGetMaxX(frame1) + x;
        frame2.origin.y = y;
        self.videoButton.frame = frame2;
        
    } completion:^(BOOL finished) {
    }];
}

/**
 移除子控件
 */
- (void)removeSubviews {
    // 动画效果
    [UIView animateWithDuration:0.22 delay:0.0 usingSpringWithDamping:1.0 initialSpringVelocity:5.0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        self.alpha = 0.0;
        
        CGRect frame1 = self.pushButton.frame;
        CGFloat w = frame1.size.width;
        
        frame1.origin.x = (WIDTH / 2) - (w / 2);
        frame1.origin.y = HEIGHT;
        self.pushButton.frame = frame1;
        
        CGRect frame2 = self.videoButton.frame;
        frame2.origin.x = CGRectGetMinX(frame1);
        frame2.origin.y = CGRectGetMinY(frame1);
        self.videoButton.frame = frame2;
        
    } completion:^(BOOL finished) {
        // 1. 移除子控件
        [self.pushButton removeFromSuperview];
        [self.videoButton removeFromSuperview];
//        [self.closeButton removeFromSuperview];
        
        // 2. 移除self
        [self removeFromSuperview];
    }];
}


#pragma mark - Public Methods

/**
 显示在view上
 */
- (void)showToView:(UIView *)view {
    [view addSubview:self];
//    [self showOut:self duration:0.6]; 
    
//    [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionAllowUserInteraction | UIViewAnimationCurveEaseOut | UIViewAnimationOptionBeginFromCurrentState animations:^{
//        self.backgroundColor = [UIColor clearColor];
//        self.alpha = 1;
//    } completion:^(BOOL finished){
//        
//    }];
    
    [self setNeedsDisplay];
}

/**
 移除view
 */
- (void)dismiss {
    [self removeSubviews];
    
//    [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationCurveEaseIn | UIViewAnimationOptionAllowUserInteraction animations:^{
//        self.alpha = 0;
//    } completion:^(BOOL finished) {
//        if (self.alpha == 0) {
//    
//            [self removeSubviews];
//            
//            [self removeFromSuperview];
//    
//            if (self.dismissBlock) {
//                self.dismissBlock();
//            }
//        }
//    }];
}


#pragma mark - Events

// 直播按钮事件
- (void)pushEvent {
    [self dismiss];
    
    if (self.pushBlock) {
        self.pushBlock();
    }
}

// 小视频按钮事件
- (void)videoEvent {
    [self dismiss];
    
    if (self.recordVideoBlock) {
        self.recordVideoBlock();
    }
}


#pragma mark - Tool Methods

- (void)showOut:(UIView *)view duration:(CFTimeInterval)duration {
    NSMutableArray *values = [NSMutableArray array];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.1, 0.1, 1.0)]];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.2, 1.2, 1.0)]];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.9, 0.9, 1.0)]];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.0, 1.0, 1.0)]];
    
    CAKeyframeAnimation *animation = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
    animation.duration = duration;
    //animation.delegate = self;
    animation.removedOnCompletion = YES;
    animation.fillMode = kCAFillModeForwards;
    animation.timingFunction = [CAMediaTimingFunction functionWithName:@"easeInEaseOut"]; // kCAMediaTimingFunctionEaseIn
    animation.values = values;
    [view.layer addAnimation:animation forKey:nil];
}

- (void)popUp:(UIView *)view duration:(CFTimeInterval)duration {
    UIBezierPath *path = [UIBezierPath bezierPath];
    
    CGPoint startPoint = CGPointMake(WIDTH / 2, HEIGHT);
    CGPoint endPoint = view.center;
    [path moveToPoint:startPoint];
    [path addLineToPoint:endPoint];
    [path stroke];
    
    CAKeyframeAnimation *animation = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    animation.duration = duration;
    animation.removedOnCompletion = YES;
    animation.fillMode = kCAFillModeForwards;
    animation.path = path.CGPath;
    [view.layer addAnimation:animation forKey:nil];
}

@end
