//
//  MineFansCell.h
//  LiveForMobile
//
//  Created by  Sierra on 2017/8/11.
//  Copyright © 2017年 BaiFuTak. All rights reserved.
//

#import <UIKit/UIKit.h>

#define MINE_FANS_CELL_H (80 * HEIGHT_SCALE)

UIKIT_EXTERN NSString *const MineFansCellID;

/**
 我的粉丝Cell
 */
@interface MineFansCell : UITableViewCell

@property (nonatomic, strong) NSDictionary *valueDic;

@end
