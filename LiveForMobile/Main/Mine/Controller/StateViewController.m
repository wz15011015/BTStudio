//
//  StateViewController.m
//  LiveForMobile
//
//  Created by  Sierra on 2017/8/8.
//  Copyright © 2017年 BaiFuTak. All rights reserved.
//

#import "StateViewController.h"
#import "WaterFallCollectionLayout.h"
#import "FollowCell.h"
#import "FollowModel.h"
#import "PublishStateCell.h"

@interface StateViewController () <UICollectionViewDelegate, UICollectionViewDataSource> {
    NSInteger _pageNum;  // 当前请求的分页页码数
}

@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) NSMutableArray *dataArr;
@property (nonatomic, strong) NSMutableArray *heightArr;

@end

@implementation StateViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"我的动态";
    
    [self addLeftBarButtonItem];
    
    // 0. 初始化
    _pageNum = 1;
    
    // 1. 添加控件
    [self.view addSubview:self.collectionView];
    // 上下拉刷新
    self.collectionView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        _pageNum = 1;
        [self loadData];
    }];
    self.collectionView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        _pageNum += 1;
        [self loadData];
    }];
    
    // 2. 加载数据
    [self loadData];
}


#pragma mark - Load Data

- (void)loadData {
    FollowModel *model0 = [[FollowModel alloc] init];
    model0.coverUrl = @"avatar_default";
    model0.title = @"好热啊!";
    model0.imageUrl = @"user_avatar_default";
    model0.name = @"正在直播的_我";
    
    FollowModel *model1 = [[FollowModel alloc] init];
    model1.coverUrl = @"avatar_default";
    model1.title = @"目光所及，更显锋芒，显锋芒，锋芒，芒。";
    model1.imageUrl = @"user_avatar_default";
    model1.name = @"正在直播的_我";
    
    FollowModel *model2 = [[FollowModel alloc] init];
    model2.coverUrl = @"avatar_default";
    model2.title = @"每一天，都可以更好。";
    model2.imageUrl = @"user_avatar_default";
    model2.name = @"正在直播的_我";
    
    FollowModel *model3 = [[FollowModel alloc] init];
    model3.coverUrl = @"avatar_default";
    model3.title = @"迄今为止，iPhone 速度最高的芯片。[2 倍速度提升（与iPhone 6 相比），电池续航进一步提升。]";
    model3.imageUrl = @"user_avatar_default";
    model3.name = @"正在直播的_我";
    
    if (_pageNum == 1) {
        [self.dataArr removeAllObjects];
        
        [self.dataArr addObject:model0];
        [self.dataArr addObject:model1];
        [self.dataArr addObject:model2];
    } else {
        [self.dataArr addObject:model3];
    }
    if (_pageNum == 1) {
        [self.collectionView.mj_header endRefreshing];
    } else {
        [self.collectionView.mj_footer endRefreshing];
    }
    
    // 刷新高度数据
    [self.heightArr removeAllObjects];
    [self.heightArr addObject:@(PUBLISH_STATE_CELL_H)];
    for (int i = 0; i < self.dataArr.count; i++) {
        FollowModel *model = self.dataArr[i];
        CGFloat cellHeight = [FollowCell heightForCellWithString:model.title];
        [self.heightArr addObject:@(cellHeight)];
    }
    
    [self.collectionView reloadData];
}


#pragma mark - Getters

- (UICollectionView *)collectionView {
    if (!_collectionView) {
        WaterFallCollectionLayout *layout = [[WaterFallCollectionLayout alloc] init];
        layout.heightArr = self.heightArr;
        
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, HEIGHT - 64) collectionViewLayout:layout];
        _collectionView.backgroundColor = RGB(237, 237, 237);
        _collectionView.dataSource = self;
        _collectionView.delegate = self;
        [_collectionView registerClass:[FollowCell class] forCellWithReuseIdentifier:FollowCellID];
        [_collectionView registerClass:[PublishStateCell class] forCellWithReuseIdentifier:PublishStateCellID];
    }
    return _collectionView;
}

- (NSMutableArray *)dataArr {
    if (!_dataArr) {
        _dataArr = [NSMutableArray array];
    }
    return _dataArr;
}

- (NSMutableArray *)heightArr {
    if (!_heightArr) {
        _heightArr = [NSMutableArray array];
    }
    return _heightArr;
}


#pragma mark - UICollectionViewDelegate

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.heightArr.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        PublishStateCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:PublishStateCellID forIndexPath:indexPath];
        return cell;
    }
    
    FollowCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:FollowCellID forIndexPath:indexPath];
    cell.model = self.dataArr[indexPath.row - 1];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        NSLog(@"发布动态");
        return;
    }
    FollowModel *model = self.dataArr[indexPath.row - 1];
    NSLog(@"点击了: %@", model.name);
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
