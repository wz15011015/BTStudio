//
//  DNAppAboutCell.h
//  LiveForMobile
//
//  Created by  Sierra on 2017/8/7.
//  Copyright © 2017年 BaiFuTak. All rights reserved.
//

#import <UIKit/UIKit.h>

#define DN_APP_ABOUT_CELL_H (58 * HEIGHT_SCALE)

UIKIT_EXTERN NSString *const DNAppAboutCellID;


/**
 关于大牛直播 控制器中的Cell
 */
@interface DNAppAboutCell : UITableViewCell

@property (nonatomic, strong) NSString *title;

@end
