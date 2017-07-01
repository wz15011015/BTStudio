//
//  ShareCell.m
//  LiveForMobile
//
//  Created by  Sierra on 2017/6/27.
//  Copyright © 2017年 BaiFuTak. All rights reserved.
//

#import "ShareCell.h"
#import "ShareModel.h"

NSString *const ShareCellID = @"ShareCellIdentifier";

@interface ShareCell ()

@property (nonatomic, strong) UIButton *iconButton;

@property (nonatomic, strong) UILabel *nameLabel;

@end

@implementation ShareCell

#pragma mark - Life cycle

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self.contentView addSubview:self.iconButton];
        [self.contentView addSubview:self.nameLabel]; 
    }
    return self;
}


#pragma mark - Getters

- (UIButton *)iconButton {
    if (!_iconButton) {
        CGFloat x = 10;
        CGFloat w = SHARE_CELL_W - (2 * x);
        CGFloat y = (SHARE_CELL_H - w) / 2.0;
        y -= 7;
        _iconButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _iconButton.frame = CGRectMake(x, y, w, w); 
        [_iconButton setImage:[UIImage imageNamed:@"share_icon_friends"] forState:UIControlStateNormal];
        [_iconButton setImage:[UIImage imageNamed:@"share_icon_friends_highlighted"] forState:UIControlStateHighlighted];
        _iconButton.userInteractionEnabled = NO;
    }
    return _iconButton;
}

- (UILabel *)nameLabel {
    if (!_nameLabel) {
        CGFloat y = CGRectGetMaxY(self.iconButton.frame) - 4;
        CGFloat h = SHARE_CELL_H - y;
        _nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, y, SHARE_CELL_W, h)];
        _nameLabel.textColor = RGB(156, 156, 156);
        _nameLabel.font = [UIFont systemFontOfSize:12];
        _nameLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _nameLabel;
}


#pragma mark - Setters

- (void)setModel:(ShareModel *)model {
    _model = model;
    
    [self.iconButton setImage:[UIImage imageNamed:model.icon] forState:UIControlStateNormal];
    [self.iconButton setImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@_highlighted", model.icon]] forState:UIControlStateHighlighted];
    self.nameLabel.text = model.name;
}

@end
