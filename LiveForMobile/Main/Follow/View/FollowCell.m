//
//  FollowCell.m
//  LiveForMobile
//
//  Created by  Sierra on 2017/7/7.
//  Copyright © 2017年 BaiFuTak. All rights reserved.
//

#import "FollowCell.h"
#import "FollowModel.h"

#define FOLLOWCELL_OTHER_H ((175 + 8 + 10 + 20 + 5) * HEIGHT_SCALE)
#define TITLELABEL_X       (7)
#define TITLELABEL_W       (FOLLOWCELL_W - (2 * TITLELABEL_X))
#define TITLE_FONT [UIFont systemFontOfSize:13]

NSString *const FollowCellID = @"FollowCellIdentifier";

@interface FollowCell ()

@property (nonatomic, strong) UIImageView *coverImageView;

@property (nonatomic, strong) UILabel *titleLabel;

@property (nonatomic, strong) UIImageView *avatarImageView;

@property (nonatomic, strong) UILabel *nameLabel;

@end

@implementation FollowCell

#pragma mark - Life Cycle

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.contentView.layer.cornerRadius = 4;
        self.contentView.layer.masksToBounds = YES;
        self.contentView.backgroundColor = [UIColor whiteColor];
        
        [self.contentView addSubview:self.coverImageView];
        [self.contentView addSubview:self.titleLabel];
        [self.contentView addSubview:self.avatarImageView];
        [self.contentView addSubview:self.nameLabel];
    }
    return self;
}


#pragma mark - Getters

- (UIImageView *)coverImageView {
    if (!_coverImageView) {
        CGFloat h = 175 * HEIGHT_SCALE;
        _coverImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, FOLLOWCELL_W, h)];
        _coverImageView.image = [UIImage imageNamed:@"avatar_default"];
    }
    return _coverImageView;
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        CGFloat y = CGRectGetMaxY(self.coverImageView.frame) + (8 * HEIGHT_SCALE);
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(TITLELABEL_X, y, TITLELABEL_W, 50)];
        _titleLabel.font = TITLE_FONT;
        _titleLabel.numberOfLines = 0;
    }
    return _titleLabel;
}

- (UIImageView *)avatarImageView {
    if (!_avatarImageView) {
        CGFloat w = 20 * HEIGHT_SCALE;
        CGFloat x = CGRectGetMinX(self.titleLabel.frame);
        CGFloat y = CGRectGetMaxY(self.titleLabel.frame) + (10 * HEIGHT_SCALE);
        _avatarImageView = [[UIImageView alloc] initWithFrame:CGRectMake(x, y, w, w)];
        _avatarImageView.image = [UIImage imageNamed:@"avatar_default"];
        _avatarImageView.layer.cornerRadius = w / 2;
        _avatarImageView.layer.masksToBounds = YES;
    }
    return _avatarImageView;
}

- (UILabel *)nameLabel {
    if (!_nameLabel) {
        CGFloat y = CGRectGetMinY(self.avatarImageView.frame);
        CGFloat x = CGRectGetMaxX(self.avatarImageView.frame) + 5;
        CGFloat w = FOLLOWCELL_W - x - (10 * WIDTH_SCALE);
        _nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(x, y, w, CGRectGetHeight(self.avatarImageView.frame))];
        _nameLabel.font = [UIFont systemFontOfSize:10];
    }
    return _nameLabel;
}


#pragma mark - Setters

- (void)setModel:(FollowModel *)model {
    _model = model; 
    
    self.coverImageView.image = [UIImage imageNamed:model.coverUrl];
    self.titleLabel.text = model.title;
    self.avatarImageView.image = [UIImage imageNamed:model.imageUrl];
    self.nameLabel.text = model.name;  
    
    // 调整控件frame
    CGSize size = [self.titleLabel.text boundingRectWithSize:CGSizeMake(TITLELABEL_W, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : TITLE_FONT} context:nil].size;
    CGRect frame1 = self.titleLabel.frame;
    frame1.size.height = size.height;
    self.titleLabel.frame = frame1;
    
    CGRect frame2 = self.avatarImageView.frame;
    frame2.origin.y = CGRectGetMaxY(self.titleLabel.frame) + (10 * HEIGHT_SCALE);
    self.avatarImageView.frame = frame2;
    
    CGRect frame3 = self.nameLabel.frame;
    frame3.origin.y = CGRectGetMinY(self.avatarImageView.frame);
    self.nameLabel.frame = frame3;
}


#pragma mark - Public Methods

/** 计算Cell的高度 */
+ (CGFloat)heightForCellWithString:(NSString *)string {
    CGSize size = [string boundingRectWithSize:CGSizeMake(TITLELABEL_W, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : TITLE_FONT} context:nil].size;
    CGFloat cellHeight = FOLLOWCELL_OTHER_H + size.height;
    return cellHeight;
}


@end
