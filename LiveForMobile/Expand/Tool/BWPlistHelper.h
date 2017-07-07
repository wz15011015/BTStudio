//
//  BWPlistHelper.h
//  LiveForMobile
//
//  Created by  Sierra on 2017/7/6.
//  Copyright © 2017年 BaiFuTak. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

/**
 读取Plist文件中的内容
 */
@interface BWPlistHelper : NSObject

/** 礼物个数 */
@property (nonatomic, assign) NSUInteger giftCount;


- (instancetype)initWithPropertyListFileName:(NSString *)fileName;

/** 根据礼物ID获取礼物图片 */
- (NSArray *)imagesWithGiftId:(NSString *)giftId;

/** 根据礼物ID获取礼物展示时长 */
- (float)durationWithGiftId:(NSString *)giftId;

/** 根据礼物ID获取礼物图片的X值 */
- (CGFloat)imageXWithGiftId:(NSString *)giftId;

/** 根据礼物ID获取礼物图片的Y值 */
- (CGFloat)imageYWithGiftId:(NSString *)giftId;

/** 根据礼物ID获取礼物图片的宽度 */
- (CGFloat)imageWWithGiftId:(NSString *)giftId;

/** 根据礼物ID获取礼物图片的高度 */
- (CGFloat)imageHWithGiftId:(NSString *)giftId;

@end
