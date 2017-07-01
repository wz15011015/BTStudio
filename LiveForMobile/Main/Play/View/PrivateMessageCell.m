//
//  PrivateMessageCell.m
//  LiveForMobile
//
//  Created by  Sierra on 2017/6/27.
//  Copyright © 2017年 BaiFuTak. All rights reserved.
//

#import "PrivateMessageCell.h"
#import "BWMacro.h"

NSString *const PrivateMessageCellID = @"PrivateMessageCellIdentifier";

@interface PrivateMessageCell ()

@property (nonatomic, strong) UIImageView *iconImageView; // 消息图标

@property (nonatomic, strong) UILabel *titleLabel;

@property (nonatomic, strong) UILabel *contentLabel;

@end

@implementation PrivateMessageCell

#pragma mark - Life Cycle

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        [self.contentView addSubview:self.iconImageView];
        [self.contentView addSubview:self.titleLabel];
        [self.contentView addSubview:self.contentLabel];
    }
    return self;
}


#pragma mark - Getters

- (UIImageView *)iconImageView {
    if (!_iconImageView) {
        CGFloat x = 8;
        CGFloat y = 8;
        CGFloat w = PRIVATEMESSAGE_CELL_H - (2 * y);
        _iconImageView = [[UIImageView alloc] initWithFrame:CGRectMake(x, y, w, w)];
        _iconImageView.image = [UIImage imageNamed:@"filter_icon_original"];
    }
    return _iconImageView;
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        CGFloat x = CGRectGetMaxX(self.iconImageView.frame) + 8;
        CGFloat y = CGRectGetMinY(self.iconImageView.frame);
        CGFloat h = 20;
        CGFloat w = WIDTH - x;
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(x, y, w, h)];
        _titleLabel.textColor = RGB(102, 112, 116);
        _titleLabel.font = [UIFont systemFontOfSize:16];
        
        _titleLabel.text = @"系统消息";
    }
    return _titleLabel;
}

- (UILabel *)contentLabel {
    if (!_contentLabel) {
        CGFloat x = CGRectGetMinX(self.titleLabel.frame);
        CGFloat y = CGRectGetMaxY(self.titleLabel.frame);
        CGFloat h = 16;
        CGFloat w = WIDTH - x;
        _contentLabel = [[UILabel alloc] initWithFrame:CGRectMake(x, y, w, h)];
        _contentLabel.textColor = RGB(174, 183, 185);
        _contentLabel.font = [UIFont systemFontOfSize:13];
        
        _contentLabel.text = @"直播：官方客服受理所有问题时全天24小时服务。";
    }
    return _contentLabel;
}


#pragma mark - Setters




- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
