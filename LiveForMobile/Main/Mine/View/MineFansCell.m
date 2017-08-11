//
//  MineFansCell.m
//  LiveForMobile
//
//  Created by  Sierra on 2017/8/11.
//  Copyright © 2017年 BaiFuTak. All rights reserved.
//

#import "MineFansCell.h"
#import "BWMacro.h"

NSString *const MineFansCellID = @"MineFansCellIdentifier";

@interface MineFansCell ()

@property (nonatomic, strong) UIImageView *avatar;
@property (nonatomic, strong) UIImageView *gender;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UILabel *introLabel;
@property (nonatomic, strong) UIButton *followButton;
@property (nonatomic, strong) UIImageView *separator;

@end

@implementation MineFansCell

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
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        CGFloat x = 15 * WIDTH_SCALE;
        CGFloat w = 40 * WIDTH_SCALE;
        CGFloat h = w;
        CGFloat y = (MINE_FANS_CELL_H - w) / 2;
        
        self.avatar = [[UIImageView alloc] initWithFrame:CGRectMake(x, y, w, h)];
        self.avatar.layer.cornerRadius = w / 2;
        self.avatar.layer.masksToBounds = YES;
        self.avatar.image = [UIImage imageNamed:@"avatar_default"];
        [self.contentView addSubview:self.avatar];
        
        x = CGRectGetMaxX(self.avatar.frame) + (15 * WIDTH_SCALE);
        y = CGRectGetMinY(self.avatar.frame);
        w = 240 * WIDTH_SCALE;
        h = 18 * HEIGHT_SCALE;
        self.nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(x, y, w, h)];
        self.nameLabel.textColor = RGB(62, 62, 62);
        self.nameLabel.font = [UIFont systemFontOfSize:15];
        [self.contentView addSubview:self.nameLabel];
        
        x = CGRectGetMaxX(self.nameLabel.frame) + (6 * WIDTH_SCALE);
        self.gender = [[UIImageView alloc] initWithFrame:CGRectMake(x, y, h, h)];
        [self.contentView addSubview:self.gender];
        
        x = CGRectGetMinX(self.nameLabel.frame);
        y = CGRectGetMaxY(self.nameLabel.frame) + (5 * HEIGHT_SCALE);
        self.introLabel = [[UILabel alloc] initWithFrame:CGRectMake(x, y, w, h)];
        self.introLabel.textColor = RGB(173, 173, 173);
        self.introLabel.font = [UIFont systemFontOfSize:13];
        [self.contentView addSubview:self.introLabel];
        
        w = 62 * WIDTH_SCALE;
        h = 28 * HEIGHT_SCALE;
        y = (MINE_FANS_CELL_H - h) / 2;
        x = WIDTH - (15 * WIDTH_SCALE) - w;
        self.followButton = [UIButton buttonWithType:UIButtonTypeCustom];
        self.followButton.frame = CGRectMake(x, y, w, h);
        [self.followButton setImage:[UIImage imageNamed:@"guanzhu_60x26_"] forState:UIControlStateNormal];
        [self.followButton setImage:[UIImage imageNamed:@"guanzhup_60x26_"] forState:UIControlStateHighlighted];
        [self.followButton addTarget:self action:@selector(followEvent) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:self.followButton];
        
        x = CGRectGetMinX(self.nameLabel.frame);
        w = WIDTH - x;
        self.separator = [[UIImageView alloc] initWithFrame:CGRectMake(x, MINE_FANS_CELL_H - 1, w, 1)];
        self.separator.backgroundColor = RGB(237, 237, 237);
        [self.contentView addSubview:self.separator];
    }
    return self;
}


#pragma mark - Setters

- (void)setValueDic:(NSDictionary *)valueDic {
    _valueDic = valueDic;
    
    self.avatar.image = [UIImage imageNamed:valueDic[@"img_url"]];
    self.nameLabel.text = valueDic[@"name"];
    self.introLabel.text = valueDic[@"intro"];
    NSInteger gender = [valueDic[@"gender"] integerValue]; // 1 男  2 女
    if (gender == 1) {
        self.gender.image = [UIImage imageNamed:@"man_16x16_"];
    } else {
        self.gender.image = [UIImage imageNamed:@"woman_14x14_"];
    }
    
    // 调整控件位置
    CGFloat maxW = CGRectGetMinX(self.followButton.frame) - (30 * WIDTH_SCALE) - CGRectGetMinX(self.nameLabel.frame);
    CGSize size = [self.nameLabel.text boundingRectWithSize:CGSizeMake(maxW, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : self.nameLabel.font} context:nil].size;
    CGRect frame1 = self.nameLabel.frame;
    frame1.size.width = size.width;
    self.nameLabel.frame = frame1;
    
    CGRect frame2 = self.gender.frame;
    frame2.origin.x = CGRectGetMaxX(self.nameLabel.frame) + (6 * WIDTH_SCALE);
    self.gender.frame = frame2;
    
    CGRect frame3 = self.introLabel.frame;
    frame3.size.width = CGRectGetMinX(self.followButton.frame) - (10 * WIDTH_SCALE) - CGRectGetMinX(self.introLabel.frame);
    self.introLabel.frame = frame3;
}


#pragma mark - Event

- (void)followEvent {
    NSLog(@"关注了 %@", self.valueDic[@"name"]);
}

@end
