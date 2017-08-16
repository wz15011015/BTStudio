//
//  HotLiveCell.m
//  LiveForMobile
//
//  Created by  Sierra on 2017/6/20.
//  Copyright © 2017年 BaiFuTak. All rights reserved.
//

#import "HotLiveCell.h"
#import "BWMacro.h"

NSString *const HotLiveCellID = @"HotLiveCellIdentifier";

@interface HotLiveCell ()

@property (nonatomic, strong) UIImageView *avatarImageView; // 头像
@property (nonatomic, strong) UIImageView *rankImageView; // 等级图标
@property (nonatomic, strong) UILabel *nameLabel; // 名称
@property (nonatomic, strong) UILabel *locationLabel; // 地点
@property (nonatomic, strong) UIImageView *locationImageView; // 地点图标
@property (nonatomic, strong) UILabel *statusLabel; // 状态
@property (nonatomic, strong) UILabel *numberLabel; // 观看人数
@property (nonatomic, strong) UIImageView *coverImageView; // 封面图片
@property (nonatomic, strong) UILabel *titleLabel; // 标题
@property (nonatomic, strong) UIImageView *separatorImageView; // 分割线

@end

@implementation HotLiveCell

#pragma mark - Life Cycle

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        [self.contentView addSubview:self.avatarImageView];
        [self.contentView addSubview:self.rankImageView];
        [self.contentView addSubview:self.nameLabel];
        [self.contentView addSubview:self.locationLabel];
        [self.contentView addSubview:self.locationImageView];
        [self.contentView addSubview:self.statusLabel];
        [self.contentView addSubview:self.numberLabel];
        
        [self.contentView addSubview:self.coverImageView];
        
        [self.contentView addSubview:self.titleLabel];
        
        [self.contentView addSubview:self.separatorImageView];
    }
    return self;
}


#pragma mark - Getters

- (UIImageView *)avatarImageView {
    if (!_avatarImageView) {
        CGFloat w = 35 * WIDTH_SCALE;
        _avatarImageView = [[UIImageView alloc] initWithFrame:CGRectMake(13 * WIDTH_SCALE, 11 * HEIGHT_SCALE, w, w)];
        _avatarImageView.image = [UIImage imageNamed:@"avatar_default"];
        
        _avatarImageView.layer.cornerRadius = w / 2.0;
        _avatarImageView.layer.masksToBounds = YES;
    }
    return _avatarImageView;
}

- (UIImageView *)rankImageView {
    if (!_rankImageView) {
        CGFloat w = 11 * WIDTH_SCALE;
        CGFloat x = CGRectGetMaxX(self.avatarImageView.frame) - w;
        CGFloat y = CGRectGetMaxY(self.avatarImageView.frame) - w;
        _rankImageView = [[UIImageView alloc] initWithFrame:CGRectMake(x, y, w, w)];
    }
    return _rankImageView;
}

- (UILabel *)nameLabel {
    if (!_nameLabel) {
        CGFloat x = CGRectGetMaxX(self.avatarImageView.frame) + (9 * WIDTH_SCALE);
        _nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(x, CGRectGetMinY(self.avatarImageView.frame) - 2, 200, 22 * HEIGHT_SCALE)];
        _nameLabel.textColor = RGB(38, 38, 38);
        _nameLabel.font = [UIFont systemFontOfSize:14];
    }
    return _nameLabel;
}

- (UILabel *)locationLabel {
    if (!_locationLabel) { 
        CGFloat h = CGRectGetHeight(self.nameLabel.frame);
        CGFloat y = CGRectGetMinY(self.nameLabel.frame);
        CGFloat w = 50;
        CGFloat x = WIDTH - w;
        _locationLabel = [[UILabel alloc] initWithFrame:CGRectMake(x, y, w, h)];
        _locationLabel.textColor = RGB(39, 87, 141);
        _locationLabel.font = [UIFont systemFontOfSize:11.5];
    }
    return _locationLabel;
}

- (UIImageView *)locationImageView {
    if (!_locationImageView) {
        CGFloat rightMargin = 2 * WIDTH_SCALE;
        CGFloat w = 11 * WIDTH_SCALE;
        CGFloat h = 14 * HEIGHT_SCALE;
        CGFloat x = CGRectGetMinX(self.locationLabel.frame) - rightMargin - w;
        CGFloat y = CGRectGetMinY(self.locationLabel.frame) + (CGRectGetHeight(self.locationLabel.frame) - h) / 2.0;
        _locationImageView = [[UIImageView alloc] initWithFrame:CGRectMake(x, y, w, h)];
        _locationImageView.backgroundColor = RGB(39, 87, 141);
    }
    return _locationImageView;
}

- (UILabel *)statusLabel {
    if (!_statusLabel) {
        CGFloat y = CGRectGetMaxY(self.nameLabel.frame) + (1 * HEIGHT_SCALE);
        _statusLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMinX(self.nameLabel.frame), y, 80, 16)];
        _statusLabel.textColor = RGB(135, 135, 135);
        _statusLabel.font = self.locationLabel.font;
    }
    return _statusLabel;
}

- (UILabel *)numberLabel {
    if (!_numberLabel) {
        CGFloat rightMargin = 12 * WIDTH_SCALE;
        CGFloat w = 120;
        CGFloat x = WIDTH - rightMargin - w;
        _numberLabel = [[UILabel alloc] initWithFrame:CGRectMake(x, CGRectGetMinY(self.statusLabel.frame), w, CGRectGetHeight(self.statusLabel.frame))];
        _numberLabel.textColor = self.statusLabel.textColor;
        _numberLabel.font = self.statusLabel.font;
        _numberLabel.textAlignment = NSTextAlignmentRight;
    }
    return _numberLabel;
}

- (UIImageView *)coverImageView {
    if (!_coverImageView) {
        CGFloat h = 400 * HEIGHT_SCALE;
        CGFloat y = CGRectGetMaxY(self.avatarImageView.frame) + (10 * HEIGHT_SCALE);
        _coverImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, y, WIDTH, h)];
        _coverImageView.contentMode = UIViewContentModeScaleToFill;
        _coverImageView.image = [UIImage imageNamed:@"avatar_default"];
    }
    return _coverImageView;
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        CGFloat x = CGRectGetMinX(self.avatarImageView.frame);
        CGFloat w = WIDTH - (2 * x);
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(x, CGRectGetMaxY(self.coverImageView.frame), w, 36 * HEIGHT_SCALE)];
        _titleLabel.textColor = RGB(38, 38, 38);
        _titleLabel.font = [UIFont systemFontOfSize:15];
    }
    return _titleLabel;
}

- (UIImageView *)separatorImageView {
    if (!_separatorImageView) { 
        CGFloat h = 9 * HEIGHT_SCALE;
        CGFloat y = HOTLIVECELL_H - h;
        _separatorImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, y, WIDTH, h)];
        _separatorImageView.backgroundColor = RGB(233, 233, 233);
    }
    return _separatorImageView;
}


#pragma mark - Setters

- (void)setIndexPath:(NSIndexPath *)indexPath {
    _indexPath = indexPath;
}

- (void)setValue:(NSString *)value {
    _value = value;
    
    // 1. 数据赋值
    NSString *name = @"高姿态的🛴，走了...";
    NSString *location = @"江苏 苏州";
    self.nameLabel.text = name;
    self.locationLabel.text = location;
    self.statusLabel.text = @"直播中";
    self.numberLabel.text = [NSString stringWithFormat:@"%@ 在看", @"112345"];
    
    // 图片居中显示
    [self.coverImageView setContentScaleFactor:[[UIScreen mainScreen] scale]];
    self.coverImageView.contentMode = UIViewContentModeScaleAspectFill;
    self.coverImageView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    self.coverImageView.clipsToBounds = YES;
    
    self.titleLabel.text = @"相守不易，且行且珍惜！";
    
    int random = arc4random() % 3;
    if (random == 0) {
        self.rankImageView.image = [UIImage imageNamed:@"tuhao_1_14x14_"];
    } else if (random == 1) {
        self.rankImageView.image = [UIImage imageNamed:@"tuhao_2_14x14_"];
    } else {
        self.rankImageView.image = [UIImage imageNamed:@"tuhao_3_14x14_"];
    }
    
    
    // 2. 调整控件位置
    // 2.1 地点
    CGFloat rightMargin = 12 * WIDTH_SCALE;
    CGFloat maxW = 130 * WIDTH_SCALE;
    CGSize size = [self.locationLabel.text boundingRectWithSize:CGSizeMake(maxW, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : self.locationLabel.font} context:nil].size;
    
    CGRect frame1 = self.locationLabel.frame;
    frame1.size.width = size.width;
    frame1.origin.x = WIDTH - rightMargin - size.width;
    self.locationLabel.frame = frame1;
    
    // 2.2 地点图标
    rightMargin = 2 * WIDTH_SCALE;
    CGRect frame2 = self.locationImageView.frame;
    frame2.origin.x = CGRectGetMinX(self.locationLabel.frame) - rightMargin - frame2.size.width;
    self.locationImageView.frame = frame2;
    
    // 2.3 名称
    rightMargin = 15 * WIDTH_SCALE;
    CGRect frame3 = self.nameLabel.frame;
    frame3.size.width = CGRectGetMinX(self.locationImageView.frame) - rightMargin - CGRectGetMinX(frame3);
    self.nameLabel.frame = frame3;
}


#pragma mark - Event




- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
