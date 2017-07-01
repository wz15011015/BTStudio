//
//  PrivateMessageView.h
//  LiveForMobile
//
//  Created by  Sierra on 2017/6/27.
//  Copyright © 2017年 BaiFuTak. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 私信view
 */
@interface PrivateMessageView : UIView

/**
 显示在view上
 */
- (void)showToView:(UIView *)view;

/**
 移除view
 */
- (void)dismiss;

@end
