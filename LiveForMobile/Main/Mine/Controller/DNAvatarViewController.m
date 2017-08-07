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
        _closeButton.frame = CGRectMake(0, HEIGHT - h, WIDTH, h);
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
