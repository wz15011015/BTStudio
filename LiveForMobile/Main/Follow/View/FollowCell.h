//
//  FollowCell.h
//  LiveForMobile
//
//  Created by  Sierra on 2017/7/7.
//  Copyright © 2017年 BaiFuTak. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BWMacro.h"
#import "WaterFallCollectionLayout.h"

@class FollowModel;

UIKIT_EXTERN NSString *const FollowCellID;

#define FOLLOWCELL_W ((WIDTH - ((WATERFALL_COLUMNCOUNT + 1) * WATERFALL_COLUMN_MARGIN)) / WATERFALL_COLUMNCOUNT)


/**
 关注 Cell
 */
@interface FollowCell : UICollectionViewCell

@property (nonatomic, strong) FollowModel *model;


#pragma mark - Public Methods

/** 计算Cell的高度 */
+ (CGFloat)heightForCellWithString:(NSString *)string;

@end
