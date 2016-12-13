//
//  BaseViewController.m
//  TouchIDDemo
//
//  Created by WangZhi on 16/6/16.
//  Copyright © 2016年 WangZhi. All rights reserved.
//

#import "BaseViewController.h"

@interface BaseViewController () <UIGestureRecognizerDelegate>
@property (nonatomic, strong) UIButton *backBtn;
@end

@implementation BaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self customNavigationBar];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        if (self.navigationController.viewControllers.count == 2) { // 只有在二级界面生效
            self.navigationController.interactivePopGestureRecognizer.delegate = self;
        }
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    // 代理置空，否则会闪退
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.delegate = nil;
    }
}

/** 自定义导航栏属性 */
- (void)customNavigationBar {
    // 1. 设置导航条背景图片
    UINavigationBar *navBar = self.navigationController.navigationBar;
    // a. 图片
//    [navBar setBackgroundImage:[UIImage imageNamed:@"导航栏背景图片"] forBarMetrics:UIBarMetricsDefault];
    // b. 纯颜色
    [navBar setBackgroundImage:[self imageWithColor:[UIColor colorWithRed:119 / 255.0 green:210 / 255.0 blue:251 / 255.0 alpha:1.0] size:CGSizeMake(1, 1)] forBarMetrics:UIBarMetricsDefault];
    
    // 2. 字体颜色和字体大小
    [navBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor colorWithRed:74 / 255.0 green:74 / 255.0 blue:74 / 255.0 alpha:1.0], NSFontAttributeName:[UIFont systemFontOfSize:19]}];
    
    // 3. 设置导航栏返回按钮
    self.backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.backBtn setTitleColor:[UIColor colorWithRed:74 / 255.0 green:74 / 255.0 blue:74 / 255.0 alpha:1.0] forState:UIControlStateNormal];
    [self.backBtn setTitle:@"  返回" forState:UIControlStateNormal];
    [self.backBtn setImage:[UIImage imageNamed:@"NewBackButton"] forState:UIControlStateNormal];
    [self.backBtn addTarget:self action:@selector(popViewController:) forControlEvents:UIControlEventTouchUpInside];
    [self.backBtn sizeToFit];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.backBtn];
}

/** 返回 */
- (void)popViewController:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (UIImage *)imageWithColor:(UIColor *)color size:(CGSize)size {
    CGRect rect = CGRectMake(0, 0, size.width, size.height);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, color.CGColor);
    CGContextFillRect(context, rect);
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return img;
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
