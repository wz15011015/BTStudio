//
//  FingerprintSettingViewController.m
//  TouchIDDemo
//
//  Created by WangZhi on 16/6/15.
//  Copyright © 2016年 WangZhi. All rights reserved.
//

#import "FingerprintSettingViewController.h"
#import <LocalAuthentication/LocalAuthentication.h>

@interface FingerprintSettingViewController () <UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSDictionary *titleDictionary;
@end

@implementation FingerprintSettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
 
    [self.view addSubview:self.tableView];
}

#pragma mark - getter
- (NSDictionary *)titleDictionary {
    if (!_titleDictionary) {
        _titleDictionary = @{@"0" : @[@"开启密码锁定"],
                             @"1" : @[@"手动锁屏", @"自动锁屏"],
                             @"2" : @[@"开启Touch ID指纹解锁"],
                             @"3" : @[@"重置手势密码"]};
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
    if (indexPath.section == 1 && indexPath.row == 0) {
        return 54;
    } else if (indexPath.section == 1 && indexPath.row == 1) {
        return 54;
    } else {
        return 44;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellID = @"CellID";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellID];
    }
    
    NSArray *arr = [self.titleDictionary valueForKey:[NSString stringWithFormat:@"%d", (int)indexPath.section]];
    NSString *title = arr[indexPath.row];
    cell.textLabel.text = title;
    
    
    UISwitch *swithBtn = [[UISwitch alloc] init];
    [swithBtn addTarget:self action:@selector(switchValueChanged:) forControlEvents:UIControlEventValueChanged];
    
    if (indexPath.section == 0 && indexPath.row == 0) {
        swithBtn.tag = 10;
        cell.accessoryView = swithBtn;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    } else if (indexPath.section == 1 && indexPath.row == 0) {
        cell.detailTextLabel.textColor = [UIColor grayColor];
        cell.detailTextLabel.text = @"上推首界面导航栏，锁定屏幕";
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    } else if (indexPath.section == 1 && indexPath.row == 1) {
        cell.detailTextLabel.textColor = [UIColor grayColor];
        cell.detailTextLabel.text = @"退出QQ后，程序自动锁定屏幕";
        cell.accessoryType = UITableViewCellAccessoryNone;
    } else if (indexPath.section == 2 && indexPath.row == 0) {
        BOOL enrolled = [[NSUserDefaults standardUserDefaults] boolForKey:@"TouchIDEnrolled"];
        swithBtn.on = enrolled;
        swithBtn.tag = 11;
        cell.accessoryView = swithBtn;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    } else {
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    
    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section {
    if (section == 2) {
        return @"开启后，可使用Touch ID解锁QQ";
    }
    return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)switchValueChanged:(UISwitch *)sender {
    if (sender.tag == 10) {
        if (sender.on) {
            NSLog(@"开启了 密码锁定");
        } else {
            NSLog(@"关闭了 密码锁定");
        }
    } else {
        if (sender.on) {
            NSLog(@"开启了 Touch ID指纹解锁");
            [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"TouchIDEnrolled"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            
            LAContext *context = [[LAContext alloc] init];
            NSError *err = nil;
            BOOL bl = [context canEvaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics error:&err];
            if (bl) {
                NSLog(@"恭喜，Touch ID可以使用！");
                [context evaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics localizedReason:@"需要验证您的指纹来确认您的身份信息" reply:^(BOOL success, NSError * _Nullable error) {
                    if (success) {
                        NSLog(@"恭喜，您通过了Touch ID指纹验证！");
                    } else {
                        NSLog(@"抱歉，您未能通过Touch ID指纹验证！\n%@", error);
                        dispatch_async(dispatch_get_main_queue(), ^{
                            [sender setOn:NO animated:YES];
                        });
                        
//                        if (error.code == LAErrorUserCancel) {
//                            
//                        } else if (error.code == LAErrorUserFallback) {
//                            
//                        } else {
//                            
//                        }
                    }
                }];
            } else {
                NSLog(@"抱歉，Touch ID不可以使用！\n%@", err);
                [sender setOn:NO animated:YES];
            }
            
        } else {
            NSLog(@"关闭了 Touch ID指纹解锁");
            [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"TouchIDEnrolled"];
            [[NSUserDefaults standardUserDefaults] synchronize];
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
