//
//  MineFollowCell.h
//  LiveForMobile
//
//  Created by  Sierra on 2017/8/10.
//  Copyright © 2017年 BaiFuTak. All rights reserved.
//

#import <UIKit/UIKit.h>

#define MINE_FOLLOW_CELL_H (78 * HEIGHT_SCALE)

UIKIT_EXTERN NSString *const MineFollowCellID;


/**
 我的关注 Cell
 */
@interface MineFollowCell : UITableViewCell

@property (nonatomic, strong) NSDictionary *valueDic;

@end
