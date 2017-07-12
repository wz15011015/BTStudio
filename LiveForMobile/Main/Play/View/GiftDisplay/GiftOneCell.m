//
//  GiftOneCell.m
//  LiveForMobile
//
//  Created by  Sierra on 2017/7/8.
//  Copyright © 2017年 BaiFuTak. All rights reserved.
//

#import "GiftOneCell.h"
#import "BWMacro.h"
#import "GiftOneModel.h"

#define GIFTONE_CELL_H (37)
#define CONTENT_W (WIDTH * 0.4)

@interface GiftOneCell ()

@property (nonatomic, strong) UIImageView *backImageView;

@property (nonatomic, strong) UILabel *senderLabel;

@property (nonatomic, strong) UILabel *giftNameLabel;

@property (nonatomic, strong) UIImageView *giftImageView;

@end

@implementation GiftOneCell

#pragma mark - Life Cycle

- (instancetype)initWithRow:(NSInteger)row {
    if (self = [super initWithRow:row]) {
        [self addSubview:self.backImageView];
        [self addSubview:self.senderLabel];
        [self addSubview:self.giftNameLabel];
        [self addSubview:self.giftImageView];
    }
    return self;
}


#pragma mark - Getters

- (UIImageView *)backImageView {
    if (!_backImageView) {
        CGFloat h = GIFTONE_CELL_H;
        _backImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, CONTENT_W, h)];
        _backImageView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.3];
        _backImageView.layer.cornerRadius = h / 2;
        _backImageView.layer.masksToBounds = YES;
    }
    return _backImageView;
}

- (UILabel *)senderLabel {
    if (!_senderLabel) {
        CGFloat x = GIFTONE_CELL_H / 2;
        CGFloat h = GIFTONE_CELL_H / 2;
        _senderLabel = [[UILabel alloc] initWithFrame:CGRectMake(x, 0, CONTENT_W - 30, h)];
        _senderLabel.textColor = [UIColor whiteColor];
        _senderLabel.font = [UIFont boldSystemFontOfSize:14];
    }
    return _senderLabel;
}

- (UILabel *)giftNameLabel {
    if (!_giftNameLabel) {
        CGFloat y = CGRectGetMaxY(self.senderLabel.frame);
        _giftNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMinX(self.senderLabel.frame), y, CGRectGetWidth(self.senderLabel.frame), CGRectGetHeight(self.senderLabel.frame))];
        _giftNameLabel.textColor = [UIColor colorWithRed:233 / 255.0 green:181 / 255.0 blue:18 / 255.0 alpha:1.0];
        _giftNameLabel.font = [UIFont systemFontOfSize:13.5];
    }
    return _giftNameLabel;
}

- (UIImageView *)giftImageView {
    if (!_giftImageView) {
        CGFloat rightMargin = 10;
        CGFloat w = 17;
        CGFloat x = CONTENT_W - w - rightMargin;
        CGFloat y = 2;
        CGFloat h = GIFTONE_CELL_H - (2 * y);
        _giftImageView = [[UIImageView alloc] initWithFrame:CGRectMake(x, y, w, h)];
    }
    return _giftImageView;
}


#pragma mark - Setters

- (void)setModel:(GiftOneModel *)model {
    _model = model;
    
    self.senderLabel.text = model.sender;
    self.giftNameLabel.text = model.giftName;
    self.giftImageView.image = [UIImage imageNamed:model.giftImageName]; 
}


#pragma mark - Override (重写方法 以自定义Cell的展示及隐藏动画)

- (void)customDisplayAnimationOfShowShakeAnimation:(BOOL)flag {
    // 这里是直接使用父类中的动画，如果用户想自定义可这里实现动画，不调用父类的方法(这个方法在UIView动画的animations回调中执行)
    [super customDisplayAnimationOfShowShakeAnimation:flag];
}

- (void)customHideAnimationOfShowShakeAnimation:(BOOL)flag {
    [super customHideAnimationOfShowShakeAnimation:flag];
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
