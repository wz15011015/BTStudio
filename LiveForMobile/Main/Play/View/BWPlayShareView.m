//
//  BWPlayShareView.m
//  LiveForMobile
//
//  Created by  Sierra on 2017/6/27.
//  Copyright © 2017年 BaiFuTak. All rights reserved.
//

#import "BWPlayShareView.h"
#import "BWMacro.h"
#import "ShareCell.h"
#import "ShareModel.h"

#define CONTENTVIEW_H (120)

@interface BWPlayShareView () <UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout> {
    CGFloat _width;
    CGFloat _height;
}
@property (nonatomic, strong) UIView *blankView; // 空白view
@property (nonatomic, strong) UIView *contentView;
@property (nonatomic, strong) UIButton *titleButton;
@property (nonatomic, strong) UIView *separatorLineView;
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) NSArray *dataArr;

@end

@implementation BWPlayShareView

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
        _width = frame.size.width;
        _height = frame.size.height;
        
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
    [self addSubview:self.blankView];
    [self addSubview:self.contentView];
    [self.contentView addSubview:self.titleButton];
    [self.contentView addSubview:self.separatorLineView];
    [self.contentView addSubview:self.collectionView];
    
    // 动画效果
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.25];
    
    CGRect frame = self.contentView.frame;
    frame.origin.y = HEIGHT - frame.size.height;
    self.contentView.frame = frame;
    
    [UIView commitAnimations];
}

// 移除子控件
- (void)removeSubviews {
    [self.blankView removeFromSuperview];
    [self.contentView removeFromSuperview];
}


#pragma mark - Public Methods

/**
 显示在view上
 */
- (void)showToView:(UIView *)view {
    [view addSubview:self]; 
}

/**
 移除view
 */
- (void)dismiss {
    [UIView animateWithDuration:0.25 animations:^{
        CGRect frame = self.contentView.frame;
        frame.origin.y = HEIGHT;
        self.contentView.frame = frame;
        
    } completion:^(BOOL finished) {
        if (finished) {
            [self removeSubviews];
            
            // 移除self
            [self removeFromSuperview];
        }
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
    [self dismiss];
    
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
    
    NSArray *itemsArr = @[[NSURL URLWithString:@"https://20994.mpull.live.lecloud.com/live/leshiTest/desc.m3u8?&tm=20170627094926&sign=f190180247eb94c8db6f8b49177e83d9"]];
    UIActivityViewController *activityViewController = [[UIActivityViewController alloc] initWithActivityItems:itemsArr applicationActivities:nil];
    activityViewController.excludedActivityTypes = @[UIActivityTypeMessage, UIActivityTypeMail, UIActivityTypeAddToReadingList];
    [self.parentViewController presentViewController:activityViewController animated:YES completion:nil];
}


#pragma mark - Getters

- (UIView *)blankView {
    if (!_blankView) {
        CGFloat h = HEIGHT - CONTENTVIEW_H;
        _blankView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, _width, h)];
        _blankView.backgroundColor = [UIColor clearColor];
        
        // 添加点击手势
        UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismiss)];
        [_blankView addGestureRecognizer:tapGestureRecognizer];
    }
    return _blankView;
}

- (UIView *)contentView {
    if (!_contentView) {
        _contentView = [[UIView alloc] initWithFrame:CGRectMake(0, HEIGHT, _width, CONTENTVIEW_H)];
        _contentView.backgroundColor = [UIColor colorWithWhite:1.0 alpha:1.0];
    }
    return _contentView;
}

- (UIButton *)titleButton {
    if (!_titleButton) {
        CGFloat h = 30;
        _titleButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _titleButton.frame = CGRectMake(0, 0, _width, h);
        _titleButton.titleLabel.font = [UIFont systemFontOfSize:14];
        [_titleButton setTitle:@"分享主播" forState:UIControlStateNormal];
        [_titleButton setTitleColor:RGB(20, 20, 19) forState:UIControlStateNormal];
    }
    return _titleButton;
}

- (UIView *)separatorLineView {
    if (!_separatorLineView) {
        CGFloat y = CGRectGetMaxY(self.titleButton.frame);
        _separatorLineView = [[UIView alloc] initWithFrame:CGRectMake(0, y, _width, 1)];
        _separatorLineView.backgroundColor = RGB(230, 230, 230);
    }
    return _separatorLineView;
}

- (UICollectionView *)collectionView {
    if (!_collectionView) {
        CGFloat y = CGRectGetMaxY(self.separatorLineView.frame);
        CGFloat h = CGRectGetHeight(self.contentView.frame) - y;
        
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
        flowLayout.itemSize = CGSizeMake(SHARE_CELL_W, SHARE_CELL_H);
        flowLayout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
        flowLayout.minimumLineSpacing = 0;
        flowLayout.minimumInteritemSpacing = 0;
        
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, y, _width, h) collectionViewLayout:flowLayout];
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


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
