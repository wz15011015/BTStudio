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

@interface HotViewController () <UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate> {
    NSInteger _pageNum;  // 当前请求的分页页码数
}

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
    
    // 0. 初始化
    _pageNum = 1;
    
    // 1. 添加控件
    [self.view addSubview:self.tableView];
    // 上下拉刷新
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        _pageNum = 1;
        [self loadData2];
    }];
    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        _pageNum += 1;
        [self loadData2];
    }];
    
    // 2. 加载数据
//    [self loadData];
    [self loadData2];
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

- (void)loadData2 {
    NSString *urlStr = @"http://www.inke.cn/hotlive_list.html";
    if (_pageNum == 1) {
        urlStr = @"http://www.inke.cn/hotlive_list.html";
    } else {
        urlStr = [NSString stringWithFormat:@"http://www.inke.cn/hotlive_list.html?page=%ld", _pageNum];
    }
    
    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc] init];
    manager.responseSerializer = [[AFHTTPResponseSerializer alloc] init];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html", nil];
    [manager GET:urlStr parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSString *htmlStr = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        
        // 从html中抓取主播头像/名称/城市/观众数量/直播介绍/id
        [self scratchFromHtml:htmlStr];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"请求失败, error = %@", error);
    }];
}

/**
 匹配字符串string中的模式pattern

 @param string 要匹配的字符串
 @param pattern 模式字符串
 @return 匹配结果数组
 */
- (NSArray *)matchesInString:(NSString *)string withPattern:(NSString *)pattern options:(NSRegularExpressionOptions)options {
    // 匹配结果数组(字符串数组)
    NSMutableArray *resultArr = [NSMutableArray array];
    
    // 1. 创建正则表达式
    NSError *error = nil;
    NSRegularExpression *regex = [[NSRegularExpression alloc] initWithPattern:pattern options:options error:&error];
    if (error) {
        NSLog(@"模式为: %@ 的正则表达式无效", pattern);
        return nil;
    }
    // 2. 匹配模式,获取结果
    NSArray *matchResults = [regex matchesInString:string options:NSMatchingReportCompletion range:NSMakeRange(0, string.length)];
    if (matchResults.count == 0) {
        NSLog(@"未匹配到结果");
    } else {
        for (int i = 0; i < matchResults.count; i++) {
            NSTextCheckingResult *result = matchResults[i];
            NSString *resultStr = [string substringWithRange:result.range];
            [resultArr addObject:resultStr];
        }
    }
    return resultArr;
}

/**
 从html中抓取想要的内容
 
 @param htmlStr html代码
 */
- (void)scratchFromHtml:(NSString *)htmlStr {
    // 1. html代码
    NSLog(@"html代码:\n%@", htmlStr);
    
    // 2. 从html代码中根据模式字符串抓取内容
    // 模式字符串
    NSString *pattern1 = @"<div class=\"list_panel_bd clearfix\">.*<div class=\"nodata_wrapper\">";
    NSArray *matchResultArr1 = [self matchesInString:htmlStr withPattern:pattern1 options:NSRegularExpressionDotMatchesLineSeparators];
    if (matchResultArr1.count == 0) {
        NSLog(@"1 未匹配到结果");
        return;
    }
    NSString *tempStr1 = matchResultArr1[0];
    
    // 3. 获取主播头像地址
    NSMutableArray *imageURLArr = [NSMutableArray array];
    NSString *pattern2 = @"<img src=\"([a-zA-Z0-9:/%\\.\?]*)url=([a-zA-Z0-9:/%\\.]*).jpg&w";
    NSArray *matchResultArr2 = [self matchesInString:tempStr1 withPattern:pattern2 options:NSRegularExpressionDotMatchesLineSeparators];
    if (matchResultArr2.count == 0) {
        NSLog(@"2 未匹配到结果");
    }
    for (int i = 0; i < matchResultArr2.count; i++) {
        NSString *tempStr = matchResultArr2[i];
        // 剔除末尾"&w"两个字符
        tempStr = [tempStr substringToIndex:tempStr.length - 2];
        // 截取图片地址
        NSRange range = [tempStr rangeOfString:@"url="];
        tempStr = [tempStr substringFromIndex:range.location + range.length];
        // 把字符串中的URL转义字符转成字符
        NSString *imageURL = [tempStr stringByRemovingPercentEncoding];
        [imageURLArr addObject:imageURL];
    }
    
    // 4. 获取主播名称
    NSMutableArray *nameArr = [NSMutableArray array];
    NSString *pattern3 = @"<span class=\"list_user_name\">(.*)</span>";
    NSArray *matchResultArr3 = [self matchesInString:tempStr1 withPattern:pattern3 options:NSRegularExpressionCaseInsensitive];
    if (matchResultArr3.count == 0) {
        NSLog(@"3 未匹配到结果");
    }
    for (int i = 0; i < matchResultArr3.count; i++) {
        NSString *tempStr = matchResultArr3[i];
        // 截取名称
        tempStr = [tempStr substringWithRange:NSMakeRange(29, tempStr.length - 29 - 7)];
        [nameArr addObject:tempStr];
    }
    
    // 5. 获取主播的观众数量
    NSMutableArray *auidenceNumArr = [NSMutableArray array];
    NSString *pattern4 = @"<span>([0-9]+)</span>";
    NSArray *matchResultArr4 = [self matchesInString:tempStr1 withPattern:pattern4 options:NSRegularExpressionCaseInsensitive];
    if (matchResultArr4.count == 0) {
        NSLog(@"4 未匹配到结果");
    }
    for (int i = 0; i < matchResultArr4.count; i++) {
        NSString *tempStr = matchResultArr4[i];
        // 截取观众数量
        tempStr = [tempStr substringWithRange:NSMakeRange(6, tempStr.length - 6 - 7)];
        [auidenceNumArr addObject:tempStr];
    }
    
    // 6. 获取主播的城市名称
    NSMutableArray *addressArr = [NSMutableArray array];
    NSString *pattern5 = @"\"hot_tag\">([\u4e00-\u9fa5]+)市</a>";
    NSArray *matchResultArr5 = [self matchesInString:tempStr1 withPattern:pattern5 options:NSRegularExpressionCaseInsensitive];
    if (matchResultArr5.count == 0) {
        NSLog(@"5 未匹配到结果");
    }
    for (int i = 0; i < matchResultArr5.count; i++) {
        NSString *tempStr = matchResultArr5[i];
        // 截取城市名称
        tempStr = [tempStr substringWithRange:NSMakeRange(10, tempStr.length - 10 - 4)];
        [addressArr addObject:tempStr];
    }
    
    // 7. 获取直播的介绍内容
    NSMutableArray *introArr = [NSMutableArray array];
    NSString *pattern6 = @"\"list_intro\"><p>(.*)</p></div>";
    NSArray *matchResultArr6 = [self matchesInString:tempStr1 withPattern:pattern6 options:NSRegularExpressionCaseInsensitive];
    if (matchResultArr6.count == 0) {
        NSLog(@"6 未匹配到结果");
    }
    for (int i = 0; i < matchResultArr6.count; i++) {
        NSString *tempStr = matchResultArr6[i];
        // 截取直播介绍
        tempStr = [tempStr substringWithRange:NSMakeRange(16, tempStr.length - 16 - 10)];
        [introArr addObject:tempStr];
    }
    
    // 8. 获取直播的id
    NSMutableArray *idArr = [NSMutableArray array];
    NSString *pattern7 = @"uid=[0-9]+&id=[0-9]+\">";
    NSArray *matchResultArr7 = [self matchesInString:tempStr1 withPattern:pattern7 options:NSRegularExpressionCaseInsensitive];
    if (matchResultArr7.count == 0) {
        NSLog(@"7 未匹配到结果");
    }
    for (int i = 0; i < matchResultArr7.count; i++) {
        NSString *tempStr = matchResultArr7[i];
        // 截取直播的id
        NSRange range = [tempStr rangeOfString:@"&id="];
        tempStr = [tempStr substringWithRange:NSMakeRange(range.location + range.length, tempStr.length - range.location - range.length - 2)];
        [idArr addObject:tempStr];
    }
    
    
    // 刷新数据
    if (_pageNum == 1) {
        [self.dataArr removeAllObjects];
    }
    for (int i = 0; i < imageURLArr.count; i++) {
        NSString *imageURL = imageURLArr[i];
        NSString *name = @"";
        NSString *auidenceNum = @"0";
        NSString *address = @"";
        NSString *intro = @"";
        NSString *idStr = @"";
        
        if (i < nameArr.count) {
            name = nameArr[i];
        }
        if (i < auidenceNumArr.count) {
            auidenceNum = auidenceNumArr[i];
        }
        if (i < addressArr.count) {
            address = addressArr[i];
        }
        if (i < introArr.count) {
            intro = introArr[i];
        }
        if (i < idArr.count) {
            idStr = idArr[i];
        }
        
        LiveListModel *model = [[LiveListModel alloc] init];
        model.list_user_head = imageURL;
        model.list_user_name = name;
        model.list_pic = imageURL;
        model.play_url = [NSString stringWithFormat:@"rtmp://pull99.inke.cn/live/%@", idStr];
        model.live_status = @"1";
        model.rank = i % 2 ? @"2" : @"1";
        model.address = address;
        model.audience_num = auidenceNum;
        model.title = intro;
        [self.dataArr addObject:model];
    }
    if (_pageNum == 1) {
        [self.tableView.mj_header endRefreshing];
    } else {
        [self.tableView.mj_footer endRefreshing];
    }
    [self.tableView reloadData];
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
