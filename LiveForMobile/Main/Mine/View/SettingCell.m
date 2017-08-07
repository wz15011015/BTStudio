//
//  SettingCell.m
//  LiveForMobile
//
//  Created by  Sierra on 2017/7/17.
//  Copyright © 2017年 BaiFuTak. All rights reserved.
//

#import "SettingCell.h"
#import "BWMacro.h"

NSString *const SettingCellID = @"SettingCellIdentifier";

@interface SettingCell ()

@property (nonatomic, strong) UILabel *titleLabel;

@property (nonatomic, strong) UIImageView *arrowImageView; // 箭头图标

@property (nonatomic, strong) UISwitch *functionSwitch;

@property (nonatomic, strong) UIImageView *separatorLine;

@end

@implementation SettingCell

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
        
        [self.contentView addSubview:self.titleLabel];
        [self.contentView addSubview:self.arrowImageView];
        [self.contentView addSubview:self.functionSwitch];
        [self.contentView addSubview:self.separatorLine];
    }
    return self;
}


#pragma mark - Getters

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        CGFloat x = 15 * WIDTH_SCALE;
        CGFloat w = 90;
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(x, 0, w, SETTING_CELL_H)];
        _titleLabel.textColor = RGB(73, 73, 73);
        _titleLabel.font = [UIFont systemFontOfSize:14];
    }
    return _titleLabel;
}

- (UIImageView *)arrowImageView {
    if (!_arrowImageView) {
        CGFloat rightMargin = 15 * WIDTH_SCALE;
        CGFloat w = 8 * WIDTH_SCALE;
        CGFloat h = 15 * HEIGHT_SCALE;
        CGFloat x = WIDTH - rightMargin - w;
        CGFloat y = (SETTING_CELL_H - h) / 2.0;
        _arrowImageView = [[UIImageView alloc] initWithFrame:CGRectMake(x, y, w, h)];
        _arrowImageView.image = [UIImage imageNamed:@"arrow_6x11_"];
    }
    return _arrowImageView;
}

- (UISwitch *)functionSwitch {
    if (!_functionSwitch) {
        CGFloat rightMargin = 15 * WIDTH_SCALE;
        CGFloat w = 51;
        CGFloat h = 31;
        CGFloat y = (SETTING_CELL_H - h) / 2;
        CGFloat x = WIDTH - rightMargin - w;
        _functionSwitch = [[UISwitch alloc] initWithFrame:CGRectMake(x, y, w, h)];
        _functionSwitch.onTintColor = RGB(123, 218, 70);
    }
    return _functionSwitch;
}

- (UIImageView *)separatorLine {
    if (!_separatorLine) {
        CGFloat x = CGRectGetMinX(self.titleLabel.frame);
        CGFloat w = WIDTH - (2 * x);
        CGFloat h = 0.5;
        CGFloat y = SETTING_CELL_H - h;
        _separatorLine = [[UIImageView alloc] initWithFrame:CGRectMake(x, y, w, h)];
        _separatorLine.backgroundColor = RGB(229, 229, 229);
    }
    return _separatorLine;
}


#pragma mark - Setters

- (void)setIndexPath:(NSIndexPath *)indexPath {
    _indexPath = indexPath;
    
    if (indexPath.section == 2) {
        // 1. 标题label的调整
        CGRect frame = self.titleLabel.frame;
        frame.size.width = WIDTH - (2 * frame.origin.x);
        self.titleLabel.frame = frame;
        
        self.titleLabel.textAlignment = NSTextAlignmentCenter;
        self.titleLabel.textColor = RGB(123, 218, 70);
        
        // 2. 其他控件的调整
        self.arrowImageView.hidden = YES;
        self.functionSwitch.hidden = YES;
        self.selectionStyle = UITableViewCellSelectionStyleDefault;
        
    } else {
        // 1. 标题label的调整
        CGFloat x = 15 * WIDTH_SCALE;
        CGRect frame = self.titleLabel.frame;
        frame.origin.x = x;
        frame.size.width = 90;
        self.titleLabel.frame = frame;
        
        self.titleLabel.textAlignment = NSTextAlignmentLeft;
        self.titleLabel.textColor = RGB(73, 73, 73);
        
        // 2. 其他控件的调整
        if (indexPath.section == 0) {
            self.arrowImageView.hidden = NO;
            self.functionSwitch.hidden = YES;
            self.selectionStyle = UITableViewCellSelectionStyleDefault;
            
        } else if (indexPath.section == 1) {
            if (indexPath.row == 0) {
                self.arrowImageView.hidden = YES;
                self.functionSwitch.hidden = NO;
                self.selectionStyle = UITableViewCellSelectionStyleNone;
                
            } else if (indexPath.row == 1) {
                self.arrowImageView.hidden = YES;
                self.functionSwitch.hidden = YES;
                self.selectionStyle = UITableViewCellSelectionStyleDefault;
                
            } else if (indexPath.row == 2) {
                self.arrowImageView.hidden = NO;
                self.functionSwitch.hidden = YES;
                self.selectionStyle = UITableViewCellSelectionStyleDefault;
            }
        }
    }
}

- (void)setHideSeparator:(BOOL)hideSeparator {
    _hideSeparator = hideSeparator;
    self.separatorLine.hidden = hideSeparator;
}

- (void)setTitle:(NSString *)title {
    _title = title;
    
    self.titleLabel.text = title;
}


@end
