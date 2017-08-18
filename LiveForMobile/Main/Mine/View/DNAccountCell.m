//
//  DNAccountCell.m
//  LiveForMobile
//
//  Created by  Sierra on 2017/8/18.
//  Copyright © 2017年 BaiFuTak. All rights reserved.
//

#import "DNAccountCell.h"
#import "BWMacro.h"

NSString *const DNAccountCellID = @"DNAccountCellIdentifier";

@interface DNAccountCell ()

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *valueLabel;
@property (nonatomic, strong) UIImageView *arrowImageView;
@property (nonatomic, strong) UIImageView *separator;

@end

@implementation DNAccountCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        CGFloat leftMargin = 15 * WIDTH_SCALE;
        CGFloat rightMargin = 15 * WIDTH_SCALE;
        
        CGFloat x = leftMargin;
        CGFloat y = 0;
        CGFloat w = 200;
        CGFloat h = DNACCOUNT_CELL_H;
        self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(x, y, 200, h)];
        self.titleLabel.textColor = RGB(123, 123, 123);
        self.titleLabel.font = [UIFont systemFontOfSize:15];
        [self.contentView addSubview:self.titleLabel];
        
        w = 7 * WIDTH_SCALE;
        h = 13 * HEIGHT_SCALE;
        x = WIDTH - rightMargin - w;
        y = (DNACCOUNT_CELL_H - h) / 2.0;
        self.arrowImageView = [[UIImageView alloc] initWithFrame:CGRectMake(x, y, w, h)];
        self.arrowImageView.image = [UIImage imageNamed:@"arrow_6x11_"];
        [self.contentView addSubview:self.arrowImageView];
        
        w = 40;
        h = DNACCOUNT_CELL_H - 2;
        x = CGRectGetMinX(self.arrowImageView.frame) - (10 * WIDTH_SCALE) - w;
        y = 0;
        self.valueLabel = [[UILabel alloc] initWithFrame:CGRectMake(x, y, w, h)];
        self.valueLabel.textColor = self.titleLabel.textColor;
        self.valueLabel.font = self.titleLabel.font;
        self.valueLabel.textAlignment = NSTextAlignmentRight;
        [self.contentView addSubview:self.valueLabel]; 
        
        w = WIDTH - (2 * leftMargin);
        h = 1;
        y = DNACCOUNT_CELL_H - h;
        self.separator = [[UIImageView alloc] initWithFrame:CGRectMake(leftMargin, y, w, h)];
        self.separator.backgroundColor = RGB(241, 241, 241);
        [self.contentView addSubview:self.separator];
    }
    return self;
}


#pragma mark - Setter

- (void)setIndexPath:(NSIndexPath *)indexPath {
    _indexPath = indexPath;
    
    if (indexPath.row == 0) {
        self.titleLabel.text = @"我的账户";
    } else if (indexPath.row == 1) {
        self.titleLabel.text = @"我的收益";
    } else if (indexPath.row == 2) {
        self.titleLabel.text = @"本月奖金";
    } else if (indexPath.row == 3) {
        self.titleLabel.text = @"我的账单";
    }
}

- (void)setValue:(NSString *)value {
    _value = value;
    
    self.valueLabel.text = value;
}

@end
