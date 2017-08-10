//
//  FollowViewController.m
//  LiveForMobile
//
//  Created by  Sierra on 2017/7/6.
//  Copyright © 2017年 BaiFuTak. All rights reserved.
//

#import "FollowViewController.h"
#import "WaterFallCollectionLayout.h"
#import "FollowCell.h"
#import "FollowModel.h"

@interface FollowViewController () <UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout> {
    NSInteger _pageNum;  // 当前请求的分页页码数
}
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) NSMutableArray *dataArr;
@property (nonatomic, strong) NSMutableArray *heightArr;

@end

@implementation FollowViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"关注";
    self.automaticallyAdjustsScrollViewInsets = NO;
    
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
    model0.title = @"不只能做到，还能做到更好。";
    model0.imageUrl = @"play_pm_normal";
    model0.name = @"iPad Pro";
    
    FollowModel *model1 = [[FollowModel alloc] init];
    model1.coverUrl = @"avatar_default";
    model1.title = @"目光所及，更显锋芒，显锋芒，锋芒，芒。";
    model1.imageUrl = @"gift_biaobaihuayu";
    model1.name = @"iMac";
    
    FollowModel *model2 = [[FollowModel alloc] init];
    model2.coverUrl = @"avatar_default2";
    model2.title = @"每一天，都可以更好。";
    model2.imageUrl = @"avatar_default2";
    model2.name = @"🍎WATCH";
    
    FollowModel *model3 = [[FollowModel alloc] init];
    model3.coverUrl = @"avatar_default";
    model3.title = @"迄今为止，iPhone 速度最高的芯片。[2 倍速度提升（与iPhone 6 相比），电池续航进一步提升。]";
    model3.imageUrl = @"avatar_default";
    model3.name = @"A10 Fusion 芯片";
    
    FollowModel *model4 = [[FollowModel alloc] init];
    model4.coverUrl = @"avatar_default2";
    model4.title = @"两个镜头，一拍，即合。";
    model4.imageUrl = @"avatar_default2";
    model4.name = @"iPhone 7 Plus 摄像头";
    
    FollowModel *model5 = [[FollowModel alloc] init];
    model5.coverUrl = @"avatar_default";
    model5.title = @"引得起火热目光，更经得起水花洗礼！";
    model5.imageUrl = @"play_gift_normal";
    model5.name = @"设计";
    
    FollowModel *model6 = [[FollowModel alloc] init];
    model6.coverUrl = @"avatar_default";
    model6.title = @"新款摄像头，就此亮相。";
    model6.imageUrl = @"gift_lanseyaoji";
    model6.name = @"iPhone 7 摄像头";
    
    if (_pageNum == 1) {
        [self.dataArr removeAllObjects];
        
        [self.dataArr addObject:model0];
        [self.dataArr addObject:model1];
        [self.dataArr addObject:model2];
        [self.dataArr addObject:model3];
    } else {
        [self.dataArr addObject:model4];
        [self.dataArr addObject:model5];
        [self.dataArr addObject:model6];
    }
    if (_pageNum == 1) {
        [self.collectionView.mj_header endRefreshing];
    } else {
        [self.collectionView.mj_footer endRefreshing];
    }
    
    // 刷新高度数据
    [self.heightArr removeAllObjects];
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
//        WaterFallCollectionLayout *layout = [[WaterFallCollectionLayout alloc] initWithItemsHeightBlock:^CGFloat(NSIndexPath *indexPath) {
//            return [self.heightArr[indexPath.row] floatValue];
//        }];
        
        WaterFallCollectionLayout *layout = [[WaterFallCollectionLayout alloc] init];
        layout.heightArr = self.heightArr;
        
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, HEIGHT - 64 - 49) collectionViewLayout:layout];
        _collectionView.backgroundColor = RGB(232, 232, 232);
        _collectionView.dataSource = self;
        _collectionView.delegate = self;
        [_collectionView registerClass:[FollowCell class] forCellWithReuseIdentifier:FollowCellID];
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
    FollowCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:FollowCellID forIndexPath:indexPath];
    cell.model = self.dataArr[indexPath.row];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    FollowModel *model = self.dataArr[indexPath.row];
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
