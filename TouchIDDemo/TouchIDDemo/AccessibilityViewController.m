//
//  AccessibilityViewController.m
//  TouchIDDemo
//
//  Created by WangZhi on 16/6/18.
//  Copyright © 2016年 WangZhi. All rights reserved.
//

#import "AccessibilityViewController.h"
#import "CoolNavi.h"

static CGFloat const kWindowHeight = 205.0f;

@interface AccessibilityViewController () <UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSDictionary *titleDictionary;

@property (nonatomic, strong) CoolNavi *headerView;
@end

@implementation AccessibilityViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.interactivePopGestureRecognizer.enabled = NO; // 禁止本页面侧滑返回上一级的功能
    self.navigationController.navigationBarHidden = YES;
    
    [self.view addSubview:self.tableView];
    
    // 炫酷的NavigationBar动画的使用
    self.headerView = [[CoolNavi alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.frame), kWindowHeight)backGroudImage:@"background" headerImageURL:nil title:@"妹子!" subTitle:@"个性签名, 啦啦啦!"];
    self.headerView.scrollView = self.tableView;
    __weak typeof(self)ws = self;
    self.headerView.imgActionBlock = ^(){
        NSLog(@"headerImageAction");
    };
    self.headerView.backActionBlock = ^(){
        [ws.navigationController popViewControllerAnimated:YES];
    };
    [self.view addSubview:self.headerView]; 
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    self.navigationController.interactivePopGestureRecognizer.enabled = YES; // 打开导航控制器侧滑返回上一级的功能
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent; // 设置状态栏背景为透明色，字体颜色为白色
}

#pragma mark - getter
- (NSDictionary *)titleDictionary {
    if (!_titleDictionary) {
        _titleDictionary = @{@"0" : @[@"字体大小"],
                             @"1" : @[@"流量统计"],
                             @"2" : @[@"2G/3G/4G下自动接收图片"],
                             @"3" : @[@"2G/3G/4G下自动接收魔表动画"],
                             @"4" : @[@"2G/3G/4G下自动接收魔表动"],
                             @"5" : @[@"2G/3G/4G下自动接收魔表"],
                             @"6" : @[@"2G/3G/4G下自动接收魔"],
                             @"7" : @[@"2G/3G/4G下自动接收"],
                             @"8" : @[@"2G/3G/4G下自动接"],
                             @"9" : @[@"2G/3G/4G下自动"],
                             @"10" : @[@"2G/3G/4G下自"],
                             @"11" : @[@"2G/3G/4G下"],
                             @"12" : @[@"2G/3G/4G下自"],
                             @"13" : @[@"2G/3G/4G下自动"],
                             @"14" : @[@"2G/3G/4G下自动接"],
                             @"15" : @[@"2G/3G/4G下自动接收"],
                             @"16" : @[@"2G/3G/4G下自动接收魔"],
                             @"17" : @[@"2G/3G/4G下自动接收魔表"],
                             @"18" : @[@"2G/3G/4G下自动接收魔表动"],
                             @"19" : @[@"2G/3G/4G下自动接收魔表动画"]};
    }
    return _titleDictionary;
}

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame))];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
        
        // 消除cell左侧缺少的15个像素，使分割线撑满整个UITableViewCell的宽度（UITableView和UITableViewCell中都得这样设置）
        if ([_tableView respondsToSelector:@selector(setSeparatorInset:)]) {
            _tableView.separatorInset = UIEdgeInsetsZero;
        }
        if ([_tableView respondsToSelector:@selector(setLayoutMargins:)]) {
            _tableView.layoutMargins = UIEdgeInsetsZero;
        }
        if ([[[UIDevice currentDevice] systemVersion] floatValue] == 8.0) {
            _tableView.preservesSuperviewLayoutMargins = false; // 只有iOS8需要这样
        }
    }
    return _tableView;
}

#pragma mark - UITableView Delegate Datasource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {  
    return self.titleDictionary.allKeys.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellID = @"CellID";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    // 消除cell左侧缺少的15个像素，使分割线撑满整个UITableViewCell的宽度
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        cell.separatorInset = UIEdgeInsetsZero;
    }
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        cell.layoutMargins = UIEdgeInsetsZero;
    }
    if ([[[UIDevice currentDevice] systemVersion] floatValue] == 8.0) {
        cell.preservesSuperviewLayoutMargins = false; // 只有iOS8需要这样
    }
     
    NSArray *arr = [self.titleDictionary valueForKey:[NSString stringWithFormat:@"%d", (int)indexPath.row]];
    NSString *title = arr[0];
    cell.textLabel.text = title;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
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
