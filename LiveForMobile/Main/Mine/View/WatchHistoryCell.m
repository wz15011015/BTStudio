//
//  WatchHistoryCell.m
//  LiveForMobile
//
//  Created by  Sierra on 2017/7/17.
//  Copyright © 2017年 BaiFuTak. All rights reserved.
//

#import "WatchHistoryCell.h"
#import "BWMacro.h"

NSString *const WatchHistoryCellID = @"WatchHistoryCellIdentifier";

@interface WatchHistoryCell ()

@property (nonatomic, strong) UIImageView *avatarImageView; // 头像

@property (nonatomic, strong) UILabel *nameLabel;

@property (nonatomic, strong) UILabel *titleLabel;

@property (nonatomic, strong) UILabel *timeLabel;

@property (nonatomic, strong) UIImageView *separatorLine;

@end

@implementation WatchHistoryCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


#pragma mark - Life Cycle

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self.contentView addSubview:self.avatarImageView];
        [self.contentView addSubview:self.nameLabel];
        [self.contentView addSubview:self.titleLabel];
        [self.contentView addSubview:self.timeLabel];
        [self.contentView addSubview:self.separatorLine];
    }
    return self;
}


#pragma mark - Getters

- (UIImageView *)avatarImageView {
    if (!_avatarImageView) {
        CGFloat w = 38 * WIDTH_SCALE;
        CGFloat x = 15 * WIDTH_SCALE;
        CGFloat y = (WATCHHISTORY_CELL_H - w) / 2.0;
        _avatarImageView = [[UIImageView alloc] initWithFrame:CGRectMake(x, y, w, w)];
        _avatarImageView.image = [UIImage imageNamed:@"avatar_default"];
        
        _avatarImageView.layer.masksToBounds = YES;
        _avatarImageView.layer.cornerRadius = w / 2;
    }
    return _avatarImageView;
}

- (UILabel *)nameLabel {
    if (!_nameLabel) {
        CGFloat x = CGRectGetMaxX(self.avatarImageView.frame) + (14 * WIDTH_SCALE);
        CGFloat w = WIDTH - (100 * WIDTH_SCALE) - x;
        _nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(x, CGRectGetMinY(self.avatarImageView.frame), w, 21 * HEIGHT_SCALE)];
        _nameLabel.font = [UIFont systemFontOfSize:15];
        
        _nameLabel.text = @"凌凌漆";
    }
    return _nameLabel;
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        CGFloat x = CGRectGetMinX(self.nameLabel.frame);
        CGFloat w = WIDTH - x - (15 * WIDTH_SCALE);
        CGFloat y = CGRectGetMaxY(self.nameLabel.frame) + (6 * HEIGHT_SCALE);
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(x, y, w, 16 * HEIGHT_SCALE)];
        _titleLabel.textColor = RGB(161, 161, 161);
        _titleLabel.font = [UIFont systemFontOfSize:13];
        
        _titleLabel.text = @"夏天你们最爱吃的水果是什么？";
    }
    return _titleLabel;
}

- (UILabel *)timeLabel {
    if (!_timeLabel) {
        CGFloat rightMargin = 15 * WIDTH_SCALE;
        CGFloat w = 65 * WIDTH_SCALE;
        CGFloat h = 16 * HEIGHT_SCALE;
        CGFloat x = WIDTH - rightMargin - w;
        CGFloat y = (WATCHHISTORY_CELL_H - h) / 2;
        _timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(x, y, w, h)];
        _timeLabel.textColor = RGB(190, 190, 190);
        _timeLabel.font = [UIFont systemFontOfSize:13];
        _timeLabel.textAlignment = NSTextAlignmentRight;
        
        _timeLabel.text = @"10小时前";
    }
    return _timeLabel;
}

- (UIImageView *)separatorLine {
    if (!_separatorLine) {
        CGFloat x = CGRectGetMinX(self.nameLabel.frame) - 2;
        CGFloat w = WIDTH - x;
        CGFloat h = 0.5;
        CGFloat y = WATCHHISTORY_CELL_H - h;
        _separatorLine = [[UIImageView alloc] initWithFrame:CGRectMake(x, y, w, h)];
        _separatorLine.backgroundColor = RGB(229, 229, 229);
    }
    return _separatorLine;
}


#pragma mark - Setters



@end
