//
//  MineMVViewController.m
//  LiveForMobile
//
//  Created by  Sierra on 2017/8/15.
//  Copyright © 2017年 BaiFuTak. All rights reserved.
//

#import "MineMVViewController.h"

@interface MineMVViewController ()

@property (nonatomic, strong) UIImageView *placeholderImageView;

@property (nonatomic, strong) UILabel *placeholderLabel;

@property (nonatomic, strong) UIButton *tipButton;

@end

@implementation MineMVViewController

#pragma mark - Getters

- (UIImageView *)placeholderImageView {
    if (!_placeholderImageView) {
        CGFloat w = 179 * WIDTH_SCALE;
        CGFloat h = 85 * HEIGHT_SCALE;
        CGFloat x = (WIDTH - w) / 2;
        _placeholderImageView = [[UIImageView alloc] initWithFrame:CGRectMake(x, 150 * HEIGHT_SCALE, w, h)];
        _placeholderImageView.image = [UIImage imageNamed:@"attention_state_empty_127x60_"];
    }
    return _placeholderImageView;
}

- (UILabel *)placeholderLabel {
    if (!_placeholderLabel) {
        CGFloat x = 15 * WIDTH_SCALE;
        CGFloat w = WIDTH - 2 * x;
        _placeholderLabel = [[UILabel alloc] initWithFrame:CGRectMake(x, CGRectGetMaxY(self.placeholderImageView.frame) + (26 * HEIGHT_SCALE), w, 44)];
        _placeholderLabel.textAlignment = NSTextAlignmentCenter;
        _placeholderLabel.font = [UIFont systemFontOfSize:14];
        _placeholderLabel.textColor = RGB(123, 123, 123);
        _placeholderLabel.numberOfLines = 0;
        _placeholderLabel.text = @"您还没有生成MV~快来开播，点击直播间下方的音乐图标，尽情欢唱吧！";
    }
    return _placeholderLabel;
}

- (UIButton *)tipButton {
    if (!_tipButton) {
        CGFloat w = 143 * WIDTH_SCALE;
        CGFloat h = 40 * HEIGHT_SCALE;
        CGFloat x = (WIDTH - w) / 2;
        CGFloat y = CGRectGetMaxY(self.placeholderLabel.frame) + (30 * HEIGHT_SCALE);
        _tipButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _tipButton.frame = CGRectMake(x, y, w, h);
        _tipButton.titleLabel.font = [UIFont systemFontOfSize:15];
        [_tipButton setTitle:@"去开播" forState:UIControlStateNormal];
        [_tipButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_tipButton setBackgroundImage:[UIImage imageNamed:@"anniu_150x44_"] forState:UIControlStateNormal];
        [_tipButton setBackgroundImage:[UIImage imageNamed:@"anniu press_150x44_"] forState:UIControlStateHighlighted];
        [_tipButton addTarget:self action:@selector(buttonEvent) forControlEvents:UIControlEventTouchUpInside];
    }
    return _tipButton;
}


#pragma mark - Life Cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"我的MV";
    
    [self addLeftBarButtonItem];
    
    // 添加子控件
    [self.view addSubview:self.placeholderImageView];
    [self.view addSubview:self.placeholderLabel];
    [self.view addSubview:self.tipButton];
}


#pragma mark - Events

- (void)buttonEvent {
    NSLog(@"去开播");
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
