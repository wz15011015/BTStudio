//
//  PublishStateCell.h
//  LiveForMobile
//
//  Created by  Sierra on 2017/8/8.
//  Copyright © 2017年 BaiFuTak. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BWMacro.h"
#import "WaterFallCollectionLayout.h"

UIKIT_EXTERN NSString *const PublishStateCellID;

#define PUBLISH_STATE_CELL_W ((WIDTH - ((WATERFALL_COLUMNCOUNT + 1) * WATERFALL_COLUMN_MARGIN)) / WATERFALL_COLUMNCOUNT)
#define PUBLISH_STATE_CELL_H (112 * HEIGHT_SCALE)

/**
 我的关注控制器中 发布动态 Cell
 */
@interface PublishStateCell : UICollectionViewCell

@end
