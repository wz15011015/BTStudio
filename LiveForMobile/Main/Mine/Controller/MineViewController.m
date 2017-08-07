//
//  MineViewController.m
//  LiveForMobile
//
//  Created by  Sierra on 2017/7/7.
//  Copyright © 2017年 BaiFuTak. All rights reserved.
//

#import "MineViewController.h"
#import "MineCell.h"
#import "DNAvatarViewController.h"
#import "WatchHistoryViewController.h"
#import "SettingViewController.h"
#import "MineHeaderView.h"

@interface MineViewController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *group1Arr;
@property (nonatomic, strong) NSMutableArray *group2Arr;
@property (nonatomic, strong) NSMutableArray *group3Arr;
@property (nonatomic, strong) NSMutableArray *dataArr;

@property (nonatomic, strong) MineHeaderView *headerView;

@end

@implementation MineViewController

#pragma mark - Getters

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, HEIGHT - 49 - 64) style:UITableViewStyleGrouped];
        _tableView.backgroundColor = RGB(241, 241, 241); 
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        [_tableView registerClass:[MineCell class] forCellReuseIdentifier:MineCellID];
    }
    return _tableView;
}

- (NSMutableArray *)group1Arr {
    if (!_group1Arr) {
        _group1Arr = [NSMutableArray arrayWithObjects:@"粉丝贡献", @"我看过的", @"我的MV", @"用户等级", nil];
    }
    return _group1Arr;
}

- (NSMutableArray *)group2Arr {
    if (!_group2Arr) {
        _group2Arr = [NSMutableArray arrayWithObjects:@"账户", @"主播等级", @"主播相关", nil];
    }
    return _group2Arr;
}

- (NSMutableArray *)group3Arr {
    if (!_group3Arr) {
        _group3Arr = [NSMutableArray arrayWithObjects:@"帮助与反馈", @"设置", nil];
    }
    return _group3Arr;
}

- (NSMutableArray *)dataArr {
    if (!_dataArr) {
        _dataArr = [NSMutableArray array];
    }
    return _dataArr;
}

- (MineHeaderView *)headerView {
    if (!_headerView) {
        _headerView = [[MineHeaderView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, MINE_HEADER_VIEW_H)];
    }
    return _headerView;
}


#pragma mark - Life Cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"我的";
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.view.backgroundColor = RGB(241, 241, 241);
    
    // 1. 初始化参数
    
    // 2. 添加控件
    [self.view addSubview:self.tableView];
    self.tableView.tableHeaderView = self.headerView;
    
    // 3. Block回调
    BRIAN_WEAK_SELF
    self.headerView.buttonEventBlock = ^(NSInteger tag) {
        if (tag == 10) {
            NSLog(@"查看我的主页");
        } else if (tag == 11) {
            DNAvatarViewController *avatarVC = [[DNAvatarViewController alloc] init];
            avatarVC.avatarImage = [UIImage imageNamed:@"avatar_default"];
            [weakSelf presentViewController:avatarVC animated:YES completion:nil];
        } else if (tag == 12) {
            NSLog(@"点击了 动态 按钮");
        } else if (tag == 13) {
            NSLog(@"点击了 关注 按钮");
        } else if (tag == 14) {
            NSLog(@"点击了 粉丝 按钮");
        }
    };
}


#pragma mark - UITableViewDelegate & DataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return self.group1Arr.count;
    } else if (section == 1) {
        return self.group2Arr.count;
    } else {
        return self.group3Arr.count;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return MINE_CELL_H;
    } else if (indexPath.section == 1) {
        return MINE_CELL_H;
    } else {
        return MINE_CELL_H;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return 10;
    } else if (section == 1) {
        return 10;
    } else {
        return 10;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if (section == 0) {
        return 0.001;
    } else if (section == 1) {
        return 0.001;
    } else {
        return 0.001;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *view = [[UIView alloc] init];
    view.backgroundColor = tableView.backgroundColor;
    return view;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MineCell *cell = [tableView dequeueReusableCellWithIdentifier:MineCellID forIndexPath:indexPath];
    if (indexPath.section == 0) {
        cell.title = self.group1Arr[indexPath.row];
        if (indexPath.row == (self.group1Arr.count - 1)) {
            cell.hideSeparator = YES;
        } else {
            cell.hideSeparator = NO;
        }
    } else if (indexPath.section == 1) {
        cell.title = self.group2Arr[indexPath.row];
        if (indexPath.row == (self.group2Arr.count - 1)) {
            cell.hideSeparator = YES;
        } else {
            cell.hideSeparator = NO;
        }
    } else {
        cell.title = self.group3Arr[indexPath.row];
        if (indexPath.row == (self.group3Arr.count - 1)) {
            cell.hideSeparator = YES;
        } else {
            cell.hideSeparator = NO;
        }
    }
    
    
//    NSString *model = self.dataArr[indexPath.row];
//    cell.model = model;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.section == 0) {
        if (indexPath.row == 1) {
            WatchHistoryViewController *watchedVC = [[WatchHistoryViewController alloc] init];
            watchedVC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:watchedVC animated:YES];
        }
    } else if (indexPath.section == 2) {
        if (indexPath.row == 0) {
            
        } else if (indexPath.row == 1) {
            SettingViewController *settingVC = [[SettingViewController alloc] init];
            settingVC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:settingVC animated:YES];
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
