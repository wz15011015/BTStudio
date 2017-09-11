//
//  PlayPMViewController.m
//  LiveForMobile
//
//  Created by  Sierra on 2017/9/11.
//  Copyright © 2017年 BaiFuTak. All rights reserved.
//

#import "PlayPMViewController.h"
#import "PrivateMessageCell.h"
#import "PlayPMDetailViewController.h"

@interface PlayPMViewController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataArr;

@end

@implementation PlayPMViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 左导航栏按钮显示"消息"
    UIBarButtonItem *leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"消息" style:UIBarButtonItemStylePlain target:nil action:nil];
    leftBarButtonItem.enabled = NO;
    [leftBarButtonItem setTitleTextAttributes:@{NSForegroundColorAttributeName: RGB(36, 36, 36)} forState:UIControlStateNormal];
    [leftBarButtonItem setTitleTextAttributes:@{NSForegroundColorAttributeName: RGB(36, 36, 36)} forState:UIControlStateHighlighted];
    self.navigationItem.leftBarButtonItem = leftBarButtonItem;
    
    [self.view addSubview:self.tableView];
}


#pragma mark - UITableViewDataSource & UITableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArr.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return PRIVATEMESSAGE_CELL_H;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    PrivateMessageCell *cell = [tableView dequeueReusableCellWithIdentifier:PrivateMessageCellID forIndexPath:indexPath];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    PlayPMDetailViewController *detailVC = [[PlayPMDetailViewController alloc] init];
    detailVC.title = @"系统消息";
    [self.navigationController pushViewController:detailVC animated:YES];
}


#pragma mark - Getters

- (UITableView *)tableView {
    if (!_tableView) {
        CGFloat h = PLAYPM_VIEW_CONTROLLER_H - 44;
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, h)];
        _tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        [_tableView registerClass:[PrivateMessageCell class] forCellReuseIdentifier:PrivateMessageCellID];
    }
    return _tableView;
}

- (NSMutableArray *)dataArr {
    if (!_dataArr) {
        _dataArr = [NSMutableArray array];
        
        [_dataArr addObject:@""];
        [_dataArr addObject:@""];
        [_dataArr addObject:@""];
        [_dataArr addObject:@""];
        [_dataArr addObject:@""];
        [_dataArr addObject:@""];
        [_dataArr addObject:@""];
        [_dataArr addObject:@""];
        [_dataArr addObject:@""];
    }
    return _dataArr;
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
