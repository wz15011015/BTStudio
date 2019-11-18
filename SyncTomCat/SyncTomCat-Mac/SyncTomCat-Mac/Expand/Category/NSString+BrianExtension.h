//
//  NSString+BrianExtension.h
//  YiHuiWaiBiDuiHuan
//
//  Created by  Sierra on 2017/4/11.
//  Copyright © 2017年 YIHUALONG Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AppKit/AppKit.h>

/**
 NSString的功能扩展分类
 */
@interface NSString (BrianExtension)

- (CGSize)sizeWithFont:(NSFont *)font maxSize:(CGSize)maxSize;

/**
 是否为空字符串

 @return 是否为空字符串
 */
- (BOOL)isEmptyString;

/**
 判断有无表情字符
 
 @param string 要判断的字符串
 @return 有无表情字符
 */
+ (BOOL)stringContainsEmoji:(NSString *)string;


#pragma mark - 正则判断
/**
 正则判断手机号格式

 @param phone 要判断的手机号字符串
 @return 是否符合手机号格式
 */
+ (BOOL)validatePhoneNumber:(NSString *)phone;

/**
 正则判断手机号格式(与服务器端保持一致的)

 @param phone 要判断的手机号字符串
 @return 是否符合手机号格式
 */
+ (BOOL)validatePhoneNumberWithServer:(NSString *)phone;

/**
 正则判断邮箱地址格式

 @param email 要判断的字符串
 @return 是否符合邮箱地址格式
 */
+ (BOOL)validateEmail:(NSString *)email;

/**
 正则判断URL超链接格式
 
 @param urlString 要判断的字符串
 @return 是否符合超链接格式
 */
+ (BOOL)validateURL:(NSString *)urlString;

/**
 正则判断是否为汉字

 @param string 要判断的字符串
 @return 是否为汉字
 */
+ (BOOL)validateZH_Hans:(NSString *)string;

/**
 正则判断是否为字母、数字、下划线、横线

 @param string 要判断的字符串
 @return 是否为字母、数字、下划线、横线
 */
+ (BOOL)validateLettersOrNumbers:(NSString *)string;


#pragma mark - SHA1加密
/**
 SHA1加密  安全哈希算法（Secure Hash Algorithm）
 
 @return SHA1加密后的40位字符串
 */
- (NSString *)sha1Encryption;


#pragma mark - MD5加密
/**
 16位的MD5加密(取的是中间的16位)
 
 @return MD5加密后的16位字符串(取的是中间的16位)
 */
- (NSString *)md5_16;

/**
 32位的MD5加密
 
 @return MD5加密后的32位字符串
 */
- (NSString *)md5_32;


#pragma mark - AES加密

// 加密
- (NSString *)AES256_EncryptWithKey:(NSString *)key;

// 解密
- (NSString *)AES256_DecryptWithKey:(NSString *)key;

@end
