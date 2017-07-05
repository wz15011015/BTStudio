//
//  HomeViewController.m
//  LiveForMobile
//
//  Created by  Sierra on 2017/6/20.
//  Copyright © 2017年 BaiFuTak. All rights reserved.
//

#import "HomeViewController.h"
#import "TXRTMPSDK/TXLivePush.h"

@interface HomeViewController ()

@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    // 打印SDK的版本信息
    NSLog(@"SDK Version: %@", [[TXLivePush getSDKVersion] componentsJoinedByString:@"."]);
    
    // 根据用户ID生成推流／拉流地址
    NSString *userID = [NSString stringWithFormat:@"022%02d%02d%02d", arc4random() % 100, arc4random() % 100, arc4random() % 100];
    NSLog(@"随机生成的用户ID: %@", userID); // 022838677
    NSString *streamName = [NSString stringWithFormat:@"DaNiu%@", userID];
    NSString *rtmpPushURL = [self lecloudRTMPAddressWithDomain:LecloudRTMPPushDomain streamName:streamName appKey:LecloudAppSignSecretKey];
    NSString *rtmpPullURL = [self lecloudRTMPPullAddressWithDomain:LecloudRTMPPullDomain streamName:streamName appKey:LecloudAppSignSecretKey];
    NSLog(@"乐视云--推流URL: %@", rtmpPushURL);
    NSLog(@"乐视云--拉流URL: %@", rtmpPullURL);
}


#pragma mark - 乐视云-推流URL/播放URL生成规则

/*
 推流url规则: rtmp://推流域名/live/流名称?tm=yyyyMMddHHmmss&sign=xxx
 播放sign规则: sign参数 = MD5(流名称 + tm参数 + 私钥)
 其中流名称可以是任意数字、字母的组合
 示例: rtmp://400438.mpush.live.lecloud.com/live/mytest1?tm=20160406154640&sign=c445f98bed147e4463185efa4a639978
 
 播放url规则: rtmp://播放域名/live/流名称?tm=yyyyMMddHHmmss&sign=xxx
 播放sign规则: sign参数 = MD5(流名称 + tm参数 + 私钥 + “lecloud”)
 其中流名称可以是任意数字、字母的组合
 示例: rtmp://400438.mpull.live.lecloud.com/live/mytest1?tm=20160406154640&sign=7922d30aefbe2740c55bc6b032736208
 */

/**
 推流URL生成

 @param domain 推流域名
 @param stream 流名称
 @param appKey 签名密钥
 @return 推流地址
 */
- (NSString *)lecloudRTMPAddressWithDomain:(NSString *)domain streamName:(NSString *)stream appKey:(NSString *)appKey {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyyMMddHHmmss"];
    NSString *currentDateStr = [dateFormatter stringFromDate:[NSDate date]];
    
    NSString *signStr = [NSString stringWithFormat:@"%@%@%@", stream, currentDateStr, appKey];
    NSString *sign = [signStr md5_32];
    NSString *result = [NSString stringWithFormat:@"rtmp://%@/%@/%@?&tm=%@&sign=%@", domain, LecloudPublishingPointKey, stream, currentDateStr, sign];
    return result;
}

/**
 拉流URL生成

 @param domain 推流域名
 @param stream 流名称
 @param appKey 签名密钥
 @return 拉流地址
 */
- (NSString *)lecloudRTMPPullAddressWithDomain:(NSString *)domain streamName:(NSString *)stream appKey:(NSString *)appKey {
    NSString *rtmpPullURL = [self lecloudRTMPAddressWithDomain:domain streamName:stream appKey:[NSString stringWithFormat:@"%@lecloud", appKey]];
    return rtmpPullURL;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
