//
//  BWBadgeButton.m
//  YiHuiWaiBiDuiHuan
//
//  Created by  Sierra on 2017/4/20.
//  Copyright © 2017年 YIHUALONG Inc. All rights reserved.
//

#import "BWBadgeButton.h"

@implementation BWBadgeButton

#pragma mark - Life cycle

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.hidden = YES;
        self.userInteractionEnabled = NO;
        self.titleLabel.font = [UIFont systemFontOfSize:11.0];
        self.backgroundColor = [UIColor redColor];
    }
    return self;
}


#pragma mark - Setters

- (void)setBadgeValue:(NSString *)badgeValue {
    _badgeValue = [badgeValue copy];
    
    if (badgeValue && [badgeValue integerValue] != 0) {
        self.hidden = NO;
        
        // 设置文字
        [self setTitle:badgeValue forState:UIControlStateNormal];
        
        // 设置frame
        CGRect frame = self.frame;
        CGFloat badgeW = self.frame.size.width;
        if (badgeValue.length > 1) {
            CGSize badgeValueSize = [badgeValue sizeWithAttributes:@{NSFontAttributeName : self.titleLabel.font}];
            badgeW = badgeValueSize.width + 10;
        }
        frame.size.width = badgeW;
        self.frame = frame;
        
    } else {
        self.hidden = YES;
    }
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
