//
//  DNAccountViewController.m
//  LiveForMobile
//
//  Created by  Sierra on 2017/8/18.
//  Copyright © 2017年 BaiFuTak. All rights reserved.
//

#import "DNAccountViewController.h"
#import "DNAccountCell.h"

@interface DNAccountViewController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataArr;

@end

@implementation DNAccountViewController

#pragma mark - Getters

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, HEIGHT - 64)];
        _tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = RGB(245, 245, 245);
        [_tableView registerClass:[DNAccountCell class] forCellReuseIdentifier:DNAccountCellID];
    }
    return _tableView;
}

- (NSMutableArray *)dataArr {
    if (!_dataArr) {
        _dataArr = [NSMutableArray array];
        
        [_dataArr addObject:@"4"];
        [_dataArr addObject:@"0"];
        [_dataArr addObject:@"0"];
        [_dataArr addObject:@" "];
    }
    return _dataArr;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"大牛账户";
    self.view.backgroundColor = RGB(245, 245, 245);
    
    [self addLeftBarButtonItem];
    
    [self.view addSubview:self.tableView];
}


#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArr.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return DNACCOUNT_CELL_H;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    DNAccountCell *cell = [tableView dequeueReusableCellWithIdentifier:DNAccountCellID forIndexPath:indexPath];
    cell.indexPath = indexPath;
    cell.value = self.dataArr[indexPath.row];
    return cell;
}

#pragma mark - UITableViewDelegate

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
