//
//  LiveListModel.h
//  LiveForMobile
//
//  Created by  Sierra on 2017/8/21.
//  Copyright © 2017年 BaiFuTak. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 直播列表中主播 model
 */
@interface LiveListModel : NSObject

/** 头像url */
@property (nonatomic, copy) NSString *list_user_head;

/** 昵称 */
@property (nonatomic, copy) NSString *list_user_name;

/** 封面图片url */
@property (nonatomic, copy) NSString *list_pic;

/** 拉流url */
@property (nonatomic, copy) NSString *play_url;

/** 直播状态(1: 直播中  2: 其他) */
@property (nonatomic, copy) NSString *live_status;

/** 主播等级 */
@property (nonatomic, copy) NSString *rank;

/** 主播位置 */
@property (nonatomic, copy) NSString *address;

/** 在线观看人数 */
@property (nonatomic, copy) NSString *audience_num;

/** 直播标题 */
@property (nonatomic, copy) NSString *title;

@end
