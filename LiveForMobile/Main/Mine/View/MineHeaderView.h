//
//  MineHeaderView.h
//  LiveForMobile
//
//  Created by  Sierra on 2017/8/7.
//  Copyright © 2017年 BaiFuTak. All rights reserved.
//

#import <UIKit/UIKit.h>

#define MINE_HEADER_VIEW_H (195 * HEIGHT_SCALE)

/**
 "我的"中头部视图
 */
@interface MineHeaderView : UIView

@property (nonatomic, copy) void(^buttonEventBlock)(NSInteger tag);

@end




/**
 动态/关注/粉丝 三个大按钮
 */
@interface ItemButton : UIButton

@property (nonatomic, copy) NSString *value;

- (instancetype)initWithFrame:(CGRect)frame title:(NSString *)title value:(NSString *)value;

@end
