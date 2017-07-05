//
//  SnapShotShareView.m
//  LiveForMobile
//
//  Created by  Sierra on 2017/07/05.
//  Copyright © 2017年 BaiFuTak. All rights reserved.
//

#import "SnapShotShareView.h"
#import "BWMacro.h"
#import "ShareCell.h"
#import "ShareModel.h"

#define CONTENTVIEW_W (350 * WIDTH_SCALE)
#define CONTENTVIEW_H (590 * HEIGHT_SCALE)

@interface SnapShotShareView () <UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout> {
    CGFloat _width;
    CGFloat _height;
}
@property (nonatomic, strong) UIImageView *contentView;
@property (nonatomic, strong) UIButton *closeButton;
@property (nonatomic, strong) UIImageView *snapShotImageView;
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) NSArray *dataArr;

@end

@implementation SnapShotShareView

#pragma mark - Life cycle

- (id)init {
    if (self = [super init]) {
        [self initializeParameters];
        [self addSubViews];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        [self initializeParameters];
        [self addSubViews];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self initializeParameters];
        [self addSubViews];
    }
    return self;
}


#pragma mark - Methods

// 初始化
- (void)initializeParameters {
    _width = WIDTH;
    _height = HEIGHT;
    self.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.76];
    
    // 1. 分享平台
    ShareModel *model0 = [[ShareModel alloc] init];
    model0.name = @"朋友圈";
    model0.icon = @"share_icon_friends";
    
    ShareModel *model1 = [[ShareModel alloc] init];
    model1.name = @"微信";
    model1.icon = @"share_icon_wechat";
    
    ShareModel *model2 = [[ShareModel alloc] init];
    model2.name = @"QQ";
    model2.icon = @"share_icon_QQ";
    
    ShareModel *model3 = [[ShareModel alloc] init];
    model3.name = @"QQ空间";
    model3.icon = @"share_icon_Qzone";
    
    ShareModel *model4 = [[ShareModel alloc] init];
    model4.name = @"微博";
    model4.icon = @"share_icon_sina";
    
    self.dataArr = @[model0, model1, model2, model3, model4];
}

// 添加子控件
- (void)addSubViews {
    [self addSubview:self.contentView];
    
    // 动画效果
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.25];
    
    CGRect frame = self.contentView.frame;
    frame.size.width = CONTENTVIEW_W;
    frame.origin.x = (_width - CONTENTVIEW_W) / 2;
    self.contentView.frame = frame;
   
    [UIView commitAnimations];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.251 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self addSubview:self.closeButton];
        [self.contentView addSubview:self.snapShotImageView];
        [self.contentView addSubview:self.collectionView];
    });
}

// 移除子控件
- (void)removeSubviews {
    [self.closeButton removeFromSuperview];
    [self.snapShotImageView removeFromSuperview];
    [self.collectionView removeFromSuperview];
    [self.contentView removeFromSuperview];
}


#pragma mark - Public Methods

/**
 显示在view上
 */
- (void)showToView:(UIView *)view {
    [view addSubview:self];
    
    [self addSubViews]; 
}

/**
 移除view
 */
- (void)dismiss {
    [self.closeButton removeFromSuperview];
    [self.snapShotImageView removeFromSuperview];
    [self.collectionView removeFromSuperview];
    
    [UIView animateWithDuration:0.24 animations:^{
        CGRect frame = self.contentView.frame;
        frame.origin.y = _height / 2;
        frame.size.height = 0;
        self.contentView.frame = frame;
    } completion:^(BOOL finished) {
        if (self.dismissBlock) {
            self.dismissBlock();
        }
        
        [self.contentView removeFromSuperview];
        // 移除self
        [self removeFromSuperview];
    }];
    
}


#pragma mark - Event 



#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section { 
    return self.dataArr.count; 
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    ShareCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:ShareCellID forIndexPath:indexPath];
    cell.model = self.dataArr[indexPath.row];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
//    [self dismiss];
    
//    if (0 == indexPath.row) {
//        [[BWHUDHelper sharedInstance] showHUDMessageInKeyWindow:@"朋友圈 分享了主播"];
//    } else if (1 == indexPath.row) {
//        [[BWHUDHelper sharedInstance] showHUDMessageInKeyWindow:@"微信 分享了主播"];
//    } else if (2 == indexPath.row) {
//        [[BWHUDHelper sharedInstance] showHUDMessageInKeyWindow:@"QQ 分享了主播"];
//    } else if (3 == indexPath.row) {
//        [[BWHUDHelper sharedInstance] showHUDMessageInKeyWindow:@"QQ空间 分享了主播"];
//    } else if (4 == indexPath.row) {
//        [[BWHUDHelper sharedInstance] showHUDMessageInKeyWindow:@"微博 分享了主播"];
//    } 
    
    if (!self.snapShotImage) {
        self.snapShotImage = [UIImage imageNamed:@"Icon"];
    }
    NSArray *itemsArr = @[self.snapShotImage];
    UIActivityViewController *activityViewController = [[UIActivityViewController alloc] initWithActivityItems:itemsArr applicationActivities:nil];
    [self.parentViewController presentViewController:activityViewController animated:YES completion:nil];
}


#pragma mark - Getters

- (UIImageView *)contentView {
    if (!_contentView) {
        CGFloat y = (_height - CONTENTVIEW_H) / 2;
        _contentView = [[UIImageView alloc] initWithFrame:CGRectMake(_width / 2, y, 0, CONTENTVIEW_H)];
        _contentView.image = [UIImage imageNamed:@"play_snapshot_background"];
        _contentView.userInteractionEnabled = YES;
    }
    return _contentView;
}

- (UIButton *)closeButton {
    if (!_closeButton) {
        CGFloat w = 44;
        CGFloat x = CGRectGetMaxX(self.contentView.frame) - (w * 0.5);
        CGFloat y = CGRectGetMinY(self.contentView.frame) - (w * 0.5);
        _closeButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _closeButton.frame = CGRectMake(x, y, w, w);
        [_closeButton setImage:[UIImage imageNamed:@"push_close"] forState:UIControlStateNormal];
        [_closeButton addTarget:self action:@selector(dismiss) forControlEvents:UIControlEventTouchUpInside];
    }
    return _closeButton;
}

- (UIImageView *)snapShotImageView {
    if (!_snapShotImageView) {
        CGFloat y = 12;
        CGFloat x = 12;
        CGFloat w = CGRectGetWidth(self.contentView.frame) - (2 * x);
        CGFloat h = CGRectGetHeight(self.contentView.frame) * 0.75;
        _snapShotImageView = [[UIImageView alloc] initWithFrame:CGRectMake(x, y, w, h)];
        _snapShotImageView.backgroundColor = [UIColor whiteColor];
    }
    return _snapShotImageView;
}

- (UICollectionView *)collectionView {
    if (!_collectionView) {
        CGFloat w = CGRectGetWidth(self.contentView.frame);
        CGFloat y = CGRectGetMaxY(self.snapShotImageView.frame) + (22 * HEIGHT_SCALE);
        CGFloat h = CGRectGetHeight(self.contentView.frame) - y;
        
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        flowLayout.itemSize = CGSizeMake(SHARE_CELL_W, SHARE_CELL_H);
        flowLayout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
        flowLayout.minimumLineSpacing = 0;
        flowLayout.minimumInteritemSpacing = 0;
        
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, y, w, h) collectionViewLayout:flowLayout];
        _collectionView.backgroundColor = [UIColor clearColor];
        _collectionView.showsHorizontalScrollIndicator = NO;
        _collectionView.dataSource = self;
        _collectionView.delegate = self;
        [_collectionView registerClass:[ShareCell class] forCellWithReuseIdentifier:ShareCellID]; 
    }
    return _collectionView;
}

- (NSArray *)dataArr {
    if (!_dataArr) {
        _dataArr = [NSArray array];
    }
    return _dataArr;
}


#pragma mark - Setters

- (void)setSnapShotImage:(UIImage *)snapShotImage {
    _snapShotImage = snapShotImage;
    
    self.snapShotImageView.image = snapShotImage;
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
