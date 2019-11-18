//
//  SettingViewController.m
//  TouchIDDemo
//
//  Created by WangZhi on 16/6/15.
//  Copyright © 2016年 WangZhi. All rights reserved.
//

#import "SettingViewController.h"
#import "DeviceLockViewController.h"
#import "AccessibilityViewController.h"

@interface SettingViewController () <UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, weak) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSDictionary *titleDictionary;

@property (nonatomic, strong) UIButton *backBtn;
@end

@implementation SettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"设置"; 
    
    // 注册通知：当从3D Touch快捷键的“设备锁、帐号安全”键进入应用时，能接收到通知，然后推出“设备锁、帐号安全”页面
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(jumpToDeviceLock) name:@"3DTouchTwo" object:nil];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBarHidden = NO; 
}

#pragma mark - getter 
- (NSDictionary *)titleDictionary {
    if (!_titleDictionary) {
        _titleDictionary = @{@"0" : @[@"账号管理", @"手机号码", @"QQ达人"],
                             @"1" : @[@"消息通知", @"聊天记录"],
                             @"2" : @[@"联系人、隐私", @"设备锁、帐号安全", @"辅助功能"],
                             @"3" : @[@"关于QQ与帮助"]};
    }
    return _titleDictionary;
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
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    
    NSArray *arr = [self.titleDictionary valueForKey:[NSString stringWithFormat:@"%d", (int)indexPath.section]];
    NSString *title = arr[indexPath.row];
    cell.textLabel.text = title;
    return cell;
}

// 默认情况下，heightForHeaderInSection 和 heightForFooterInSection 都是22.0; 当你设置小余22.0的高度时候就是无效的。 解决的办法也很奇葩，你必须同时指定一下 heightForFooterInSection, 比如指定一个非常小的值 (0.0001),这样的 Section Header 就显示正确了。这个问题只有在使用 UITableViewStyleGrouped 来创建 UITableView 的时候才会出现，而默认的样式中随意指定 SectionHeader 高度都是可以的。
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 18;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.01;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NSArray *arr = [self.titleDictionary valueForKey:[NSString stringWithFormat:@"%d", (int)indexPath.section]];
    NSString *title = arr[indexPath.row];
    
    if (indexPath.section == 2 && indexPath.row == 1) {
        DeviceLockViewController *lockVC = [[DeviceLockViewController alloc] init];
        lockVC.title = title;
        [self.navigationController pushViewController:lockVC animated:YES];
    } else if (indexPath.section == 2 && indexPath.row == 2) {
        AccessibilityViewController *accessibilityVC = [[AccessibilityViewController alloc] init];
        accessibilityVC.title = title;
        [self.navigationController pushViewController:accessibilityVC animated:YES];
    }
}

- (void)jumpToDeviceLock {
    DeviceLockViewController *lockVC = [[DeviceLockViewController alloc] init];
    lockVC.title = @"设备锁、帐号安全";
    [self.navigationController pushViewController:lockVC animated:YES];
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
