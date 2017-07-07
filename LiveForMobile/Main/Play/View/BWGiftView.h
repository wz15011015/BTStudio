//
//  BWGiftView.h
//  LiveForMobile
//
//  Created by  Sierra on 2017/6/28.
//  Copyright © 2017年 BaiFuTak. All rights reserved.
//

#import <UIKit/UIKit.h>

@class BWGiftView;
@class GiftModel;

@protocol BWGiftViewDelegate <NSObject>

- (void)giftView:(BWGiftView *)view sendGift:(GiftModel *)gift;

@end


/**
 礼物view
 */
@interface BWGiftView : UIView

@property (nonatomic, weak) id<BWGiftViewDelegate>delegate;

/**
 显示在view上
 */
- (void)showToView:(UIView *)view;

/**
 移除view
 */
- (void)dismiss;

@end
