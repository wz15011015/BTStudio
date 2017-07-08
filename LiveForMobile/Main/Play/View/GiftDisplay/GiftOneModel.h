//
//  GiftOneModel.h
//  LiveForMobile
//
//  Created by  Sierra on 2017/7/8.
//  Copyright © 2017年 BaiFuTak. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PresentModelAble.h"

/**
 第一类礼物模型
 */
@interface GiftOneModel : NSObject <PresentModelAble>

@property (nonatomic, copy) NSString *sender;

@property (nonatomic, copy) NSString *giftName;

@property (nonatomic, copy) NSString *giftImageName;

@property (nonatomic, assign) NSInteger giftNumber;

+ (instancetype)modelWithSender:(NSString *)sender giftName:(NSString *)giftName giftImageName:(NSString *)giftImageName;

@end
