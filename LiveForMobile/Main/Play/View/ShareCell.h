//
//  ShareCell.h
//  LiveForMobile
//
//  Created by  Sierra on 2017/6/27.
//  Copyright © 2017年 BaiFuTak. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BWMacro.h"

UIKIT_EXTERN NSString *const ShareCellID;

#define SHARE_CELL_H (89 - 2)
#define SHARE_CELL_W (WIDTH / 5)

@class ShareModel;

/**
 分享 Cell
 */
@interface ShareCell : UICollectionViewCell

@property (nonatomic, strong) ShareModel *model;

@end
