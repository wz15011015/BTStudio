//
//  FilterCell.m
//  LiveForMobile
//
//  Created by  Sierra on 2017/6/23.
//  Copyright © 2017年 BaiFuTak. All rights reserved.
//

#import "FilterCell.h"
#import "FilterModel.h"

NSString *const FilterCellID = @"FilterCellIdentifier";

@interface FilterCell ()

@property (nonatomic, strong) UIImageView *iconImageView; // 滤镜的图标

@property (nonatomic, strong) UIImageView *maskImageView; // 遮罩图片

@property (nonatomic, strong) UILabel *nameLabel; // 滤镜名称Label

@end

@implementation FilterCell

#pragma mark - Life cycle

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self.contentView addSubview:self.iconImageView];
        [self.contentView addSubview:self.maskImageView];
        [self.contentView addSubview:self.nameLabel];
    }
    return self;
}


#pragma mark - Getters

- (UIImageView *)iconImageView {
    if (!_iconImageView) {
        CGFloat x = 8;
        CGFloat w = FILTERCELLW - (2 * x);
        _iconImageView = [[UIImageView alloc] initWithFrame:CGRectMake(9, 15, w, w)];
        _iconImageView.image = [UIImage imageNamed:@"filter_icon_original"];
    }
    return _iconImageView;
}

- (UIImageView *)maskImageView {
    if (!_maskImageView) {
        _maskImageView = [[UIImageView alloc] initWithFrame:self.iconImageView.frame];
        _maskImageView.image = [UIImage imageNamed:@"filter_selected"];
    }
    return _maskImageView;
}

- (UILabel *)nameLabel {
    if (!_nameLabel) {
        CGFloat y = CGRectGetMaxY(self.iconImageView.frame);
        CGFloat h = FILTERCELLH - y;
        _nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, y, FILTERCELLW, h)];
        _nameLabel.font = [UIFont systemFontOfSize:13];
        _nameLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _nameLabel;
}


#pragma mark - Setters

- (void)setFilter:(FilterModel *)filter {
    _filter = filter;
    
    self.iconImageView.image = [UIImage imageNamed:filter.icon];
    self.nameLabel.text = filter.title;
    
    if (filter.isSelected) {
        self.maskImageView.hidden = NO;
    } else {
        self.maskImageView.hidden = YES;
    }
}

@end
