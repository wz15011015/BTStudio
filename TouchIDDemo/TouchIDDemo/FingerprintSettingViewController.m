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
                        
                        
//                        /// Authentication was not successful, because user failed to provide valid credentials.
//                        LAErrorAuthenticationFailed = kLAErrorAuthenticationFailed,
//
//                        /// Authentication was canceled by user (e.g. tapped Cancel button).
//                        LAErrorUserCancel = kLAErrorUserCancel,
                        
//                        /// Authentication was canceled, because the user tapped the fallback button (Enter Password).
//                        LAErrorUserFallback = kLAErrorUserFallback,
//
//                        /// Authentication was canceled by system (e.g. another application went to foreground).
//                        LAErrorSystemCancel = kLAErrorSystemCancel,
//
//                        /// Authentication could not start, because passcode is not set on the device.
//                        LAErrorPasscodeNotSet = kLAErrorPasscodeNotSet,
//
//                        /// Authentication could not start, because Touch ID is not available on the device.
//                        LAErrorTouchIDNotAvailable NS_ENUM_DEPRECATED(10_10, 10_13, 8_0, 11_0, "use LAErrorBiometryNotAvailable") = kLAErrorTouchIDNotAvailable,
//
//                        /// Authentication could not start, because Touch ID has no enrolled fingers.
//                        LAErrorTouchIDNotEnrolled NS_ENUM_DEPRECATED(10_10, 10_13, 8_0, 11_0, "use LAErrorBiometryNotEnrolled") = kLAErrorTouchIDNotEnrolled,
//
//                        /// Authentication was not successful, because there were too many failed Touch ID attempts and
//                        /// Touch ID is now locked. Passcode is required to unlock Touch ID, e.g. evaluating
//                        /// LAPolicyDeviceOwnerAuthenticationWithBiometrics will ask for passcode as a prerequisite.
//                        LAErrorTouchIDLockout NS_ENUM_DEPRECATED(10_11, 10_13, 9_0, 11_0, "use LAErrorBiometryLockout")
//                        __WATCHOS_DEPRECATED(3.0, 4.0, "use LAErrorBiometryLockout") __TVOS_DEPRECATED(10.0, 11.0, "use LAErrorBiometryLockout") = kLAErrorTouchIDLockout,
//
//                        /// Authentication was canceled by application (e.g. invalidate was called while
//                        /// authentication was in progress).
//                        LAErrorAppCancel NS_ENUM_AVAILABLE(10_11, 9_0) = kLAErrorAppCancel,
//
//                        /// LAContext passed to this call has been previously invalidated.
//                        LAErrorInvalidContext NS_ENUM_AVAILABLE(10_11, 9_0) = kLAErrorInvalidContext,
//
//                        /// Authentication could not start, because biometry is not available on the device.
//                        LAErrorBiometryNotAvailable NS_ENUM_AVAILABLE(10_13, 11_0) __WATCHOS_AVAILABLE(4.0) __TVOS_AVAILABLE(11.0) = kLAErrorBiometryNotAvailable,
//
//                        /// Authentication could not start, because biometry has no enrolled identities.
//                        LAErrorBiometryNotEnrolled NS_ENUM_AVAILABLE(10_13, 11_0) __WATCHOS_AVAILABLE(4.0) __TVOS_AVAILABLE(11.0) = kLAErrorBiometryNotEnrolled,
//
//                        /// Authentication was not successful, because there were too many failed biometry attempts and
//                        /// biometry is now locked. Passcode is required to unlock biometry, e.g. evaluating
//                        /// LAPolicyDeviceOwnerAuthenticationWithBiometrics will ask for passcode as a prerequisite.
//                        LAErrorBiometryLockout NS_ENUM_AVAILABLE(10_13, 11_0) __WATCHOS_AVAILABLE(4.0) __TVOS_AVAILABLE(11.0) = kLAErrorBiometryLockout,
//
//                        /// Authentication failed, because it would require showing UI which has been forbidden
//                        /// by using interactionNotAllowed property.
//                        LAErrorNotInteractive API_AVAILABLE(macos(10.10), ios(8.0), watchos(3.0), tvos(10.0)) = kLAErrorNotInteractive,
                        
                        if (error.code == LAErrorAuthenticationFailed) {
                            NSLog(@"指纹验证未成功, 因为用户未能提供有效的指纹。");
                            
                        } else if (error.code == LAErrorUserCancel) {
                            NSLog(@"指纹验证被用户取消,例如点击了取消按钮。");
                            
                        } else if (error.code == LAErrorUserFallback) {
                            NSLog(@"指纹验证被用户取消,例如点击了输入密码按钮。");
                            
                        } else if (error.code == LAErrorSystemCancel) {
                            NSLog(@"指纹验证被系统取消,例如另一个应用进入前台。");
                            
                        } else if (error.code == LAErrorPasscodeNotSet) {
                            NSLog(@"指纹验证未成功, 因为用户未能提供有效的指纹。");
                            
                        } else if (error.code == LAErrorPasscodeNotSet) {
                            NSLog(@"指纹验证未开始, 因为该设备未设置密码。");
                            
                        } else if (error.code == LAErrorSystemCancel) {
                            
                        } else if (error.code == LAErrorSystemCancel) {
                            
                        } else if (error.code == LAErrorSystemCancel) {
                            
                        } else if (error.code == LAErrorSystemCancel) {
                            
                        } else if (error.code == LAErrorSystemCancel) {
                            
                        }
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
