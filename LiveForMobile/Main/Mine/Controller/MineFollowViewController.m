//
//  MineFollowViewController.m
//  LiveForMobile
//
//  Created by  Sierra on 2017/8/10.
//  Copyright © 2017年 BaiFuTak. All rights reserved.
//

#import "MineFollowViewController.h"
#import "MineFollowCell.h"

@interface MineFollowViewController () <UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataArr;

@end

@implementation MineFollowViewController

#pragma mark - Getters

- (NSMutableArray *)dataArr {
    if (!_dataArr) {
        _dataArr = [NSMutableArray array];
        
        [_dataArr addObject:@{@"img_url" : @"avatar_default",
                              @"rank"    : @"0",
                              @"name"    : @"哦哦妹",
                              @"gender"  : @"2",
                              @"intro"   : @"模特 2012环球国际模特大赛最佳上镜奖"
                              }];
        [_dataArr addObject:@{@"img_url" : @"user_avatar_default",
                              @"rank"    : @"1",
                              @"name"    : @"l a n 爷",
                              @"gender"  : @"1",
                              @"intro"   : @"我是一只小鸭子"
                              }];
        [_dataArr addObject:@{@"img_url" : @"avatar_default",
                              @"rank"    : @"2",
                              @"name"    : @"Quess 柒柒",
                              @"gender"  : @"2",
                              @"intro"   : @"上善若水 邻家少女与您每晚相约!"
                              }];
        [_dataArr addObject:@{@"img_url" : @"avatar_default",
                              @"rank"    : @"3",
                              @"name"    : @"胡豆豆儿 豆..豆.豆..豆.豆...豆",
                              @"gender"  : @"2",
                              @"intro"   : @"上善若水 邻家少女与您每晚相约! 就让一切随它吧! 随它吧!"
                              }];
    }
    return _dataArr;
}


#pragma mark - Life Cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"我的关注";
    
    [self addLeftBarButtonItem];
    
    // 添加控件
    [self.tableView registerClass:[MineFollowCell class] forCellReuseIdentifier:MineFollowCellID];
    [self.view addSubview:self.tableView];
}


#pragma mark - UITableViewDelegate & UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArr.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return MINE_FOLLOW_CELL_H;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MineFollowCell *cell = [tableView dequeueReusableCellWithIdentifier:MineFollowCellID forIndexPath:indexPath];
    cell.valueDic = self.dataArr[indexPath.row];
    return cell;
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
