//
//  PMPrivateMessageCell.m
//  YiHuiWaiBiDuiHuan
//
//  Created by  Sierra on 2017/07/08.
//  Copyright © 2017年 YIHUALONG Inc. All rights reserved.
//

#import "PMPrivateMessageCell.h"

NSString *const PMPrivateMessageCellID = @"PMPrivateMessageCellIdentifier";

@interface PMPrivateMessageCell ()

@property (nonatomic, strong) UIImageView *iconImageView; // 消息图标

@property (nonatomic, strong) UILabel *timeLabel; // 消息时间Label

@property (nonatomic, strong) UILabel *titleLabel; // 消息标题Label

@property (nonatomic, strong) UILabel *contentLabel; // 消息内容Label

@end

@implementation PMPrivateMessageCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        UIView *selectedBGV = [[UIView alloc] init];
        selectedBGV.backgroundColor = RGB(220, 220, 220);
        self.selectedBackgroundView = selectedBGV;
        
        // 添加子控件
        [self.contentView addSubview:self.iconImageView];
        [self.contentView addSubview:self.timeLabel];
        [self.contentView addSubview:self.titleLabel];
        [self.contentView addSubview:self.contentLabel];
    }
    return self;
}


#pragma mark - 控件懒加载

- (UIImageView *)iconImageView {
    if (!_iconImageView) {
        CGFloat w = 51 * WIDTH_SCALE;
        CGFloat x = 12 * WIDTH_SCALE;
        CGFloat y = (kPMPrivateMessageCellH - w) / 2.0;
        _iconImageView = [[UIImageView alloc] initWithFrame:CGRectMake(x, y, w, w)];
        _iconImageView.layer.masksToBounds = YES;
        _iconImageView.layer.cornerRadius = w / 2.0;
        _iconImageView.image = [UIImage imageNamed:@"avatar_default"];
    }
    return _iconImageView;
}

- (UILabel *)timeLabel {
    if (!_timeLabel) {
        CGFloat rightMargin = 16 * WIDTH_SCALE;
        CGFloat w = 50 * WIDTH_SCALE;
        CGFloat h = 24 * HEIGHT_SCALE;
        CGFloat x = WIDTH - rightMargin - w;
        CGFloat y = 11 * HEIGHT_SCALE;
        _timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(x, y, w, h)];
        _timeLabel.textColor = RGB(183, 183, 183);
        _timeLabel.font = [UIFont systemFontOfSize:13];
        _timeLabel.textAlignment = NSTextAlignmentRight;
    }
    return _timeLabel;
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        CGFloat x = CGRectGetMaxX(self.iconImageView.frame) + (12 * WIDTH_SCALE);
        CGFloat y = CGRectGetMinY(self.timeLabel.frame);
        CGFloat h = CGRectGetHeight(self.timeLabel.frame);
        CGFloat w = CGRectGetMinX(self.timeLabel.frame) - x - (10 * WIDTH_SCALE);
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(x, y, w, h)];
        _titleLabel.textColor = RGB(50, 50, 50);
        _titleLabel.font = [UIFont boldSystemFontOfSize:15];
    }
    return _titleLabel;
}

- (UILabel *)contentLabel {
    if (!_contentLabel) {
        CGFloat x = CGRectGetMinX(self.titleLabel.frame);
        CGFloat h = 18 * HEIGHT_SCALE;
        CGFloat y = CGRectGetMaxY(self.titleLabel.frame) + (6 * HEIGHT_SCALE);
        CGFloat w = WIDTH - x - (10 * WIDTH_SCALE);
        _contentLabel = [[UILabel alloc] initWithFrame:CGRectMake(x, y, w, h)];
        _contentLabel.textColor = RGB(183, 183, 183);
        _contentLabel.font = [UIFont systemFontOfSize:14];
    }
    return _contentLabel;
}


#pragma mark - Setters

- (void)setModel:(NSString *)model {
    _model = model;
    
    self.iconImageView.image = [UIImage imageNamed:@"Icon"];
    self.timeLabel.text = @"09:10";
    self.titleLabel.text = @"官方客服";
    self.contentLabel.text = @"签到成功，累计签到10天，今日获得40经验值";
}


- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
