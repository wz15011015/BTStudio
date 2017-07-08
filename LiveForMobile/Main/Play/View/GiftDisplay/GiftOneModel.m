//
//  GiftOneModel.m
//  LiveForMobile
//
//  Created by  Sierra on 2017/7/8.
//  Copyright © 2017年 BaiFuTak. All rights reserved.
//

#import "GiftOneModel.h"

@implementation GiftOneModel

+ (instancetype)modelWithSender:(NSString *)sender giftName:(NSString *)giftName giftImageName:(NSString *)giftImageName {
    GiftOneModel *model = [[GiftOneModel alloc] init];
    model.sender = sender;
    model.giftName = giftName;
    model.giftImageName = giftImageName;
    return model;
}

@end
