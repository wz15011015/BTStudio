//
//  BaseNavigationViewController.m
//  TouchIDDemo
//
//  Created by WangZhi on 16/6/16.
//  Copyright © 2016年 WangZhi. All rights reserved.
//

#import "BaseNavigationViewController.h"

@interface BaseNavigationViewController ()

@end

@implementation BaseNavigationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
//    [self customNavigationBar];
}

/** 自定义导航栏属性 */
- (void)customNavigationBar {
    // 设置导航条背景图片
    UINavigationBar *navBar = self.navigationBar;
    [navBar setBackgroundImage:[UIImage imageNamed:@"导航栏背景图片"] forBarMetrics:UIBarMetricsDefault];
    
    // 字体颜色和字体大小
    [navBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor colorWithRed:74 / 255.0 green:74 / 255.0 blue:74 / 255.0 alpha:1.0], NSFontAttributeName:[UIFont systemFontOfSize:19]}]; 
}

//- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated {
//    /* 自定义返回按钮 **/
//    // 1. 按钮
//    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//    [backBtn setTitleColor:[UIColor colorWithRed:74 / 255.0 green:74 / 255.0 blue:74 / 255.0 alpha:1.0] forState:UIControlStateNormal];
//    [backBtn setTitle:@" 返回" forState:UIControlStateNormal];
//    [backBtn setImage:[UIImage imageNamed:@"NewBackButton"] forState:UIControlStateNormal];
//    [backBtn sizeToFit];
//    [backBtn addTarget:self action:@selector(popViewController:) forControlEvents:UIControlEventTouchUpInside];
//    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithCustomView:backBtn];
//    
//    // 2.
//    UIBarButtonItem *nagetiveSpacer = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
//    nagetiveSpacer.width = -6;
//    
//    // 3.
//    viewController.navigationItem.leftBarButtonItems = @[nagetiveSpacer, backItem];
//
//    
//    [super pushViewController:viewController animated:YES];
//}
//
//- (void)popViewController:(UIButton *)sender {
//    [self popViewControllerAnimated:YES];
//}

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
