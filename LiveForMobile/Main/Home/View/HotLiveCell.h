//
//  HotLiveCell.h
//  LiveForMobile
//
//  Created by  Sierra on 2017/6/20.
//  Copyright © 2017年 BaiFuTak. All rights reserved.
//

#import <UIKit/UIKit.h>

UIKIT_EXTERN NSString *const HotLiveCellID;

#define HOTLIVECELL_H (540 * HEIGHT_SCALE)


/**
 热门主播 Cell
 */
@interface HotLiveCell : UITableViewCell

@property (nonatomic, copy) NSString *value;

@end
