//
//  BWTabBarController.m
//  LiveForMobile
//
//  Created by  Sierra on 2017/6/20.
//  Copyright © 2017年 BaiFuTak. All rights reserved.
//

#import "BWTabBarController.h"
#import "BWMacro.h"
#import "BWTabBar.h"
#import "BaseNavigationController.h"
#import "BaseViewController.h"
#import "HomeViewController.h"
#import "FollowViewController.h"
#import "MineViewController.h"
#import "HotViewController.h"
#import "PushPrepareView.h"
#import "BWPushViewController.h"

@interface BWTabBarController () <BWTabBarDelegate>

@property (nonatomic, strong) BWTabBar *customTabBar;

@end

@implementation BWTabBarController

#pragma mark - Getters

- (BWTabBar *)customTabBar {
    if (!_customTabBar) {
        _customTabBar = [[BWTabBar alloc] init];
        _customTabBar.frame = self.tabBar.bounds;
        _customTabBar.delegate = self;
    }
    return _customTabBar;
}


#pragma mark - Setters

/**
 设置BWTabBar中选中按钮的index
 
 @param selectedButtonIndex 选中按钮的index
 */
- (void)setSelectedButtonIndex:(NSUInteger)selectedButtonIndex {
    _selectedButtonIndex = selectedButtonIndex;
    
    self.customTabBar.selectedButtonIndex = selectedButtonIndex;
}


#pragma mark - Life cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.tabBar addSubview:self.customTabBar];
    
    // 1. 创建导航控制器  
    HomeViewController *homeVC = [[HomeViewController alloc] initWithViewControllerClasses:@[[HotViewController class], [BaseViewController class], [BaseViewController class]] andTheirTitles:@[@"热门", @"附近", @"频道"]];
    homeVC.menuHeight = 44;
    homeVC.menuViewStyle = WMMenuViewStyleLine;
    homeVC.titleSizeNormal = 15;
    homeVC.titleSizeSelected = 15;
    homeVC.showOnNavigationBar = YES;
    homeVC.menuBGColor = [UIColor clearColor];
    homeVC.menuViewLayoutMode = WMMenuViewLayoutModeCenter;
//    homeVC.progressWidth = 40;
//    homeVC.progressViewIsNaughty = YES;
    
    BaseNavigationController *homeNav = [self createNavigationControllerWithViewController:homeVC title:@"广场" imageName:@"home_5s_320"  selectedImageName:@"home_selected_5s_320"];
    
    FollowViewController *followVC = [[FollowViewController alloc] init];
    BaseNavigationController *followNav = [self createNavigationControllerWithViewController:followVC title:@"关注" imageName:@"appointment_5s_320"  selectedImageName:@"appointment_selected_5s_320"];
    
    BaseViewController *queryVC = [[BaseViewController alloc] init];
    BaseNavigationController *queryNav = [self createNavigationControllerWithViewController:queryVC title:@"私信" imageName:@"query_5s_320"  selectedImageName:@"query_selected_5s_320"];
    
    MineViewController *mineVC = [[MineViewController alloc] init];
    BaseNavigationController *mineNav = [self createNavigationControllerWithViewController:mineVC title:@"我的" imageName:@"mine_5s_320"  selectedImageName:@"mine_selected_5s_320"];
    
    // 2. 添加导航控制器
    self.viewControllers = @[homeNav, followNav, queryNav, mineNav];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    // 删除系统自动生成的UITabBarButton
    for (UIView *child in self.tabBar.subviews) {
        if ([child isKindOfClass:[UIControl class]]) {
            [child removeFromSuperview];
        }
    }
}


/**
 *  初始化一个导航控制器
 *
 *  @param viewController    需要初始化的导航子控制器
 */
- (BaseNavigationController *)createNavigationControllerWithViewController:(UIViewController *)viewController title:(NSString *)title imageName:(NSString *)imageName selectedImageName:(NSString *)selectedImageName {
    // 1. 包装一个导航控制器
    BaseNavigationController *nav = [[BaseNavigationController alloc] initWithRootViewController:viewController];
    
    // 2. 设置控制器的属性
    // navigationBar设置
    nav.navigationBar.translucent = NO;
    nav.navigationBar.tintColor = [UIColor whiteColor];
    nav.navigationBar.barTintColor = [UIColor whiteColor];
    [nav.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor blackColor]}];
    
    // tabBarItem设置
    nav.tabBarItem.title = title;
    [nav.tabBarItem setTitleTextAttributes:@{NSFontAttributeName: [UIFont systemFontOfSize:14], NSForegroundColorAttributeName : [UIColor whiteColor]} forState:UIControlStateNormal]; // 设置文字字体和颜色
    [nav.tabBarItem setTitleTextAttributes:@{NSFontAttributeName: [UIFont systemFontOfSize:14], NSForegroundColorAttributeName : [UIColor whiteColor]} forState:UIControlStateSelected]; // 设置选中的文字字体和颜色
    nav.tabBarItem.image = [[UIImage imageNamed:imageName] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]; // 设置图标
    nav.tabBarItem.selectedImage = [[UIImage imageNamed:selectedImageName] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]; // 设置选中的图标
    
    // 3. 添加tabbar内部的按钮
    [self.customTabBar addTabBarButtonWithItem:nav.tabBarItem];
    
    return nav;
}


#pragma mark - BWTabBarDelegate

/**
 *  监听tabbar按钮的改变
 *  @param from   原来选中的位置
 *  @param to     最新选中的位置
 */
- (void)tabBar:(BWTabBar *)tabBar didSelectedButtonFrom:(NSInteger)from to:(NSInteger)to {
    self.selectedIndex = to;
    self.selectedButtonIndex = to;
    
    if (to == 0) {
        NSLog(@"BWTabBar 点击了: 广场");
    } else if (to == 1) {
        NSLog(@"BWTabBar 点击了: 关注");
    } else if (to == 2) {
        NSLog(@"BWTabBar 点击了: 私信");
    } else if (to == 3) {
        NSLog(@"BWTabBar 点击了: 我的");
    }
}

- (void)tabBarDidSelectedMiddleButton:(BWTabBar *)tabBar {
//    UIViewController *selectedVC = self.selectedViewController;
//    if (![selectedVC isKindOfClass:[UINavigationController class]]) {
//        return;
//    }
//    UINavigationController *nav = (UINavigationController *)selectedVC;
//    
//    PushPrepareView *pushPrepareView = [[PushPrepareView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, HEIGHT)];
//    pushPrepareView.pushBlock = ^{
//        BWPushViewController *pushVC = [[BWPushViewController alloc] init];
//        pushVC.hidesBottomBarWhenPushed = YES;
//        [nav pushViewController:pushVC animated:YES];
//    };
//    pushPrepareView.recordVideoBlock = ^{
//        NSLog(@"小视频");
//    };
//    [self.view addSubview:pushPrepareView];
    
    
    BWPushViewController *pushVC = [[BWPushViewController alloc] init];
    [self presentViewController:pushVC animated:YES completion:nil];
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
