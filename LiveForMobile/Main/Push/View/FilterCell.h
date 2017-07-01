//
//  FilterCell.h
//  LiveForMobile
//
//  Created by  Sierra on 2017/6/23.
//  Copyright © 2017年 BaiFuTak. All rights reserved.
//

#import <UIKit/UIKit.h>

@class FilterModel;

UIKIT_EXTERN NSString *const FilterCellID;

#define FILTERCELLH (119 - 4)
#define FILTERCELLW (80)

/**
 滤镜 Cell
 */
@interface FilterCell : UICollectionViewCell

@property (nonatomic, strong) FilterModel *filter;

@end
