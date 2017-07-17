//
//  SettingCell.h
//  LiveForMobile
//
//  Created by  Sierra on 2017/7/17.
//  Copyright © 2017年 BaiFuTak. All rights reserved.
//

#import <UIKit/UIKit.h>

UIKIT_EXTERN NSString *const SettingCellID;

#define SETTING_CELL_H (53 * HEIGHT_SCALE)


/**
 SettingViewController中的Cell
 */
@interface SettingCell : UITableViewCell

@property (nonatomic, strong) NSIndexPath *indexPath;

/** 是否隐藏分割线 default is NO */
@property (nonatomic, assign) BOOL hideSeparator;

@property (nonatomic, copy) NSString *title;

@end
