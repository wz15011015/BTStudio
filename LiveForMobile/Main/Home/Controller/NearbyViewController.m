//
//  NearbyViewController.m
//  LiveForMobile
//
//  Created by  Sierra on 2017/9/11.
//  Copyright © 2017年 BaiFuTak. All rights reserved.
//

#import "NearbyViewController.h"
#import "NearbyFoldingCell.h"
//#import "LiveForMobile-Swift.h"

#define NEARBY_FOLDING_CELL_H_CLOSE (80.0)
#define NEARBY_FOLDING_CELL_H_OPEN  (160.0)

//NSString *const NearbyFoldingCellID = @"NearbyFoldingCellIdentifier";

@interface NearbyViewController () <UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate> {
    NSInteger _pageNum;  // 当前请求的分页页码数
}

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataArr;
@property (nonatomic, strong) NSMutableArray *cellHeightArr;

@end

@implementation NearbyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 0. 初始化
    _pageNum = 1;
    
    // 1. 添加控件
    [self.view addSubview:self.tableView];
    // 上下拉刷新
//    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
//        _pageNum = 1;
////        [self loadData2];
//    }];
//    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
//        _pageNum += 1;
////        [self loadData2];
//    }];
    
    // 2. 加载数据
    [self loadData];
//    [self loadData2];
}

- (void)loadData {
    
    
    [self.dataArr addObject:@""];
    [self.dataArr addObject:@""];
    [self.dataArr addObject:@""];
    [self.dataArr addObject:@""];
    
    [self.cellHeightArr addObject:@(NEARBY_FOLDING_CELL_H_CLOSE)];
    [self.cellHeightArr addObject:@(NEARBY_FOLDING_CELL_H_CLOSE)];
    [self.cellHeightArr addObject:@(NEARBY_FOLDING_CELL_H_CLOSE)];
    [self.cellHeightArr addObject:@(NEARBY_FOLDING_CELL_H_CLOSE)];
}


#pragma mark - UITableViewDelegate & UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArr.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
//    NSNumber *height = self.cellHeightArr[indexPath.row];
//    return height.floatValue;
    
    return NEARBY_FOLDING_CELL_H_CLOSE;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
//    NearbyFoldingCellSwift *myCell = (NearbyFoldingCellSwift *)cell;
//    
//    NSNumber *height = self.cellHeightArr[indexPath.row];
//    BOOL cellIsClosed = height.floatValue == NEARBY_FOLDING_CELL_H_CLOSE;
//    if (cellIsClosed) {
//        [myCell unfold:NO animated:NO completion:nil];
//    } else {
//        [myCell unfold:YES animated:NO completion:nil];
//    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NearbyFoldingCell *cell = [tableView dequeueReusableCellWithIdentifier:NearbyFoldingCellID forIndexPath:indexPath];
    return cell;
    
//    NearbyFoldingCellSwift *cell = [tableView dequeueReusableCellWithIdentifier:NearbyFoldingCellID forIndexPath:indexPath];
//    
//    NSArray *durations = @[@0.26, @0.2];
//    [cell setDurationsForExpandedState:durations];
//    [cell setDurationsForCollapsedState:durations];
//    
//    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
//    NearbyFoldingCellSwift *cell = [tableView cellForRowAtIndexPath:indexPath];
//    if (cell.isAnimating) {
//        return;
//    }
//    
//    CGFloat duration = 0.0;
//    NSNumber *height = self.cellHeightArr[indexPath.row];
//    BOOL cellIsClosed = height.floatValue == NEARBY_FOLDING_CELL_H_CLOSE;
//    if (cellIsClosed) {
//        [self.cellHeightArr setObject:@(NEARBY_FOLDING_CELL_H_OPEN) atIndexedSubscript:indexPath.row];
//        [cell unfold:YES animated:YES completion:nil];
////        [cell selectedAnimation:YES animated:YES completion:nil];
//        duration = 0.5;
//    } else {
//        [self.cellHeightArr setObject:@(NEARBY_FOLDING_CELL_H_CLOSE) atIndexedSubscript:indexPath.row];
//        [cell unfold:NO animated:YES completion:nil];
////        [cell selectedAnimation:NO animated:YES completion:nil];
//        duration = 0.8;
//    }
//    
//    [UIView animateWithDuration:duration delay:0 options:0 animations:^{
//        [tableView beginUpdates];
//        [tableView endUpdates];
//    } completion:^(BOOL finished) {
//        
//    }];
}


#pragma mark - Getters

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, HEIGHT - 64 - 49)];
        _tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.estimatedRowHeight = NEARBY_FOLDING_CELL_H_CLOSE;
        _tableView.rowHeight = UITableViewAutomaticDimension;
        
        [_tableView registerClass:[NearbyFoldingCell class] forCellReuseIdentifier:NearbyFoldingCellID];
//        [_tableView registerClass:[NearbyFoldingCellSwift class] forCellReuseIdentifier:NearbyFoldingCellID];
    }
    return _tableView;
}

- (NSMutableArray *)dataArr {
    if (!_dataArr) {
        _dataArr = [NSMutableArray array];
    }
    return _dataArr;
}

- (NSMutableArray *)cellHeightArr {
    if (!_cellHeightArr) {
        _cellHeightArr = [NSMutableArray array];
    }
    return _cellHeightArr;
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
