//
//  ViewController.m
//  TouchIDDemo
//
//  Created by WangZhi on 16/6/15.
//  Copyright © 2016年 WangZhi. All rights reserved.
//

#import "ViewController.h"
#import "SettingViewController.h"
#import <LocalAuthentication/LocalAuthentication.h>

@interface ViewController () <UITextFieldDelegate>
@property (nonatomic, strong) UIButton *touchIDButton; // 验证TouchID的按钮
@property (nonatomic, strong) UIButton *settingButton; // 进入设置页面的按钮
@property (nonatomic, strong) UITextField *textField;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.title = @"Touch ID";
    self.view.backgroundColor = [UIColor colorWithRed:119 / 255.0 green:210 / 255.0 blue:251 / 255.0 alpha:1.0];
    
    // 注册通知：当从3D Touch快捷键的“设置”键进入应用时，能接收到通知，然后推出“设置”页面
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(setting) name:@"3DTouchOne" object:nil];
    
    [self.view addSubview:self.touchIDButton];
    
    [self.view addSubview:self.settingButton];
    
    [self.view addSubview:self.textField];
}

#pragma mark - getter
- (UIButton *)touchIDButton {
    if (!_touchIDButton) {
        _touchIDButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _touchIDButton.frame = CGRectMake(100, 90, CGRectGetWidth(self.view.frame) - 200, 50);
        [_touchIDButton setTitle:@"TouchID" forState:UIControlStateNormal];
        [_touchIDButton setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
        [_touchIDButton addTarget:self action:@selector(touchID:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _touchIDButton;
}

- (UIButton *)settingButton {
    if (!_settingButton) {
        _settingButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _settingButton.frame = CGRectMake(100, 180, CGRectGetWidth(self.view.frame) - 200, 50);
        [_settingButton setTitle:@"设置" forState:UIControlStateNormal];
        [_settingButton setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
        [_settingButton addTarget:self action:@selector(setting) forControlEvents:UIControlEventTouchUpInside];
    }
    return _settingButton;
}

- (UITextField *)textField {
    if (!_textField) {
        _textField = [[UITextField alloc] initWithFrame:CGRectMake(80, 250, CGRectGetWidth(self.view.frame) - 160, 30)];
        _textField.delegate = self;
        _textField.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
        _textField.backgroundColor = [UIColor whiteColor];
    }
    return _textField;
}

#pragma mark - Button Click
- (void)touchID:(UIButton *)sender {
    LAContext *context = [[LAContext alloc] init];
    NSError *err = nil;
    BOOL bl = [context canEvaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics error:&err];
    if (bl) {
        NSLog(@"恭喜，Touch ID可以使用！");
        [context evaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics localizedReason:@"需要验证您的指纹来确认您的身份信息" reply:^(BOOL success, NSError * _Nullable error) {
            if (success) {
                NSLog(@"恭喜，您通过了Touch ID指纹验证！");
                [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                    SettingViewController *settingVC = [[SettingViewController alloc] init];
                    [self.navigationController pushViewController:settingVC animated:YES];
                }];
            } else {
                NSLog(@"抱歉，您未能通过Touch ID指纹验证！\n%@", error);
//                if (error.code == LAErrorUserCancel) {
//                    
//                } else if (error.code == LAErrorUserFallback) {
//                    
//                } else {
//                    
//                }
            }
        }];
    } else {
        NSLog(@"抱歉，Touch ID不可以使用！\n%@", err);
    }
}

- (void)setting {
    BOOL enrolled = [[NSUserDefaults standardUserDefaults] boolForKey:@"TouchIDEnrolled"];
    if (!enrolled) {
        SettingViewController *settingVC = [[SettingViewController alloc] init];
        [self.navigationController pushViewController:settingVC animated:YES];
    } else {
        LAContext *context = [[LAContext alloc] init];
        NSError *err = nil;
        BOOL bl = [context canEvaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics error:&err];
        if (bl) {
            NSLog(@"恭喜，Touch ID可以使用！");
            [context evaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics localizedReason:@"需要验证您的指纹来确认您的身份信息" reply:^(BOOL success, NSError * _Nullable error) {
                if (success) {
                    NSLog(@"恭喜，您通过了Touch ID指纹验证！");
                    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                        SettingViewController *settingVC = [[SettingViewController alloc] init];
                        [self.navigationController pushViewController:settingVC animated:YES];
                    }];
                } else {
                    NSLog(@"抱歉，您未能通过Touch ID指纹验证！\n%@", error);
                    
//                    if (error.code == LAErrorUserCancel) {
//                        
//                    } else if (error.code == LAErrorUserFallback) {
//                        
//                    } else {
//                        
//                    }
                }
            }];
        } else {
            NSLog(@"抱歉，Touch ID不可以使用！\n%@", err); 
        }
    }
}

#pragma mark - UITextField Delegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    
    NSInteger type = [textField.text integerValue];
    
    /** 跳转到系统各种设置界面里 */
    // 1. 在info.plist中添加一项URL Types,并设置URL Schemes为: prefs
    // 2. 创建URL,执行: [[UIApplication sharedApplication] openURL:url];
    
    NSURL *url = nil;
    switch (type) {
        case 0:
            url = [NSURL URLWithString:@"prefs:root=General&path=About"];         // 设置-->通用-->关于本机
            break;
            
        case 1:
            url = [NSURL URLWithString:@"prefs:root=General&path=ACCESSIBILITY"]; // 设置-->通用-->辅助功能
            break;
            
        case 2:
            url = [NSURL URLWithString:@"prefs:root=AIRPLANE_MODE"];              // 设置
            break;
            
        case 3:
            url = [NSURL URLWithString:@"prefs:root=General&path=AUTOLOCK"];      // 设置-->通用-->自动锁定
            break;
            
        case 4:
            url = [NSURL URLWithString:@"prefs:root=Brightness"];                 // 设置
            break;
            
        case 5:
            url = [NSURL URLWithString:@"prefs:root=Bluetooth"];                  // 设置-->蓝牙
            break;
            
        case 6:
            url = [NSURL URLWithString:@"prefs:root=General&path=DATE_AND_TIME"]; // 设置-->通用-->日期与时间
            break;
            
        case 7:
            url = [NSURL URLWithString:@"prefs:root=FACETIME"];                   // 设置-->FaceTime
            break;
            
        case 8:
            url = [NSURL URLWithString:@"prefs:root=General"];                    // 设置-->通用
            break;
            
        case 9:
            url = [NSURL URLWithString:@"prefs:root=General&path=Keyboard"];      // 设置-->通用-->键盘
            break;
            
        case 10:
            url = [NSURL URLWithString:@"prefs:root=CASTLE"];                     // 设置-->iCloud
            break;
            
        case 11:
            url = [NSURL URLWithString:@"prefs:root=CASTLE&path=STORAGE_AND_BACKUP"]; // 设置-->iCloud-->存储空间
            break;
            
        case 12:
            url = [NSURL URLWithString:@"prefs:root=General&path=INTERNATIONAL"]; // 设置-->通用-->语言与地区
            break;
            
        case 13:
            url = [NSURL URLWithString:@"prefs:root=LOCATION_SERVICES"];          // 设置-->隐私-->定位服务
            break;
            
        case 14:
            url = [NSURL URLWithString:@"prefs:root=MUSIC"];                      // 设置-->音乐
            break;
            
        case 15:
            url = [NSURL URLWithString:@"prefs:root=MUSIC&path=EQ"];              // 设置-->音乐
            break;
            
        case 16:
            url = [NSURL URLWithString:@"prefs:root=MUSIC&path=VolumeLimit"];     // 设置-->音乐
            break;
            
        case 17:
            url = [NSURL URLWithString:@"prefs:root=General&path=Network"];       // 设置-->通用
            break;
            
        case 18:
            url = [NSURL URLWithString:@"prefs:root=NIKE_PLUS_IPOD"];             // 设置-->通用
            break;
            
        case 19:
            url = [NSURL URLWithString:@"prefs:root=NOTES"];                      // 设置-->通用-->备忘录
            break;
            
        case 20:
            url = [NSURL URLWithString:@"prefs:root=NOTIFICATIONS_ID"];           // 设置-->通知
            break;
            
        case 21:
            url = [NSURL URLWithString:@"prefs:root=Phone"];                      // 设置-->电话
            break;
            
        case 22:
            url = [NSURL URLWithString:@"prefs:root=Photos"];                     // 设置-->照片与相机
            break;
            
        case 23:
            url = [NSURL URLWithString:@"prefs:root=Photos"];                     // 设置-->照片与相机
            break;
            
        case 24:
            url = [NSURL URLWithString:@"prefs:root=General&path=ManagedConfigurationList"]; // 设置-->通用-->设备管理
            break;
            
        case 25:
            url = [NSURL URLWithString:@"prefs:root=General&path=Reset"];         // 设置-->通用-->还原
            break;
            
        case 26:
            url = [NSURL URLWithString:@"prefs:root=Safari"];                     // 设置-->通用
            break;
            
        case 27:
            url = [NSURL URLWithString:@"prefs:root=General&path=Assistant"];     // 设置-->通用
            break;
            
        case 28:
            url = [NSURL URLWithString:@"prefs:root=Sounds"];                     // 设置-->声音
            break;
            
        case 29:
            url = [NSURL URLWithString:@"prefs:root=General&path=SOFTWARE_UPDATE_LINK"]; // 设置-->通用-->软件更新
            break;
            
        case 30:
            url = [NSURL URLWithString:@"prefs:root=STORE"];                      // 设置-->iTunes Store 与 App Store
            break;
            
        case 31:
            url = [NSURL URLWithString:@"prefs:root＝TWITTER"];                   // 未跳转
            break;
            
        case 32:
            url = [NSURL URLWithString:@"prefs:root=General&path=USAGE"];         // 设置-->通用
            break;
            
        case 33:
            url = [NSURL URLWithString:@"prefs:root=General&path=Network/VPN"];   // 设置-->通用
            break;
            
        case 34:
            url = [NSURL URLWithString:@"prefs:root=Wallpaper"];                  // 设置-->墙纸
            break;
            
        case 35:
            url = [NSURL URLWithString:@"prefs:root=WIFI"];                       // 设置-->Wi-Fi
            break;
            
        case 36:
            url = [NSURL URLWithString:@"prefs:root=INTERNET_TETHERING"];         // 设置-->个人热点
            break;
            
        default:
            break;
    }
    
    if ([[UIApplication sharedApplication] canOpenURL:url]) {
        [[UIApplication sharedApplication] openURL:url];
    }
    
    return YES;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
