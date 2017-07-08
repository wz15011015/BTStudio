//
//  PMPrivateMessageCell.h
//  YiHuiWaiBiDuiHuan
//
//  Created by  Sierra on 2017/07/08.
//  Copyright © 2017年 YIHUALONG Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BWMacro.h"

UIKIT_EXTERN NSString *const PMPrivateMessageCellID;

#define kPMPrivateMessageCellH (72 * HEIGHT_SCALE)


/**
 私信 Cell
 */
@interface PMPrivateMessageCell : UITableViewCell

@property (nonatomic, copy) NSString *model;

@end
