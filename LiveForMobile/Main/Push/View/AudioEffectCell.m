//
//  AudioEffectCell.m
//  LiveForMobile
//
//  Created by  Sierra on 2017/6/26.
//  Copyright © 2017年 BaiFuTak. All rights reserved.
//

#import "AudioEffectCell.h"
#import "AudioEffectModel.h"

NSString *const AudioEffectCellID = @"AudioEffectCellIdentifier";

@interface AudioEffectCell ()

@property (nonatomic, strong) UIButton *effectButton; // 音效按钮  

@end

@implementation AudioEffectCell

#pragma mark - Life cycle

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self.contentView addSubview:self.effectButton];
    }
    return self;
}


#pragma mark - Getters

- (UIButton *)effectButton {
    if (!_effectButton) {
        CGFloat x = 8;
        CGFloat w = AUDIOEFFECTCELLW - (2 * x);
        CGFloat y = (AUDIOEFFECTCELLH - w) / 2.0;
        _effectButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _effectButton.frame = CGRectMake(x, y, w, w);
        _effectButton.titleLabel.font = [UIFont systemFontOfSize:12];
        [_effectButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_effectButton setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
        [_effectButton setBackgroundImage:[UIImage imageNamed:@"audioEffectRound_normal"] forState:UIControlStateNormal];
        [_effectButton setBackgroundImage:[UIImage imageNamed:@"audioEffectRound_selected"] forState:UIControlStateSelected];
        _effectButton.userInteractionEnabled = NO;
    }
    return _effectButton;
}


#pragma mark - Setters

- (void)setAudioEffect:(AudioEffectModel *)audioEffect {
    _audioEffect = audioEffect;
    
    [self.effectButton setTitle:audioEffect.name forState:UIControlStateNormal];
    [self.effectButton setTitle:audioEffect.name forState:UIControlStateSelected];
    self.effectButton.selected = audioEffect.isSelected;
}


@end
