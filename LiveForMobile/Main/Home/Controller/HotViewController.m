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
        
//        [_dataArr addObject:@"1"];
//        [_dataArr addObject:@"1"];
//        [_dataArr addObject:@"1"];
//        [_dataArr addObject:@"1"];
//        [_dataArr addObject:@"1"];
    }
    return _dataArr;
}


#pragma mark - Life Cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    // 1. 添加控件
    [self.view addSubview:self.tableView];
    
    [self loadData];
}


#pragma mark - Load Data
- (void)loadData {
    LiveListModel *model0 = [[LiveListModel alloc] init];
    model0.list_user_head = @"http://img2.inke.cn/MTQ5NzA5MTU4MTQ4MSM1MjMjanBn.jpg";
    model0.list_user_name = @"丫头👧";
    model0.list_pic = @"http://img2.inke.cn/MTQ5NzA5MTU4MTQ4MSM1MjMjanBn.jpg";
    
    LiveListModel *model1 = [[LiveListModel alloc] init];
    model1.list_user_head = @"http://img2.inke.cn/MTQ5MzU1NTk2MzUxMCM3NTQjanBn.jpg";
    model1.list_user_name = @"凡爷是个女子吖";
    model1.list_pic = @"http://img2.inke.cn/MTQ5MzU1NTk2MzUxMCM3NTQjanBn.jpg";
    
    LiveListModel *model2 = [[LiveListModel alloc] init];
    model2.list_user_head = @"http://img2.inke.cn/MTUwMzE0NjUzMjY5NSM1MDEjanBn.jpg";
    model2.list_user_name = @"小🎱";
    model2.list_pic = @"http://img2.inke.cn/MTUwMzE0NjUzMjY5NSM1MDEjanBn.jpg";
    
    LiveListModel *model3 = [[LiveListModel alloc] init];
    model3.list_user_head = @"http://img2.inke.cn/MTUwMTc1MDk1MTc3MCM1OTQjanBn.jpg";
    model3.list_user_name = @"我是模特小怪兽电台🎤";
    model3.list_pic = @"http://img2.inke.cn/MTUwMTc1MDk1MTc3MCM1OTQjanBn.jpg";
    
    [self.dataArr addObject:model0];
    [self.dataArr addObject:model1];
    [self.dataArr addObject:model2];
    [self.dataArr addObject:model3];
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
#warning 调试代码
    if (indexPath.row == 1) {
        BWPlayViewController *playVC = [[BWPlayViewController alloc] init];
        playVC.rtmpURL = @"rtmp://pull.inke.cn/live/1503303629325732";
        playVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:playVC animated:YES];
        
    } else if (indexPath.row == 2) {
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
