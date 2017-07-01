//
//  GiftCell.m
//  LiveForMobile
//
//  Created by  Sierra on 2017/6/28.
//  Copyright © 2017年 BaiFuTak. All rights reserved.
//

#import "GiftCell.h"

NSString *const GiftCellID = @"GiftCellIdentifier";
NSString *const SingleGiftCellID = @"SingleGiftCellIdentifier";

@interface GiftCell () <UICollectionViewDelegateFlowLayout, UICollectionViewDelegate, UICollectionViewDataSource>

@property (nonatomic, strong) UICollectionView *collectionView;

@end

@implementation GiftCell

#pragma mark - Life cycle

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self.contentView addSubview:self.collectionView];
    }
    return self;
}


#pragma mark - Getters

- (UICollectionView *)collectionView {
    if (!_collectionView) {
        CGFloat y = GIFT_CELL_TOP_MARGIN;
        CGFloat h = GIFT_CELL_H - (2 * y);
        
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
        flowLayout.itemSize = CGSizeMake(SINGLEGIFT_CELL_W, SINGLEGIFT_CELL_H);
        flowLayout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
        flowLayout.minimumLineSpacing = 0;
        flowLayout.minimumInteritemSpacing = 0;
        
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, y, WIDTH, h) collectionViewLayout:flowLayout];
        _collectionView.backgroundColor = [UIColor clearColor];
        _collectionView.showsHorizontalScrollIndicator = NO;
        _collectionView.dataSource = self;
        _collectionView.delegate = self;
        [_collectionView registerClass:[SingleGiftCell class] forCellWithReuseIdentifier:SingleGiftCellID];
    }
    return _collectionView;
}


#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.dataArr.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    SingleGiftCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:SingleGiftCellID forIndexPath:indexPath];
    cell.model = @"";
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (self.selectGiftBlock) {
        self.selectGiftBlock();
    }
}


#pragma mark - Setters

- (void)setDataArr:(NSMutableArray *)dataArr {
    _dataArr = dataArr;
    
    [self.collectionView reloadData];
}

@end



/**
 单个礼物 Cell
 */
@interface SingleGiftCell ()

@property (nonatomic, strong) UIImageView *iconImageView; // 礼物图标
@property (nonatomic, strong) UILabel *nameLabel; // 礼物名称
@property (nonatomic, strong) UILabel *priceLabel; // 礼物价格
@property (nonatomic, strong) UIImageView *selectedImageView; // 选择时的图标

@end

@implementation SingleGiftCell

#pragma mark - Life cycle

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self.contentView addSubview:self.iconImageView];
        [self.contentView addSubview:self.nameLabel];
        [self.contentView addSubview:self.priceLabel];
//        [self.contentView addSubview:self.selectedImageView];
//        self.selectedImageView.hidden = YES;
        
        self.selectedBackgroundView = self.selectedImageView;
    }
    return self;
}


#pragma mark - Getters

- (UIImageView *)iconImageView {
    if (!_iconImageView) {
        CGFloat y = 1;
        CGFloat w = SINGLEGIFT_CELL_W * 0.56;
        CGFloat x = (SINGLEGIFT_CELL_W - w) / 2.0;
        _iconImageView = [[UIImageView alloc] initWithFrame:CGRectMake(x, y, w, w)];
        _iconImageView.image = [UIImage imageNamed:@"gift_langmangaobai"];
    }
    return _iconImageView;
}

- (UILabel *)nameLabel {
    if (!_nameLabel) {
        CGFloat y = CGRectGetMaxY(self.iconImageView.frame) + 2;
        CGFloat h = 14;
        _nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, y, SINGLEGIFT_CELL_W, h)];
        _nameLabel.textColor = [UIColor whiteColor];
        _nameLabel.font = [UIFont systemFontOfSize:11];
        _nameLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _nameLabel;
}

- (UILabel *)priceLabel {
    if (!_priceLabel) {
        CGFloat y = CGRectGetMaxY(self.nameLabel.frame);
        CGFloat h = 12;
        _priceLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, y, SINGLEGIFT_CELL_W, h)];
        _priceLabel.textColor = RGB(93, 92, 89);
        _priceLabel.font = [UIFont systemFontOfSize:9];
        _priceLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _priceLabel;
}

- (UIImageView *)selectedImageView {
    if (!_selectedImageView) {
        _selectedImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, SINGLEGIFT_CELL_W, SINGLEGIFT_CELL_W)];
        _selectedImageView.layer.borderColor = RGB(245, 29, 93).CGColor;
        _selectedImageView.layer.borderWidth = 1.2;
    }
    return _selectedImageView;
}


#pragma mark - Setters

- (void)setModel:(NSString *)model {
    _model = model;
    
    int random = arc4random() % 10;
    if (random > 7) {
        self.iconImageView.image = [UIImage imageNamed:@"gift_langmangaobai"];
        self.nameLabel.text = @"浪漫告白";
        self.priceLabel.text = [NSString stringWithFormat:@"%@币", @"214"];
    } else if (random > 4) {
        self.iconImageView.image = [UIImage imageNamed:@"gift_biaobaihuayu"];
        self.nameLabel.text = @"表白花语";
        self.priceLabel.text = [NSString stringWithFormat:@"%@币", @"369"];
    } else {
        self.iconImageView.image = [UIImage imageNamed:@"gift_lanseyaoji"];
        self.nameLabel.text = @"爱神蓝色妖姬";
        self.priceLabel.text = [NSString stringWithFormat:@"%@币", @"19999"];
    }
}

@end
