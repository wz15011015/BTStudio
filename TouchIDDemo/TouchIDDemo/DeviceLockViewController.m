//
//  DeviceLockViewController.m
//  TouchIDDemo
//
//  Created by WangZhi on 16/6/15.
//  Copyright © 2016年 WangZhi. All rights reserved.
//

#import "DeviceLockViewController.h"
#import "FingerprintSettingViewController.h"

@interface DeviceLockViewController () <UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSDictionary *titleDictionary;
@end

@implementation DeviceLockViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    // 注册通知：当从3D Touch快捷键的“开启Touch ID”键进入应用时，能接收到通知，然后推出“手势、指纹锁定”页面
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(jumpToFingerprint) name:@"3DTouchThree" object:nil];
    
    [self.view addSubview:self.tableView];
}

#pragma mark - getter
- (NSDictionary *)titleDictionary {
    if (!_titleDictionary) {
        _titleDictionary = @{@"0" : @[@"设备锁", @"帐号安全状况"],
                             @"1" : @[@"允许手机、电脑同时在线"],
                             @"2" : @[@"我的iPhone 6s"],
                             @"3" : @[@"手势、指纹锁定", @"修改QQ密码"]};
    }
    return _titleDictionary;
}

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame)) style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.dataSource = self;
    }
    return _tableView;
}

#pragma mark - UITableView Delegate Datasource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.titleDictionary.allKeys.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSArray *arr = [self.titleDictionary valueForKey:[NSString stringWithFormat:@"%d", (int)section]];
    return arr.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 40;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellID = @"CellID";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    
    NSArray *arr = [self.titleDictionary valueForKey:[NSString stringWithFormat:@"%d", (int)indexPath.section]];
    NSString *title = arr[indexPath.row];
    cell.textLabel.text = title;
    
    if (indexPath.section == 0) {
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    } else if (indexPath.section == 1) {
        UISwitch *swithBtn = [[UISwitch alloc] init];
        [swithBtn addTarget:self action:@selector(switchValueChanged:) forControlEvents:UIControlEventValueChanged];
        swithBtn.tag = 10;
        cell.accessoryView = swithBtn;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    } else if (indexPath.section == 3) {
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    } else {
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return 18.0;
    } else if (section == 1) {
        return 18.0;
    } else if (section == 2) {
        return 38.0;
    } else {
        return 10.0;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if (section == 0) {
        return 0.01;
    } else if (section == 1) {
        return 0.01;
    } else if (section == 2) {
        return 30.0;
    } else {
        return 0.01;
    }
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if (section == 2) {
        return @"当前在线";
    }
    return nil;
}

- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section {
    if (section == 2) {
        return @"最近登录记录...";
    }
    return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.section == 3 && indexPath.row == 0) {
        NSArray *arr = [self.titleDictionary valueForKey:[NSString stringWithFormat:@"%d", (int)indexPath.section]];
        NSString *title = arr[indexPath.row];
        
        FingerprintSettingViewController *settingVC = [[FingerprintSettingViewController alloc] init];
        settingVC.title = title;
        [self.navigationController pushViewController:settingVC animated:YES];
    }
}

- (void)switchValueChanged:(UISwitch *)sender {
    if (sender.tag == 10) {
        if (sender.on) {
            NSLog(@"允许手机、电脑同时在线");
        } else {
            NSLog(@"不允许手机、电脑同时在线");
        }
    }
}

- (void)jumpToFingerprint {
    FingerprintSettingViewController *settingVC = [[FingerprintSettingViewController alloc] init];
    settingVC.title = @"手势、指纹锁定";
    [self.navigationController pushViewController:settingVC animated:YES];
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
