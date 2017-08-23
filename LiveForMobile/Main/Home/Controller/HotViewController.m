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
#import "LiveListModel.h"

@interface HotViewController () <UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataArr;

#warning 调试代码
@property (nonatomic, strong) UIAlertAction *sureAction;

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
    }
    return _dataArr;
}


#pragma mark - Life Cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    // 1. 添加控件
    [self.view addSubview:self.tableView];
    
    // 2. 加载数据
    [self loadData];
}


#pragma mark - Load Data
- (void)loadData {
    LiveListModel *model0 = [[LiveListModel alloc] init];
    model0.list_user_head = @"http://img2.inke.cn/MTUwMjA2NzQxMzMzNCM1MDcjanBn.jpg";
    model0.list_user_name = @"🍦冰淇淋🍷";
    model0.list_pic = @"http://img2.inke.cn/MTUwMjA2NzQxMzMzNCM1MDcjanBn.jpg";
    model0.play_url = @"rtmp://pull99.inke.cn/live/1503466289196679";
    model0.live_status = @"1";
    model0.rank = @"2";
    model0.address = @"江苏 苏州";
    model0.audience_num = @"1140";
    model0.title = @"相守不易,且行且珍惜!";
    
    LiveListModel *model1 = [[LiveListModel alloc] init];
    model1.list_user_head = @"http://img2.inke.cn/MTQ5MzU1NTk2MzUxMCM3NTQjanBn.jpg";
    model1.list_user_name = @"凡爷是个女子吖";
    model1.list_pic = @"http://img2.inke.cn/MTQ5MzU1NTk2MzUxMCM3NTQjanBn.jpg";
    model1.play_url = @"rtmp://pull.inke.cn/live/1503303629325732";
    model1.live_status = @"1";
    model1.rank = @"1";
    model1.address = @"北京 朝阳";
    model1.audience_num = @"800";
    model1.title = @"遇见你是我的缘";
    
    LiveListModel *model2 = [[LiveListModel alloc] init];
    model2.list_user_head = @"http://img2.inke.cn/MTUwMzE0NjUzMjY5NSM1MDEjanBn.jpg";
    model2.list_user_name = @"小🎱";
    model2.list_pic = @"http://img2.inke.cn/MTUwMzE0NjUzMjY5NSM1MDEjanBn.jpg";
    model2.play_url = @"rtmp://pull.inke.cn/live/1503303629325732";
    model2.live_status = @"1";
    model2.rank = @"0";
    model2.address = @"北京 东城";
    model2.audience_num = @"600";
    model2.title = @"深情不及久伴,有你们真好❤️";
    
    LiveListModel *model3 = [[LiveListModel alloc] init];
    model3.list_user_head = @"http://img2.inke.cn/MTUwMTc1MDk1MTc3MCM1OTQjanBn.jpg";
    model3.list_user_name = @"我是模特小怪兽电台🎤";
    model3.list_pic = @"http://img2.inke.cn/MTUwMTc1MDk1MTc3MCM1OTQjanBn.jpg";
    model3.play_url = @"rtmp://pull.inke.cn/live/1503303629325732";
    model3.live_status = @"1";
    model3.rank = @"2";
    model3.address = @"辽宁 沈阳";
    model3.audience_num = @"500";
    model3.title = @"从小到大唯一没变的就是: 一直酷爱剪刀手✌️";
    
    LiveListModel *model4 = [[LiveListModel alloc] init];
    model4.list_user_head = @"http://img2.inke.cn/MTUwMTQ4ODQ2NjkzNiMyNDQjanBn.jpg";
    model4.list_user_name = @"✨思瑜✨唱歌主播努力500w";
    model4.list_pic = @"http://img2.inke.cn/MTUwMTQ4ODQ2NjkzNiMyNDQjanBn.jpg";
    model4.play_url = @"rtmp://pull.inke.cn/live/1503364179298020";
    model4.live_status = @"1";
    model4.rank = @"2";
    model4.address = @"吉林 长春";
    model4.audience_num = @"700";
    model4.title = @"你猜我到底猜你猜不猜😆";
    
    [self.dataArr addObject:model0];
    [self.dataArr addObject:model1];
    [self.dataArr addObject:model2];
    [self.dataArr addObject:model3];
    [self.dataArr addObject:model4];
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
    cell.indexPath = indexPath;
    cell.model = self.dataArr[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    LiveListModel *model = self.dataArr[indexPath.row];
    
#warning 调试代码
    if (indexPath.row == 2) {
        UIAlertController *alertC = [UIAlertController alertControllerWithTitle:@"请输入拉流地址" message:nil preferredStyle:UIAlertControllerStyleAlert];
        [alertC addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
            textField.delegate = self;
            textField.returnKeyType = UIReturnKeyGo;
            NSLog(@"请输入拉流地址");
        }];
        self.sureAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
            UITextField *textField = alertC.textFields.firstObject;
            NSString *rtmpURL = textField.text;
            if (rtmpURL.length == 0 || [rtmpURL isEqualToString:@""]) {
                return;
            }
            
            BWPlayViewController *playVC = [[BWPlayViewController alloc] init];
            playVC.model = model;
            playVC.rtmpURL = rtmpURL;
            playVC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:playVC animated:YES];
        }];
        self.sureAction.enabled = NO;
        [alertC addAction:self.sureAction];
        [alertC addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
        [self presentViewController:alertC animated:YES completion:nil];
#warning 调试代码
        
    } else {
        BWPlayViewController *playVC = [[BWPlayViewController alloc] init];
        playVC.model = model;
        playVC.rtmpURL = model.play_url;
        playVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:playVC animated:YES];
    }
}


#warning 调试代码

#pragma mark - UITextFieldDelegate 

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if (textField.text.length > 0) {
        self.sureAction.enabled = YES;
    } else {
        self.sureAction.enabled = NO;
    }
    return YES;
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
