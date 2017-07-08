//
//  PrivateMessageViewController.m
//  LiveForMobile
//
//  Created by  Sierra on 2017/7/8.
//  Copyright © 2017年 BaiFuTak. All rights reserved.
//

#import "PrivateMessageViewController.h"
#import "PMPrivateMessageCell.h"

@interface PrivateMessageViewController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataArr;

@end

@implementation PrivateMessageViewController

#pragma mark - Getters

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, HEIGHT - 49 - 64)];
        _tableView.backgroundColor = RGB(241, 241, 241);
        _tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        [_tableView registerClass:[PMPrivateMessageCell class] forCellReuseIdentifier:PMPrivateMessageCellID];
    }
    return _tableView;
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
    self.navigationItem.title = @"私信";
    self.view.backgroundColor = RGB(241, 241, 241);
    
    // 1. 初始化参数
    
    // 2. 添加控件
    [self.view addSubview:self.tableView];
    
    // 3. 加载数据
    [self loadData];
}


#pragma mark - Load Data

- (void)loadData {
    [self.dataArr addObject:@""];
    [self.dataArr addObject:@""];
    [self.dataArr addObject:@""];
    
    [self.tableView reloadData];
}


#pragma mark - UITableViewDelegate & DataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArr.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return kPMPrivateMessageCellH;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    PMPrivateMessageCell *cell = [tableView dequeueReusableCellWithIdentifier:PMPrivateMessageCellID forIndexPath:indexPath];
    
    NSString *model = self.dataArr[indexPath.row];
    cell.model = model;
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
