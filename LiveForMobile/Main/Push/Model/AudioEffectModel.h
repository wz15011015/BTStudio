//
//  AudioEffectModel.h
//  LiveForMobile
//
//  Created by  Sierra on 2017/6/26.
//  Copyright © 2017年 BaiFuTak. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 音效
 */
@interface AudioEffectModel : NSObject

@property (nonatomic, copy) NSString *name; // 音效名称

@property (nonatomic, assign, getter=isSelected) BOOL selected; // 是否被选中

@end
