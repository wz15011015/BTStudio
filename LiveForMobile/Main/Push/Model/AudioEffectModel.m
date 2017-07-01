//
//  AudioEffectModel.m
//  LiveForMobile
//
//  Created by  Sierra on 2017/6/26.
//  Copyright © 2017年 BaiFuTak. All rights reserved.
//

#import "AudioEffectModel.h"

@implementation AudioEffectModel

#pragma mark - Life cycle

- (instancetype)init {
    if (self = [super init]) {
        self.name = @"";
        self.selected = NO;
    }
    return self;
}

@end
