//
//  HotViewController.m
//  LiveForMobile
//
//  Created by  Sierra on 2017/6/20.
//  Copyright © 2017年 BaiFuTak. All rights reserved.
//

#import "HotViewController.h"
#import "HotLiveCell.h"
#import "BWPlayViewController.h"

@interface HotViewController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataArr;

@end

@implementation HotViewController

#pragma mark - Getters

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, HEIGHT - 64 - 49)];
        _tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.dataSource = self;
        _tableView.delegate = self;
        
        [_tableView registerClass:[HotLiveCell class] forCellReuseIdentifier:HotLiveCellID];
    }
    return _tableView;
}

- (NSMutableArray *)dataArr {
    if (!_dataArr) {
        _dataArr = [NSMutableArray array];
        
        [_dataArr addObject:@"1"];
        [_dataArr addObject:@"1"];
        [_dataArr addObject:@"1"];
        [_dataArr addObject:@"1"];
        [_dataArr addObject:@"1"];
    }
    return _dataArr;
}


#pragma mark - Life Cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    // 1. 添加控件
    [self.view addSubview:self.tableView];
}


#pragma mark - UITableViewDelegate & UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArr.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return HOTLIVECELL_H;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    HotLiveCell *cell = [tableView dequeueReusableCellWithIdentifier:HotLiveCellID forIndexPath:indexPath];
    cell.value = @"test";
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    BWPlayViewController *playVC = [[BWPlayViewController alloc] init];
    
    playVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:playVC animated:YES];
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
