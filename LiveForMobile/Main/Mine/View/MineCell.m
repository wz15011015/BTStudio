//
//  MineCell.m
//  YiHuiWaiBiDuiHuan
//
//  Created by  Sierra on 2017/07/08.
//  Copyright © 2017年 YIHUALONG Inc. All rights reserved.
//

#import "MineCell.h"

NSString *const MineCellID = @"MineCellIdentifier";

@interface MineCell ()

@property (nonatomic, strong) UILabel *titleLabel; // 标题Label

@property (nonatomic, strong) UIImageView *arrowImageView; // 箭头图标

@property (nonatomic, strong) UIImageView *separatorImageView; // 分割线

@end

@implementation MineCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        UIView *selectedBGV = [[UIView alloc] initWithFrame:self.contentView.bounds];
        selectedBGV.backgroundColor = RGB(220, 220, 220);
        self.selectedBackgroundView = selectedBGV;
        
        // 添加子控件
        [self.contentView addSubview:self.titleLabel];
        [self.contentView addSubview:self.arrowImageView];
        [self.contentView addSubview:self.separatorImageView];
        
        self.hideSeparator = NO;
    }
    return self;
}


#pragma mark - 控件懒加载

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        CGFloat x = 15 * WIDTH_SCALE;
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(x, 0, 90, kMineCellH)];
        _titleLabel.textColor = RGB(96, 96, 96);
        _titleLabel.font = [UIFont systemFontOfSize:15];
    }
    return _titleLabel;
}

- (UIImageView *)arrowImageView {
    if (!_arrowImageView) {
        CGFloat rightMargin = 14 * WIDTH_SCALE;
        CGFloat w = 9 * WIDTH_SCALE;
        CGFloat h = 15 * HEIGHT_SCALE;
        CGFloat x = WIDTH - rightMargin - w;
        CGFloat y = (kMineCellH - h) / 2.0;
        _arrowImageView = [[UIImageView alloc] initWithFrame:CGRectMake(x, y, w, h)];
        _arrowImageView.image = [UIImage imageNamed:@"mine_cell_arrow"];
    }
    return _arrowImageView;
}

- (UIImageView *)separatorImageView {
    if (!_separatorImageView) {
        CGFloat x = 15 * WIDTH_SCALE;
        CGFloat w = WIDTH - (2 * x);
        CGFloat h = 1;
        _separatorImageView = [[UIImageView alloc] initWithFrame:CGRectMake(x, kMineCellH - h, w, h)];
        _separatorImageView.backgroundColor = RGB(241, 241, 241);
    }
    return _separatorImageView;
}


#pragma mark - Setters

- (void)setHideSeparator:(BOOL)hideSeparator {
    _hideSeparator = hideSeparator;
    self.separatorImageView.hidden = hideSeparator;
}

- (void)setTitle:(NSString *)title {
    _title = title;
    self.titleLabel.text = title;
}


- (void)setModel:(NSString *)model {
    _model = model; 
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
