//
//  MessageCell.h
//  LiveForMobile
//
//  Created by  Sierra on 2017/6/30.
//  Copyright © 2017年 BaiFuTak. All rights reserved.
//

#import <UIKit/UIKit.h>

UIKIT_EXTERN NSString *const MessageCellID;

#define MESSAGE_CELL_MIN_H (25)


/**
 直播间 聊天消息 Cell
 */
@interface MessageCell : UITableViewCell

@property (nonatomic, copy) NSString *message;


#pragma mark - Public Methods

/** 计算消息内容的高度 */
+ (CGFloat)heightForString:(NSString *)string;

@end
