//
//  MineFansViewController.m
//  LiveForMobile
//
//  Created by  Sierra on 2017/8/11.
//  Copyright © 2017年 BaiFuTak. All rights reserved.
//

#import "MineFansViewController.h"
#import "MineFansCell.h"

@interface MineFansViewController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataArr;

@end

@implementation MineFansViewController

#pragma mark - Getters

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, HEIGHT - 64)];
        _tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.dataSource = self;
        _tableView.delegate = self;
        [_tableView registerClass:[MineFansCell class] forCellReuseIdentifier:MineFansCellID];
    }
    return _tableView;
}

- (NSMutableArray *)dataArr {
    if (!_dataArr) {
        _dataArr = [NSMutableArray array];
        
        NSDictionary *dic1 = @{@"img_url" : @"avatar_default",
                               @"rank"    : @"0",
                               @"name"    : @"☕️小咖啡",
                               @"gender"  : @"2",
                               @"intro"   : @"🌱微博: queer小咖咖"
                               };
        NSDictionary *dic2 = @{@"img_url" : @"avatar_default",
                               @"rank"    : @"1",
                               @"name"    : @"🍄小蘑菇来了",
                               @"gender"  : @"2",
                               @"intro"   : @"努力做更好的自己🍄"
                               };
        NSDictionary *dic3 = @{@"img_url" : @"avatar_default",
                               @"rank"    : @"2",
                               @"name"    : @"小星丫丫",
                               @"gender"  : @"2",
                               @"intro"   : @"周一到周五每晚八点半左右直播,周六休息"
                               };
        NSDictionary *dic4 = @{@"img_url" : @"avatar_default",
                               @"rank"    : @"3",
                               @"name"    : @"晓儿宝宝",
                               @"gender"  : @"2",
                               @"intro"   : @"❤️直播时间: 每天下午3-6 7-9"
                               };
        [_dataArr addObject:dic1];
        [_dataArr addObject:dic2];
        [_dataArr addObject:dic3];
        [_dataArr addObject:dic4];
        
        [_dataArr addObject:dic1];
        [_dataArr addObject:dic3];
        [_dataArr addObject:dic2];
        [_dataArr addObject:dic1];
        [_dataArr addObject:dic2];
        [_dataArr addObject:dic3];
        [_dataArr addObject:dic4];
        [_dataArr addObject:dic2];
        [_dataArr addObject:dic1];
        [_dataArr addObject:dic4];
        [_dataArr addObject:dic4];
        [_dataArr addObject:dic2];
        
        [_dataArr addObject:dic1];
        [_dataArr addObject:dic3];
        [_dataArr addObject:dic2];
        [_dataArr addObject:dic1];
        [_dataArr addObject:dic2];
        [_dataArr addObject:dic3];
        [_dataArr addObject:dic4];
        [_dataArr addObject:dic2];
        [_dataArr addObject:dic1];
        [_dataArr addObject:dic4];
        [_dataArr addObject:dic4];
        [_dataArr addObject:dic2];
        
        [_dataArr addObject:dic4];
        [_dataArr addObject:dic2];
    }
    return _dataArr;
}


#pragma mark - Life Cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"我的粉丝";
    
    [self addLeftBarButtonItem];
    
    [self.view addSubview:self.tableView];
}


#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MineFansCell *cell = [tableView dequeueReusableCellWithIdentifier:MineFansCellID forIndexPath:indexPath];
    cell.valueDic = self.dataArr[indexPath.row];
    return cell;
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return MINE_FANS_CELL_H;
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
