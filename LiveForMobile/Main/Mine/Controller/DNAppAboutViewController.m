//
//  DNAppAboutViewController.m
//  LiveForMobile
//
//  Created by  Sierra on 2017/8/7.
//  Copyright © 2017年 BaiFuTak. All rights reserved.
//

#import "DNAppAboutViewController.h"
#import "DNAppAboutCell.h"
#import "AZEmitterLayer.h"

@interface DNAppAboutViewController () <UITableViewDelegate, UITableViewDataSource, AZEmitterLayerDelegate>

@property (nonatomic, strong) UIView *headerView;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray *dataArr;

@property (nonatomic, strong) AZEmitterLayer *emitterLayer;

@end

@implementation DNAppAboutViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"关于大牛直播";
    
    [self addLeftBarButtonItem];
    
    // 1. 添加控件
    [self.view addSubview:self.tableView];
    self.tableView.tableHeaderView = self.headerView;
}


#pragma mark - Getters

- (UIView *)headerView {
    if (!_headerView) {
        CGFloat h = 212 * HEIGHT_SCALE;
        _headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, h)];
        _headerView.backgroundColor = RGB(242, 242, 242);
        
        CGFloat iconW = 126 * HEIGHT_SCALE;
        CGFloat iconX = (WIDTH - iconW) / 2;
        UIImageView *iconImageView = [[UIImageView alloc] initWithFrame:CGRectMake(iconX, 24 * HEIGHT_SCALE, iconW, iconW)];
//        iconImageView.layer.masksToBounds = YES;
//        iconImageView.layer.cornerRadius = 21 * WIDTH_SCALE;
//        iconImageView.image = [UIImage imageNamed:@"Icon"];
//        [_headerView addSubview:iconImageView];
        
        CGFloat labelY = CGRectGetMaxY(iconImageView.frame) + (21 * HEIGHT_SCALE);
        UILabel *versionLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, labelY, WIDTH - 30, 18)];
        versionLabel.font = [UIFont systemFontOfSize:14];
        versionLabel.textColor = RGB(116, 116, 116);
        versionLabel.textAlignment = NSTextAlignmentCenter;
        [_headerView addSubview:versionLabel];
        
        NSDictionary *infoDic = [[NSBundle mainBundle] infoDictionary];
        NSString *version = infoDic[@"CFBundleShortVersionString"];
        versionLabel.text = [NSString stringWithFormat:@"V %@", version];
        
        // 添加粒子发射器
        self.emitterLayer = [[AZEmitterLayer alloc] init];
        self.emitterLayer.bounds = _headerView.bounds;
        self.emitterLayer.position = CGPointMake(iconImageView.center.x, iconImageView.center.y);
        self.emitterLayer.beginPoint = CGPointMake(0, 20);
        self.emitterLayer.ignoredWhite = YES;
        self.emitterLayer.azDelegate = self;
        self.emitterLayer.image = [UIImage imageNamed:@"Icon_emitter_3"];
        [_headerView.layer addSublayer:self.emitterLayer];
    }
    return _headerView;
}

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, HEIGHT - 64)];
        _tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.backgroundColor = RGB(242, 242, 242); 
        [_tableView registerClass:[DNAppAboutCell class] forCellReuseIdentifier:DNAppAboutCellID];
    }
    return _tableView;
}

- (NSArray *)dataArr {
    if (!_dataArr) {
        _dataArr = @[@"用户协议", @"用户隐私协议", @"社区公约", @"文明公约", @"直播主播管理规范", @"直播社区用户违规管理规范", @"去官网", @"上传日志", @"联系我们"];
    }
    return _dataArr;
}


#pragma mark - UITableViewDelegate & UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArr.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return DN_APP_ABOUT_CELL_H;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    DNAppAboutCell *cell = [tableView dequeueReusableCellWithIdentifier:DNAppAboutCellID forIndexPath:indexPath];
    cell.title = self.dataArr[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}


#pragma mark - AZEmitterLayerDelegate

- (void)onAnimEnd {
    NSLog(@"粒子合成动画完成");
    
    [self.emitterLayer removeFromSuperlayer];
    
    CGFloat iconW = 126 * HEIGHT_SCALE;
    CGFloat iconX = (WIDTH - iconW) / 2;
    UIImageView *iconImageView = [[UIImageView alloc] initWithFrame:CGRectMake(iconX, 24 * HEIGHT_SCALE, iconW, iconW)];
    iconImageView.layer.masksToBounds = YES;
    iconImageView.layer.cornerRadius = 21 * WIDTH_SCALE;
    iconImageView.image = [UIImage imageNamed:@"Icon"];
    [self.headerView addSubview:iconImageView];
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
