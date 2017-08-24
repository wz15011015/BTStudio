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
UIKIT_EXTERN NSString *const SingleGiftCellID;
UIKIT_EXTERN NSString *const SingleGiftBlankCellID;

#define GIFT_CELL_W (WIDTH)
#define GIFT_CELL_H (172 * HEIGHT_SCALE)
#define GIFT_CELL_TOP_MARGIN (8)
#define SINGLEGIFT_CELL_W (GIFT_CELL_W / 5)
#define SINGLEGIFT_CELL_H ((GIFT_CELL_H - (2 * GIFT_CELL_TOP_MARGIN) - 2) / 2)

@class GiftModel;


/**
 礼物Cell
 */
@interface GiftCell : UICollectionViewCell

@property (nonatomic, strong) NSMutableArray *dataArr;

/** 点击了礼物Cell (礼物Model, 是否选中) */
@property (nonatomic, copy) void(^selectGiftBlock)(GiftModel *, BOOL);

@end


/**
 单个礼物Cell
 */
@interface SingleGiftCell : UICollectionViewCell

@property (nonatomic, strong) GiftModel *model;

/** 是否被选中作为发送的礼物 */
@property (nonatomic, assign, getter=isSelectedForSend) BOOL selectedForSend;

@end


/**
 单个礼物的空白Cell
 */
@interface SingleGiftBlankCell : UICollectionViewCell 

@end
