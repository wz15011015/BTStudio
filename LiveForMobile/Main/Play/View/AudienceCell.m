//
//  AudienceCell.m
//  LiveForMobile
//
//  Created by  Sierra on 2017/6/28.
//  Copyright © 2017年 BaiFuTak. All rights reserved.
//

#import "AudienceCell.h"
#import "BWMacro.h"

NSString *const AudienceCellID = @"AudienceCellIdentifier";

@interface AudienceCell ()

@property (nonatomic, strong) UIImageView *avatarImageView; // 头像
@property (nonatomic, strong) UIImageView *rankImageView; // 等级图标

@end

@implementation AudienceCell

#pragma mark - Life cycle

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self.contentView addSubview:self.avatarImageView];
        [self.contentView addSubview:self.rankImageView];
    }
    return self;
}


#pragma mark - Getters

- (UIImageView *)avatarImageView {
    if (!_avatarImageView) {
        CGFloat x = 4;
        CGFloat w = AUDIENCE_CELL_H;
        _avatarImageView = [[UIImageView alloc] initWithFrame:CGRectMake(x, 0, w, w)];
        _avatarImageView.image = [UIImage imageNamed:@"avatar_default"];
        
        _avatarImageView.layer.masksToBounds = YES;
        _avatarImageView.layer.cornerRadius = w / 2.0;
    }
    return _avatarImageView;
}

- (UIImageView *)rankImageView {
    if (!_rankImageView) {
        CGFloat w = 11;
        CGFloat x = CGRectGetMaxX(self.avatarImageView.frame) - w + 2;
        CGFloat y = CGRectGetMaxY(self.avatarImageView.frame) - w;
        _rankImageView = [[UIImageView alloc] initWithFrame:CGRectMake(x, y, w, w)];
        _rankImageView.backgroundColor = RGB(23, 231, 178);
        
        _rankImageView.layer.masksToBounds = YES;
        _rankImageView.layer.cornerRadius = w / 2.0;
    }
    return _rankImageView;
}


#pragma mark - Setters



@end
