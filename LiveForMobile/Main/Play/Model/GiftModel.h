//
//  GiftModel.h
//  LiveForMobile
//
//  Created by  Sierra on 2017/7/6.
//  Copyright © 2017年 BaiFuTak. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

/**
 礼物 
 */
@interface GiftModel : NSObject

/** 礼物ID */
@property (nonatomic, copy) NSString *giftId;

/** 礼物名称 */
@property (nonatomic, copy) NSString *giftName;

/** 礼物图片名称 */
@property (nonatomic, copy) NSString *giftImageName;

/** 礼物图片个数 */
@property (nonatomic, assign) NSUInteger giftImageCount;

/** 礼物显示时长 */
@property (nonatomic, assign) float giftDuration;

/** 礼物价格 */
@property (nonatomic, copy) NSString *giftPrice;

/** 是否被选中作为发送的礼物 default is NO */
@property (nonatomic, assign, getter=isSelectedForSend) BOOL selectedForSend;

@end
