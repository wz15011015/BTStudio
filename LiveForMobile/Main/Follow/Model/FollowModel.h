//
//  FollowModel.h
//  LiveForMobile
//
//  Created by  Sierra on 2017/7/7.
//  Copyright © 2017年 BaiFuTak. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 关注的主播 模型
 */
@interface FollowModel : NSObject

/** 关注的封面图片 */
@property (nonatomic, copy) NSString *coverUrl;

/** 关注的标题 */
@property (nonatomic, copy) NSString *title;

/** 主播头像 */
@property (nonatomic, copy) NSString *imageUrl;

/** 主播名称 */
@property (nonatomic, copy) NSString *name;

@end
