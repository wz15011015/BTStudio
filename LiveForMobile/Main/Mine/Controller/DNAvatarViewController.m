//
//  DNAvatarViewController.m
//  LiveForMobile
//
//  Created by  Sierra on 2017/8/7.
//  Copyright © 2017年 BaiFuTak. All rights reserved.
//

#import "DNAvatarViewController.h"

@interface DNAvatarViewController ()

@property (nonatomic, strong) UIImageView *avatarImageView;
@property (nonatomic, strong) UIButton *closeButton;

@end

@implementation DNAvatarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view addSubview:self.avatarImageView];
    [self.view addSubview:self.closeButton];
    
    
    // 812 = (44 + 44 + 645 + 49 + 30)   其中30 = (16 + 5 + 9)
//    UIView *statusBarView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 60, 44)];
//    statusBarView.backgroundColor = RGB(222, 81, 69);
//    [self.view addSubview:statusBarView];
//
//    UIView *navigationBarView = [[UIView alloc] initWithFrame:CGRectMake(65, 44, 80, 44)];
//    navigationBarView.backgroundColor = RGB(25, 161, 95);
//    [self.view addSubview:navigationBarView];
//
//    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(150, 88, 100, 645)];
//    view.backgroundColor = RGB(255, 206, 67);
//    [self.view addSubview:view];
//
//    UIView *tabBarView = [[UIView alloc] initWithFrame:CGRectMake(0, 733, 120, 49)];
//    tabBarView.backgroundColor = RGB(237, 239, 240);
//    [self.view addSubview:tabBarView];
//
//    UIView *newView = [[UIView alloc] initWithFrame:CGRectMake(125, 782, 140, 30)];
//    newView.backgroundColor = RGB(62, 175, 251);
//    [self.view addSubview:newView];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBarHidden = YES;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    self.navigationController.navigationBarHidden = NO;
}


#pragma mark - Getters

- (UIImageView *)avatarImageView {
    if (!_avatarImageView) {
        _avatarImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, HEIGHT * 0.56)];
    }
    return _avatarImageView;
}

- (UIButton *)closeButton {
    if (!_closeButton) {
        CGFloat h = 60 * HEIGHT_SCALE;
        _closeButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _closeButton.frame = CGRectMake(0, HEIGHT - h - 14.3, WIDTH, h);
        [_closeButton setImage:[UIImage imageNamed:@"close_avatarVC_20x20_"] forState:UIControlStateNormal];
        [_closeButton addTarget:self action:@selector(dismissViewController) forControlEvents:UIControlEventTouchUpInside];
    }
    return _closeButton;
}


#pragma mark - Setters

- (void)setAvatarImage:(UIImage *)avatarImage {
    _avatarImage = avatarImage;
    
    CGFloat ratioOfWH = avatarImage.size.width / avatarImage.size.height; // 原图的宽高比
    UIImage *scaledImage = [self scaleImage:avatarImage scaleToSize:CGSizeMake(WIDTH, WIDTH / ratioOfWH)];
    self.avatarImageView.image = scaledImage;
}


#pragma mark - Event

- (void)dismissViewController {
    [self dismissViewControllerAnimated:YES completion:nil];
}


#pragma mark - Tool Methods

/**
 缩放图片
 
 @param image 原图片
 @param size 缩放后图片
 */
- (UIImage *)scaleImage:(UIImage *)image scaleToSize:(CGSize)size {
    UIGraphicsBeginImageContext(size);
    [image drawInRect:CGRectMake(0, 0, size.width, size.height)];
    UIImage *scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return scaledImage;
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
