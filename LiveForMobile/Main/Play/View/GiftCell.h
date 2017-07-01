//
//  GiftCell.h
//  LiveForMobile
//
//  Created by  Sierra on 2017/6/28.
//  Copyright © 2017年 BaiFuTak. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BWMacro.h"

UIKIT_EXTERN NSString *const GiftCellID; 

#define GIFT_CELL_W (WIDTH)
#define GIFT_CELL_H (164)
#define GIFT_CELL_TOP_MARGIN (8)
#define SINGLEGIFT_CELL_W (GIFT_CELL_W / 5)
#define SINGLEGIFT_CELL_H ((GIFT_CELL_H - (2 * GIFT_CELL_TOP_MARGIN) - 2) / 2)

/**
 礼物 Cell
 */
@interface GiftCell : UICollectionViewCell

@property (nonatomic, strong) NSMutableArray *dataArr;

@property (nonatomic, copy) void(^selectGiftBlock)(void);

@end


/**
 单个礼物 Cell
 */
@interface SingleGiftCell : UICollectionViewCell

@property (nonatomic, copy) NSString *model;

@end
