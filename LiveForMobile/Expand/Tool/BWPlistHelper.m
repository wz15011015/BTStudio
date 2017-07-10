//
//  BWPlistHelper.m
//  LiveForMobile
//
//  Created by  Sierra on 2017/7/6.
//  Copyright © 2017年 BaiFuTak. All rights reserved.
//

#import "BWPlistHelper.h"

NSString *const PlistPrimaryKey = @"Gift";

@interface BWPlistHelper ()

@property (nonatomic, strong) NSArray *giftArr;

@end

@implementation BWPlistHelper

- (instancetype)initWithPropertyListFileName:(NSString *)fileName {
    if (self = [super init]) {
        NSArray *fileNameArr = [fileName componentsSeparatedByString:@"."];
        if (fileNameArr.count != 2) {
            NSLog(@"文件名称不合法. [须为: file.plist 格式]");
            return self;
        }
        // 1. 获取文件路径
        NSLog(@"文件名称: %@   文件类型: %@", fileNameArr.firstObject, fileNameArr.lastObject);
        NSString *filePath = [[NSBundle mainBundle] pathForResource:fileNameArr.firstObject ofType:fileNameArr.lastObject];
        // 2. 读取plist文件的内容到字典中
        NSDictionary *dic = [NSDictionary dictionaryWithContentsOfFile:filePath];
        // 3. 将内容读取到数组中
        if ([[dic allKeys] containsObject:PlistPrimaryKey]) {
            self.giftArr = [NSArray arrayWithArray:dic[PlistPrimaryKey]];
        }
    }
    return self;
}


#pragma mark - Getters

- (NSArray *)giftArr {
    if (!_giftArr) {
        _giftArr = [NSArray array];
    }
    return _giftArr;
}

- (NSUInteger)giftCount {
    return self.giftArr.count;
}


#pragma mark - Public Methods

/** 根据礼物ID获取礼物图片 */
- (NSArray *)imagesWithGiftId:(NSString *)giftId {
    __block NSMutableArray *images = [NSMutableArray array];
    
    [self.giftArr enumerateObjectsUsingBlock:^(NSDictionary *dic, NSUInteger idx, BOOL * _Nonnull stop) { 
        if ([giftId isEqualToString:dic[@"giftId"]]) {
            NSArray *nameArr = [NSArray arrayWithArray:dic[@"images"]];
            
            for (int i = 0; i < nameArr.count; i++) {
                NSString *imageName = nameArr[i];
                // 1. 在图片使用完成后，不会直接被释放掉，具体释放时间由系统决定，适用于图片小，常用的图像处理
                UIImage *image = [UIImage imageNamed:imageName];
                
                // 2. 如果要快速释放图片，可以使用[UIImage imageWithContentsOfFile:path]实例化图像
//                NSString *filePath = [[NSBundle mainBundle] pathForResource:imageName ofType:nil];
//                UIImage *image = [UIImage imageWithContentsOfFile:filePath];
                if (image) {
                    [images addObject:image];
                }
            }
            *stop = YES;
        }
    }];
    return images;
}

/** 根据礼物ID获取礼物展示时长 */
- (float)durationWithGiftId:(NSString *)giftId {
    __block float duration = 0;
    [self.giftArr enumerateObjectsUsingBlock:^(NSDictionary *dic, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([giftId isEqualToString:dic[@"giftId"]]) {
            NSString *durationStr = dic[@"giftImageDuration"];
            duration = [durationStr floatValue];
            *stop = YES;
        }
    }];
    return duration;
}

/** 根据礼物ID获取礼物图片的X值 */
- (CGFloat)imageXWithGiftId:(NSString *)giftId {
    __block CGFloat value = 0;
    [self.giftArr enumerateObjectsUsingBlock:^(NSDictionary *dic, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([giftId isEqualToString:dic[@"giftId"]]) {
            NSString *valueStr = dic[@"giftImageX"];
            value = [valueStr floatValue];
            *stop = YES;
        }
    }];
    return value;
}

/** 根据礼物ID获取礼物图片的Y值 */
- (CGFloat)imageYWithGiftId:(NSString *)giftId {
    __block CGFloat value = 0;
    [self.giftArr enumerateObjectsUsingBlock:^(NSDictionary *dic, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([giftId isEqualToString:dic[@"giftId"]]) {
            NSString *valueStr = dic[@"giftImageY"];
            value = [valueStr floatValue];
            *stop = YES;
        }
    }];
    return value;
}

/** 根据礼物ID获取礼物图片的宽度 */
- (CGFloat)imageWWithGiftId:(NSString *)giftId {
    __block CGFloat value = 0;
    [self.giftArr enumerateObjectsUsingBlock:^(NSDictionary *dic, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([giftId isEqualToString:dic[@"giftId"]]) {
            NSString *valueStr = dic[@"giftImageW"];
            value = [valueStr floatValue];
            *stop = YES;
        }
    }];
    return value;
}

/** 根据礼物ID获取礼物图片的高度 */
- (CGFloat)imageHWithGiftId:(NSString *)giftId {
    __block CGFloat value = 0;
    [self.giftArr enumerateObjectsUsingBlock:^(NSDictionary *dic, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([giftId isEqualToString:dic[@"giftId"]]) {
            NSString *valueStr = dic[@"giftImageH"];
            value = [valueStr floatValue];
            *stop = YES;
        }
    }];
    return value;
}

@end
