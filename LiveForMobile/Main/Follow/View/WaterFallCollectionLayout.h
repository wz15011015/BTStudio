//
//  WaterFallCollectionLayout.h
//  LiveForMobile
//
//  Created by  Sierra on 2017/7/6.
//  Copyright © 2017年 BaiFuTak. All rights reserved.
//

#import <UIKit/UIKit.h>

#define WATERFALL_COLUMNCOUNT   (2)  // 瀑布流的列数
#define WATERFALL_COLUMN_MARGIN (9) // Cell列间距
#define WATERFALL_ROW_MARGIN    (9) // Cell行间距

typedef CGFloat(^ItemHeightBlock)(NSIndexPath *indexPath);


/**
 瀑布流布局
 */
@interface WaterFallCollectionLayout : UICollectionViewLayout

/** 用于获取每个Cell高度的Block */
@property (nonatomic, copy) ItemHeightBlock heightBlock;

/** 存储了每个Cell的高度 */
@property (nonatomic, strong) NSArray <NSNumber *>*heightArr;


- (instancetype)initWithItemsHeightBlock:(ItemHeightBlock)block;

@end
