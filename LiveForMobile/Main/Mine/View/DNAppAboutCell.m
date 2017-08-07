//
//  DNAppAboutCell.m
//  LiveForMobile
//
//  Created by  Sierra on 2017/8/7.
//  Copyright © 2017年 BaiFuTak. All rights reserved.
//

#import "DNAppAboutCell.h"
#import "BWMacro.h"

NSString *const DNAppAboutCellID = @"DNAppAboutCellIdentifier";

@interface DNAppAboutCell ()

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIImageView *arrowImageView;
@property (nonatomic, strong) UIImageView *separator;

@end

@implementation DNAppAboutCell

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
        UIView *bgv = [[UIView alloc] init];
        bgv.backgroundColor = RGB(217, 217, 217);
        self.selectedBackgroundView = bgv;
        
        // 添加控件
        CGFloat arrowW = 8 * WIDTH_SCALE;
        CGFloat arrowH = 15 * HEIGHT_SCALE;
        CGFloat arrowX = WIDTH - (15 * WIDTH_SCALE) - arrowW;
        CGFloat arrowY = (DN_APP_ABOUT_CELL_H - arrowH) / 2;
        self.arrowImageView = [[UIImageView alloc] initWithFrame:CGRectMake(arrowX, arrowY, arrowW, arrowH)];
        self.arrowImageView.image = [UIImage imageNamed:@"arrow_6x11_"];
        
        CGFloat titleX = 15 * WIDTH_SCALE;
        self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(titleX, 0, CGRectGetMinX(self.arrowImageView.frame) - titleX - (5 * WIDTH_SCALE), DN_APP_ABOUT_CELL_H)];
        self.titleLabel.font = [UIFont systemFontOfSize:15];
        
        CGFloat separatorX = 20 * WIDTH_SCALE;
        self.separator = [[UIImageView alloc] initWithFrame:CGRectMake(separatorX, DN_APP_ABOUT_CELL_H - 1, WIDTH - (2 * separatorX), 1)];
        self.separator.backgroundColor = RGB(239, 239, 239);
        
        
        [self.contentView addSubview:self.arrowImageView];
        [self.contentView addSubview:self.titleLabel];
        [self.contentView addSubview:self.separator];
    }
    return self;
}


#pragma mark - Setters

- (void)setTitle:(NSString *)title {
    _title = title;
    
    self.titleLabel.text = title;
}

@end
