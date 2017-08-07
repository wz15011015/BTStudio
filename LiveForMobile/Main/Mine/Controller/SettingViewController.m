//
//  SettingViewController.m
//  LiveForMobile
//
//  Created by  Sierra on 2017/7/17.
//  Copyright © 2017年 BaiFuTak. All rights reserved.
//

#import "SettingViewController.h"
#import "SettingCell.h"
#import "BWTabBarController.h"
#import "DNAppAboutViewController.h"

@interface SettingViewController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray *dataArr1;
@property (nonatomic, strong) NSArray *dataArr2;
@property (nonatomic, strong) NSArray *dataArr3;

@end

@implementation SettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"设置";
    
    [self addLeftBarButtonItem];
    
    [self.view addSubview:self.tableView];
}


#pragma mark - Getters

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, HEIGHT - 64) style:UITableViewStyleGrouped];
        _tableView.backgroundColor = RGB(241, 241, 241);
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        [_tableView registerClass:[SettingCell class] forCellReuseIdentifier:SettingCellID];
    }
    return _tableView;
}

- (NSArray *)dataArr1 {
    if (!_dataArr1) {
        _dataArr1 = @[@"账号与安全"];
    }
    return _dataArr1;
}

- (NSArray *)dataArr2 {
    if (!_dataArr2) {
        _dataArr2 = @[@"截图自动保存", @"清理缓存", @"关于大牛直播"];
    }
    return _dataArr2;
}

- (NSArray *)dataArr3 {
    if (!_dataArr3) {
        _dataArr3 = @[@"退出登录"];
    }
    return _dataArr3;
}


#pragma mark - UITableViewDelegate & UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return self.dataArr1.count;
    } else if (section == 1) {
        return self.dataArr2.count;
    } else {
        return self.dataArr3.count;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return 42 * HEIGHT_SCALE;
    } else if (section == 1) {
        return 42 * HEIGHT_SCALE;
    } else {
        return 9 * HEIGHT_SCALE;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if (section == 0) {
        return 0.01;
    } else if (section == 1) {
        return 0.01;
    } else {
        return 0.01;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UILabel *label = [[UILabel alloc] init];
    label.backgroundColor = RGB(241, 241, 241);
    label.textColor = RGB(76, 76, 76);
    label.font = [UIFont systemFontOfSize:13];
    if (section == 0) {
        label.text = @"    账户";
    } else if (section == 1) {
        label.text = @"    设置";
    } else {
        label.text = @" ";
    }
    return label;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return SETTING_CELL_H;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    SettingCell *cell = [tableView dequeueReusableCellWithIdentifier:SettingCellID forIndexPath:indexPath];
    cell.indexPath = indexPath;
    if (indexPath.section == 0) {
        cell.title = self.dataArr1[indexPath.row];
        if (indexPath.row == (self.dataArr1.count - 1)) {
            cell.hideSeparator = YES;
        } else {
            cell.hideSeparator = NO;
        }
    } else if (indexPath.section == 1) {
        cell.title = self.dataArr2[indexPath.row];
        if (indexPath.row == (self.dataArr2.count - 1)) {
            cell.hideSeparator = YES;
        } else {
            cell.hideSeparator = NO;
        }
    } else { 
        cell.title = self.dataArr3[indexPath.row];
        if (indexPath.row == (self.dataArr3.count - 1)) {
            cell.hideSeparator = YES;
        } else {
            cell.hideSeparator = NO;
        }
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.section == 2) {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"记得回来看我哦～" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
        [alert addAction:[UIAlertAction actionWithTitle:@"退出" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
            
            BWTabBarController *tabBarController = (BWTabBarController *)self.tabBarController;
            tabBarController.selectedButtonIndex = 0;
            
            [self.navigationController popViewControllerAnimated:NO];
        }]];
        [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
        [self presentViewController:alert animated:YES completion:nil];
    } else if (indexPath.section == 1) {
        if (indexPath.row == 2) {
            DNAppAboutViewController *aboutVC = [[DNAppAboutViewController alloc] init];
            [self.navigationController pushViewController:aboutVC animated:YES];
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
