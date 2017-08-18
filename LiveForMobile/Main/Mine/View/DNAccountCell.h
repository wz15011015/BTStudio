//
//  DNAccountCell.h
//  LiveForMobile
//
//  Created by  Sierra on 2017/8/18.
//  Copyright © 2017年 BaiFuTak. All rights reserved.
//

#import <UIKit/UIKit.h>

#define DNACCOUNT_CELL_H (58 * HEIGHT_SCALE)

UIKIT_EXTERN NSString *const DNAccountCellID;

/**
 大牛账户Cell
 */
@interface DNAccountCell : UITableViewCell

@property (nonatomic, strong) NSIndexPath *indexPath;

@property (nonatomic, strong) NSString *value;

@end
