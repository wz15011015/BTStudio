//
//  PublishStateCell.m
//  LiveForMobile
//
//  Created by  Sierra on 2017/8/8.
//  Copyright © 2017年 BaiFuTak. All rights reserved.
//

#import "PublishStateCell.h"

NSString *const PublishStateCellID = @"PublishStateCellIdentifier";

@interface PublishStateCell ()

@property (nonatomic, strong) UIImageView *iconImageView;

@property (nonatomic, strong) UILabel *titleLabel;

@property (nonatomic, strong) UIImageView *avatarImageView;

@end

@implementation PublishStateCell

#pragma mark - Life Cycle

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.contentView.layer.cornerRadius = 4;
        self.contentView.layer.masksToBounds = YES;
        self.contentView.backgroundColor = [UIColor whiteColor];
        
        [self.contentView addSubview:self.avatarImageView];
        [self.contentView addSubview:self.iconImageView];
        [self.contentView addSubview:self.titleLabel];
    }
    return self;
}


#pragma mark - Getters

- (UIImageView *)avatarImageView {
    if (!_avatarImageView) {
        _avatarImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, PUBLISH_STATE_CELL_W, PUBLISH_STATE_CELL_H)];
        _avatarImageView.contentMode = UIViewContentModeScaleAspectFit;
        _avatarImageView.image = [UIImage imageNamed:@"user_avatar_default"];
        
        UIVisualEffectView *effectView = [[UIVisualEffectView alloc] initWithEffect:[UIBlurEffect effectWithStyle:UIBlurEffectStyleDark]];
        effectView.frame = _avatarImageView.bounds;
        effectView.backgroundColor = RGB(70, 58, 84);
        effectView.alpha = 0.75;
        [_avatarImageView addSubview:effectView];
    }
    return _avatarImageView;
}

- (UIImageView *)iconImageView {
    if (!_iconImageView) {
        CGFloat w = 39 * WIDTH_SCALE;
        CGFloat h = 32 * HEIGHT_SCALE;
        CGFloat x = (PUBLISH_STATE_CELL_W - w) / 2;
        _iconImageView = [[UIImageView alloc] initWithFrame:CGRectMake(x, PUBLISH_STATE_CELL_H * 0.27, w, h)];
        _iconImageView.image = [UIImage imageNamed:@"xiangji_35x29_"];
    }
    return _iconImageView;
}

- (UILabel *)titleLabel {
    if (!_titleLabel) { 
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, PUBLISH_STATE_CELL_H * 0.61, PUBLISH_STATE_CELL_W, 18)];
        _titleLabel.font = [UIFont systemFontOfSize:13];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.textColor = [UIColor whiteColor];
        _titleLabel.text = @"发布动态";
    }
    return _titleLabel;
}

@end
