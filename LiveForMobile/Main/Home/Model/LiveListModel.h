//
//  LiveListModel.h
//  LiveForMobile
//
//  Created by  Sierra on 2017/8/21.
//  Copyright © 2017年 BaiFuTak. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 直播列表 model
 */
@interface LiveListModel : NSObject

/** 头像url */
@property (nonatomic, copy) NSString *list_user_head;

/** 昵称 */
@property (nonatomic, copy) NSString *list_user_name;

/** 封面图片url */
@property (nonatomic, copy) NSString *list_pic;

@end
