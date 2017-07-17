//
//  MineCell.h
//  YiHuiWaiBiDuiHuan
//
//  Created by  Sierra on 2017/07/08.
//  Copyright © 2017年 YIHUALONG Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BWMacro.h"

UIKIT_EXTERN NSString *const MineCellID;

#define MINE_CELL_H (54 * HEIGHT_SCALE)


/**
 我的 Cell
 */
@interface MineCell : UITableViewCell

/** 是否隐藏分割线 default is NO */
@property (nonatomic, assign) BOOL hideSeparator;

@property (nonatomic, copy) NSString *title;


@property (nonatomic, copy) NSString *model;

@end
