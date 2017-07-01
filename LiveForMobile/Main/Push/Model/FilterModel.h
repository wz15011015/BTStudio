//
//  FilterModel.h
//  LiveForMobile
//
//  Created by  Sierra on 2017/6/23.
//  Copyright © 2017年 BaiFuTak. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 滤镜
 */
@interface FilterModel : NSObject

@property (nonatomic, copy) NSString *title; // 滤镜名称

@property (nonatomic, copy) NSString *icon; // 滤镜图标

@property (nonatomic, assign, getter=isSelected) BOOL selected; // 是否被选中

@end
