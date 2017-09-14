//
//  NewFeatureViewController.m
//  LiveForMobile
//
//  Created by  Sierra on 2017/9/12.
//  Copyright © 2017年 BaiFuTak. All rights reserved.
//

#import "NewFeatureViewController.h"
#import "RubberBandView.h"

@interface NewFeatureViewController () <UIScrollViewDelegate> {
    CGPoint _startPoint; // 开始触摸的点
    
    NSUInteger _pageCount; // 页数
    
    CGFloat _indicatorW;   // 横线的宽度
    CGFloat _midMargin;    // 三个横线之间的间隔
    CGFloat _indicatorX;   // 第一个横线的x值
}

@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) RubberBandView *pageIndicatorView; // 橡皮筋view
@property (nonatomic, strong) UIButton *closeButton;

@end

@implementation NewFeatureViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = RGB(241, 241, 241);
    
    // 初始化页数
    _pageCount = 3;
    _indicatorW = 36;
    _midMargin = 30;
    _indicatorX = (WIDTH - (_pageCount * _indicatorW) - ((_pageCount - 1) * _midMargin)) / 2.0;
    
    // 添加控件
    [self.view addSubview:self.scrollView];
    [self.view addSubview:self.pageIndicatorView];
    [self.view addSubview:self.closeButton];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    // 隐藏状态栏
    [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationSlide];
    
    // 隐藏导航栏
    self.navigationController.navigationBarHidden = YES;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationSlide];
    self.navigationController.navigationBarHidden = NO;
}


#pragma mark - Getters

- (UIScrollView *)scrollView {
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, HEIGHT)];
        _scrollView.contentSize = CGSizeMake(WIDTH * _pageCount, HEIGHT);
        _scrollView.pagingEnabled = YES;
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.delegate = self;
        [_scrollView.panGestureRecognizer addTarget:self action:@selector(panEvent:)];
        
        for (int i = 0; i < _pageCount; i++) {
            NSString *imageName = [NSString stringWithFormat:@"p5_guide_bg_%d_375x667_", i];
            
            UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(i * WIDTH, 0, WIDTH, HEIGHT)];
            imageView.image = [UIImage imageNamed:imageName];
            imageView.userInteractionEnabled = YES;
            [_scrollView addSubview:imageView];
            
            if (i == _pageCount - 1) {
                CGFloat w = WIDTH * 0.42;
                CGFloat x = (WIDTH - w) / 2;
                CGFloat h = 44;
                CGFloat y = HEIGHT - 50 - h;
                UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
                button.frame = CGRectMake(x, y, w, h);
                button.backgroundColor = RGB(91, 157, 255);
                button.layer.cornerRadius = 5;
                button.layer.masksToBounds = YES;
                [button setTitle:@"进入应用" forState:UIControlStateNormal];
                [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                [button setTitleColor:RGB(62, 114, 215) forState:UIControlStateHighlighted];
                [button addTarget:self action:@selector(closeEvent) forControlEvents:UIControlEventTouchUpInside];
                [imageView addSubview:button];
            }
        }
    }
    return _scrollView;
}

- (RubberBandView *)pageIndicatorView {
    if (!_pageIndicatorView) {
        CGFloat h = 3;
        CGFloat y = HEIGHT - 20 - h;
        // 最大偏移量
        CGFloat maxOffset = _indicatorW + _midMargin;
        
        _pageIndicatorView = [[RubberBandView alloc] initWithFrame:CGRectMake(_indicatorX, y, _indicatorW, h) layerProperty:MakeRBProperty(0, 0, _indicatorW, h, maxOffset)];
        _pageIndicatorView.fillColor = RGB(91, 157, 255);
        _pageIndicatorView.duration = 0.4;
        _pageIndicatorView.startAction = ^{
        }; 
        _pageIndicatorView.stopAction = ^{
//            NSLog(@"橡皮筋收缩完成");
        };
        
        for (int i = 0; i < _pageCount; i++) {
            UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(_indicatorX + i * (_indicatorW + _midMargin), y, _indicatorW, h)];
            imageView.layer.masksToBounds = YES;
            imageView.layer.cornerRadius = h / 2.0;
            imageView.backgroundColor = RGB(248, 248, 248);
            imageView.tag = 10 + i;
            [self.view addSubview:imageView];
        }
    }
    return _pageIndicatorView;
}

- (UIButton *)closeButton {
    if (!_closeButton) {
        CGFloat w = 27;
        CGFloat x = WIDTH - w;
        _closeButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _closeButton.frame = CGRectMake(x, 0, w, 25);
        [_closeButton setImage:[UIImage imageNamed:@"guidepage_close_27x25_"] forState:UIControlStateNormal];
        [_closeButton addTarget:self action:@selector(closeEvent) forControlEvents:UIControlEventTouchUpInside];
    }
    return _closeButton;
}


#pragma mark - Events
// 退出页面
- (void)closeEvent {
    [self.navigationController popViewControllerAnimated:NO];
}

// scrollView的平移手势的事件
- (void)panEvent:(UIPanGestureRecognizer *)gestureRecognizer {
    CGPoint touchPoint = [gestureRecognizer locationInView:self.view];
    
    if (gestureRecognizer.state == UIGestureRecognizerStateBegan) {
        _startPoint = touchPoint;
    } else if (gestureRecognizer.state == UIGestureRecognizerStateChanged) {
//        CGFloat offsetX = touchPoint.x - _startPoint.x;
//        [self.pageIndicatorView pullWithOffSet:-offsetX * 0.5];
        
        // scrollView的偏移量
        CGFloat offsetOfScrollView = self.scrollView.contentOffset.x;
        if (offsetOfScrollView < 0 || offsetOfScrollView > (_pageCount - 1) * WIDTH) {
            return;
        }
        // 触摸手势的偏移量
        CGFloat offsetX = touchPoint.x - _startPoint.x;
        if (offsetX < 0) {
            [self.pageIndicatorView pullWithOffSet:_indicatorW + _midMargin];
        } else {
            [self.pageIndicatorView pullWithOffSet:-(_indicatorW + _midMargin)];
        }
    } else {
        [self.pageIndicatorView recoverStateAnimation];
    }
}


#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    NSInteger index = (NSInteger)(scrollView.contentOffset.x / WIDTH);
    if (index == _pageCount - 1) {
        if (self.pageIndicatorView.hidden == YES) {
            return;
        }
        // 隐藏页面指示view
        self.pageIndicatorView.hidden = YES;
        for (int i = 0; i < _pageCount; i++) {
            UIImageView *lineImageView = (UIImageView *)[self.view viewWithTag:10 + i];
            lineImageView.hidden = YES;
        }
    } else {
        if (self.pageIndicatorView.hidden == NO) {
            return;
        }
        // 显示页面指示view
        self.pageIndicatorView.hidden = NO;
        for (int i = 0; i < _pageCount; i++) {
            UIImageView *lineImageView = (UIImageView *)[self.view viewWithTag:10 + i];
            lineImageView.hidden = NO;
        }
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
