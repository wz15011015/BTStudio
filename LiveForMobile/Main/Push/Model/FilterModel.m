//
//  FilterModel.m
//  LiveForMobile
//
//  Created by  Sierra on 2017/6/23.
//  Copyright © 2017年 BaiFuTak. All rights reserved.
//

#import "FilterModel.h"

@implementation FilterModel

#pragma mark - Life cycle

- (instancetype)init {
    if (self = [super init]) {
        self.title = @"";
        self.icon = @"";
        self.selected = NO;
    }
    return self;
}


#pragma mark - Override

- (void)setValue:(id)value forUndefinedKey:(NSString *)key {
    
}

@end
