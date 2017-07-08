//
//  MineViewController.m
//  LiveForMobile
//
//  Created by  Sierra on 2017/7/7.
//  Copyright © 2017年 BaiFuTak. All rights reserved.
//

#import "MineViewController.h"
#import "MineCell.h"

@interface MineViewController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *group1Arr;
@property (nonatomic, strong) NSMutableArray *group2Arr;
@property (nonatomic, strong) NSMutableArray *group3Arr;

@property (nonatomic, strong) NSMutableArray *dataArr;

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


#pragma mark - Life Cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"我的";
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.view.backgroundColor = RGB(241, 241, 241);
    
    // 1. 初始化参数
    
    // 2. 添加控件
    [self.view addSubview:self.tableView];
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
        return kMineCellH;
    } else if (indexPath.section == 1) {
        return kMineCellH;
    } else {
        return kMineCellH;
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
