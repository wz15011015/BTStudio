//
//  NSString+BrianExtension.m
//  YiHuiWaiBiDuiHuan
//
//  Created by  Sierra on 2017/4/11.
//  Copyright © 2017年 YIHUALONG Inc. All rights reserved.
//

#import "NSString+BrianExtension.h"
#import <CommonCrypto/CommonDigest.h>
#import "NSData+AES.h"

@implementation NSString (BrianExtension)

- (CGSize)sizeWithFont:(NSFont *)font maxSize:(CGSize)maxSize {
    NSDictionary *attrs = @{NSFontAttributeName : font};
    return [self boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:attrs context:nil].size;
}

/**
 是否为空字符串
 
 @return 是否为空字符串
 */
- (BOOL)isEmptyString {
    if (![self isKindOfClass:[NSString class]]) {
        return TRUE;
    } else if (self == nil) {
        return TRUE;
    } else if (!self) {
        // null object
        return TRUE;
    } else if (self == NULL) {
        // null object
        return TRUE;
    } else if ([self isEqualToString:@"NULL"]) {
        // null object
        return TRUE;
    } else if ([self isEqualToString:@"(null)"]) {
        return TRUE;
    } else {
        //  使用whitespaceAndNewlineCharacterSet删除周围的空白字符串
        //  然后在判断首位字符串是否为空
        NSString *trimedString = [self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        if ([trimedString length] == 0) {
            // empty string
            return TRUE;
        } else {
            // is neither empty nor null
            return FALSE;
        }
    }
}

/**
 判断有无表情字符
 
 @param string 要判断的字符串
 @return 有无表情字符
 */
+ (BOOL)stringContainsEmoji:(NSString *)string {
    __block BOOL returnValue = NO;
    
    [string enumerateSubstringsInRange:NSMakeRange(0, [string length]) options:NSStringEnumerationByComposedCharacterSequences usingBlock:^(NSString *substring, NSRange substringRange, NSRange enclosingRange, BOOL *stop) {
        
        const unichar hs = [substring characterAtIndex:0];
        if (0xd800 <= hs && hs <= 0xdbff) {
            if (substring.length > 1) {
                const unichar ls = [substring characterAtIndex:1];
                const int uc = ((hs - 0xd800) * 0x400) + (ls - 0xdc00) + 0x10000;
                if (0x1d000 <= uc && uc <= 0x1f77f) {
                    returnValue = YES;
                }
            }
        } else if (substring.length > 1) {
            const unichar ls = [substring characterAtIndex:1];
            if (ls == 0x20e3) {
                returnValue = YES;
            }
        } else {
            if (0x2100 <= hs && hs <= 0x27ff) {
                returnValue = YES;
            } else if (0x2B05 <= hs && hs <= 0x2b07) {
                returnValue = YES;
            } else if (0x2934 <= hs && hs <= 0x2935) {
                returnValue = YES;
            } else if (0x3297 <= hs && hs <= 0x3299) {
                returnValue = YES;
            } else if (hs == 0xa9 || hs == 0xae || hs == 0x303d || hs == 0x3030 || hs == 0x2b55 || hs == 0x2b1c || hs == 0x2b1b || hs == 0x2b50) {
                returnValue = YES;
            }
        }
    }];
    
    return returnValue;
}


#pragma mark - 正则判断
/**
 正则判断手机号格式
 
 @param phone 要判断的手机号字符串
 @return 是否符合手机号格式
 */
+ (BOOL)validatePhoneNumber:(NSString *)phone {
    /**
     * 手机号码
     * 移动：134[0-8],135,136,137,138,139,150,151,157,158,159,17[0-9],182,187,188
     * 联通：130,131,132,152,155,156,185,186
     * 电信：133,1349,153,180,189
     */
    NSString *MOBILE = @"^1(3[0-9]|5[0-35-9]|7[0-9]|8[025-9])\\d{8}$"; // @"^1(3[0-9]|5[0-35-9]|8[025-9])\\d{8}$";
    
    /**
     10         * 中国移动：China Mobile
     11         * 134[0-8],135,136,137,138,139,150,151,157,158,159,182,187,188
     12         */
    NSString *CM = @"^1(34[0-8]|(3[5-9]|5[017-9]|8[278])\\d)\\d{7}$";
    
    /**
     15         * 中国联通：China Unicom
     16         * 130,131,132,152,155,156,185,186
     17         */
    NSString *CU = @"^1(3[0-2]|5[256]|8[56])\\d{8}$";
    
    /**
     20         * 中国电信：China Telecom
     21         * 133,1349,153,180,189
     22         */
    NSString *CT = @"^1((33|53|8[09])[0-9]|349)\\d{7}$";
    
    /**
     25         * 大陆地区固话及小灵通
     26         * 区号：010,020,021,022,023,024,025,027,028,029
     27         * 号码：七位或八位
     28         */
    // NSString *PHS = @"^0(10|2[0-5789]|\\d{3})\\d{7,8}$";
    
    NSPredicate *regextestmobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", MOBILE];
    NSPredicate *regextestcm = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CM];
    NSPredicate *regextestcu = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CU];
    NSPredicate *regextestct = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CT];
    
    if (([regextestmobile evaluateWithObject:phone] == YES)
        || ([regextestcm evaluateWithObject:phone] == YES)
        || ([regextestct evaluateWithObject:phone] == YES)
        || ([regextestcu evaluateWithObject:phone] == YES)) {
        
        if ([regextestcm evaluateWithObject:phone] == YES) {
            NSLog(@"China Mobile");
        } else if ([regextestct evaluateWithObject:phone] == YES) {
            NSLog(@"China Telecom");
        } else if ([regextestcu evaluateWithObject:phone] == YES) {
            NSLog(@"China Unicom");
        } else {
            NSLog(@"Unknow");
        }
        return YES;
    } else {
        return NO;
    }
}

/**
 正则判断手机号格式(与服务器端保持一致的)
 
 @param phone 要判断的手机号字符串
 @return 是否符合手机号格式
 */
+ (BOOL)validatePhoneNumberWithServer:(NSString *)phone {
    NSString *regex = @"^0?(13|14|15|18|17)[0-9]{9}$";
    NSPredicate *test = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    return [test evaluateWithObject:phone];
}

/**
 正则判断邮箱地址格式
 
 @param email 要判断的字符串
 @return 是否符合邮箱地址格式
 */
+ (BOOL)validateEmail:(NSString *)email {
    NSString *regex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *test = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    return [test evaluateWithObject:email];
}

/**
 正则判断URL超链接格式
 
 @param urlString 要判断的字符串
 @return 是否符合超链接格式
 */
+ (BOOL)validateURL:(NSString *)urlString {
    NSString *regex = @"((http|ftp|https)://)(([a-zA-Z0-9\\._-]+\\.[a-zA-Z]{2,6})|([0-9]{1,3}\\.[0-9]{1,3}\\.[0-9]{1,3}\\.[0-9]{1,3}))(:[0-9]{1,4})*(/[a-zA-Z0-9\\&%_\\./-~-]*)?";
    NSPredicate *test = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    return [test evaluateWithObject:urlString];
}

/**
 正则判断是否为汉字
 
 @param string 要判断的字符串
 @return 是否为汉字
 */
+ (BOOL)validateZH_Hans:(NSString *)string {
    NSString *regex = @"^[\u4e00-\u9fa5]+$";
    NSPredicate *test = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    return [test evaluateWithObject:string];
}

/**
 正则判断是否为字母、数字、下划线、横线
 
 @param string 要判断的字符串
 @return 是否为字母、数字、下划线、横线
 */
+ (BOOL)validateLettersOrNumbers:(NSString *)string {
    // 完全只能输入英文字母，数字，下划线，横线，加号及点就是这个： ^([a-z_A-Z-.+0-9]+)$
    
    NSString *regex = @"^[a-zA-Z0-9_-]+$"; // @"^[A-Z-a-z_0-9]+$"
    NSPredicate *test = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    return [test evaluateWithObject:string];
}


#pragma mark - SHA1加密
/**
 SHA1加密  安全哈希算法（Secure Hash Algorithm）
 
 @return SHA1加密后的40位字符串
 */
- (NSString *)sha1Encryption {
    NSString *string = self;
    
    NSData *data = [string dataUsingEncoding:NSUTF8StringEncoding];
    uint8_t result[CC_SHA1_DIGEST_LENGTH];
    
    CC_SHA1(data.bytes, (CC_LONG)data.length, result);
    
    NSMutableString *output = [NSMutableString stringWithCapacity:CC_SHA1_DIGEST_LENGTH * 2];
    for (int i = 0; i < CC_SHA1_DIGEST_LENGTH; i++) {
        [output appendFormat:@"%02X", result[i]];
    }
    return output;
}


#pragma mark - MD5加密
/**
 16位的MD5加密(取的是中间的16位)
 
 @return MD5加密后的16位字符串(取的是中间的16位)
 */
- (NSString *)md5_16 {
    const char *cStr = [self UTF8String];
    uint8_t result[CC_MD5_DIGEST_LENGTH];
    
    CC_MD5(cStr, (CC_LONG)strlen(cStr), result);
    
    return [[NSString stringWithFormat:@"%02X%02X%02X%02X%02X%02X%02X%02X",
             result[4], result[5], result[6], result[7],
             result[8], result[9], result[10], result[11]
           ] lowercaseString];
}

/**
 32位的MD5加密

 @return MD5加密后的32位字符串
 */
- (NSString *)md5_32 {
    const char *cStr = [self UTF8String];
    uint8_t result[CC_MD5_DIGEST_LENGTH];
    
    /* extern unsigned char *CC_MD5(const void *data, CC_LONG len, unsigned char *md); 是官方封装好的加密方法,把cStr字符串转换成了32位的16进制数
     (这个过程不可逆转),存储到了result这个数组中.
     */
    CC_MD5(cStr, (CC_LONG)strlen(cStr), result);
    
    /*
     X:表示十六进制，%02X:表示不足两位的用0补齐，如果多余两位则不影响
     NSLog("%02X", 0x888);  // 888
     NSLog("%02X", 0x4); // 04
     */
    return [[NSString stringWithFormat:@"%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X",
             result[0], result[1], result[2], result[3],
             result[4], result[5], result[6], result[7],
             result[8], result[9], result[10], result[11],
             result[12], result[13], result[14], result[15]
           ] lowercaseString];
}


#pragma mark - AES加密

// 加密
- (NSString *)AES256_EncryptWithKey:(NSString *)key {
    const char *cstr = [self cStringUsingEncoding:NSUTF8StringEncoding];
    NSData *data = [NSData dataWithBytes:cstr length:self.length];
    // 对数据进行加密
    NSData *result = [data AES256_Encrypt:key];
    
    // 转换为二进制字符串
    if (result && result.length > 0) {
        Byte *datas = (Byte *)[result bytes];
        NSMutableString *output = [NSMutableString stringWithCapacity:result.length * 2];
        for(int i = 0; i < result.length; i++){
            [output appendFormat:@"%02x", datas[i]];
        }
        return output;
    }
    return nil;
}

// 解密
- (NSString *)AES256_DecryptWithKey:(NSString *)key {
    // 转换为二进制Data
    NSMutableData *data = [NSMutableData dataWithCapacity:self.length / 2];
    unsigned char whole_byte;
    char byte_chars[3] = {'\0', '\0', '\0'};
    int i;
    for (i = 0; i < [self length] / 2; i++) {
        byte_chars[0] = [self characterAtIndex:i * 2];
        byte_chars[1] = [self characterAtIndex:i * 2 + 1];
        whole_byte = strtol(byte_chars, NULL, 16);
        [data appendBytes:&whole_byte length:1];
    }
    
    // 对数据进行解密
    NSData *result = [data AES256_Decrypt:key];
    if (result && result.length > 0) {
        return [[NSString alloc] initWithData:result encoding:NSUTF8StringEncoding];
    }
    return nil;
}


// Unicode编码转汉字
+ (NSString *)replaceUnicode:(NSString *)unicodeStr {
    NSString *tempStr1 = [unicodeStr stringByReplacingOccurrencesOfString:@"\\u" withString:@"\\U"];
    NSString *tempStr2 = [tempStr1 stringByReplacingOccurrencesOfString:@"\"" withString:@"\\\""];
    NSString *tempStr3 = [[@"\"" stringByAppendingString:tempStr2] stringByAppendingString:@"\""];
    NSData *tempData = [tempStr3 dataUsingEncoding:NSUTF8StringEncoding];
//    NSString *returnStr = [NSPropertyListSerialization propertyListFromData:tempData mutabilityOption:NSPropertyListImmutable format:NULL errorDescription:NULL];
    NSString *returnStr = [NSPropertyListSerialization propertyListWithData:tempData options:NSPropertyListImmutable format:NULL error:NULL];
    
    //NSLog(@"Output = %@", returnStr);
    return [returnStr stringByReplacingOccurrencesOfString:@"\\r\\n" withString:@"\n"];
}

@end
