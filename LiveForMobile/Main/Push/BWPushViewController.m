//
//  BWPushViewController.m
//  LiveForMobile
//
//  Created by  Sierra on 2017/6/21.
//  Copyright © 2017年 BaiFuTak. All rights reserved.
//

#import "BWPushViewController.h"
#import <AVFoundation/AVFoundation.h>
#import <sys/types.h>
#import <sys/sysctl.h>
#import <MediaPlayer/MediaPlayer.h>
#import "TXRTMPSDK/TXLivePush.h"
#import "BWPushDecorateView.h"


// 播放地址(拉流地址): rtmp://20994.mpull.live.lecloud.com/live/leshiTest?&tm=20170627094926&sign=f190180247eb94c8db6f8b49177e83d9
#define RTMP_PUBLISH_URL @"rtmp://20994.mpush.live.lecloud.com/live/leshiTest?&tm=20170627094929&sign=5c9ce4e8d4531606ee3cb16d3bcfe9c7"

@interface BWPushViewController () <TXLivePushListener, BWPushDecorateDelegate, MPMediaPickerControllerDelegate> {
    BOOL _isPreviewing;  // 是否已开始推流画面的预览
    BOOL _firstAppear;
    BOOL _torch_on;      // 照明灯是否打开
    BOOL _camera_switch; // 前后摄像头切换
    
    float _bigEyeLevel;    // 大眼参数值
    float _slimFaceLevel;  // 瘦脸参数值
    float _beautyLevel;    // 美颜参数值
    float _whiteningLevel; // 美白参数值
}

@property (nonatomic, copy) NSString *rtmpURL; // 推流地址
@property (nonatomic, strong) TXLivePushConfig *livePushConfig;
@property (nonatomic, strong) TXLivePush *livePush;

@property (nonatomic, strong) UIView *videoParentView; // 视频画面的父view
@property (nonatomic, strong) BWPushDecorateView *decorateView;

@end

@implementation BWPushViewController

#pragma mark - Life Cycle

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 1. 初始化
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onAppDidEnterBackground:) name:UIApplicationDidEnterBackgroundNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onAppWillEnterForeground:) name:UIApplicationWillEnterForegroundNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onAppWillResignActive:) name:UIApplicationWillResignActiveNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onAppDidBecomeActive:) name:UIApplicationDidBecomeActiveNotification object:nil];
    // 1.0 初始化参数
    _isPreviewing = NO;
    _firstAppear = YES;
    _torch_on = NO;
    _camera_switch = NO;
    self.rtmpURL = RTMP_PUBLISH_URL;
    _beautyLevel = 9;
    _whiteningLevel = 3;
    
    // 1.1 推流配置对象
    self.livePushConfig = [[TXLivePushConfig alloc] init];
    self.livePushConfig.frontCamera = NO;
    self.livePushConfig.enableAutoBitrate = NO;
    self.livePushConfig.videoResolution = [self isSuitableMachine:5] ? VIDEO_RESOLUTION_TYPE_540_960 : VIDEO_RESOLUTION_TYPE_360_640; // 由于iphone4s及以下机型前置摄像头不支持540p，故iphone4s及以下采用360p
    self.livePushConfig.videoBitratePIN = 10000;
    self.livePushConfig.enableHWAcceleration = YES;
    // 后台推流的配置
    self.livePushConfig.pauseFps = 10;
    self.livePushConfig.pauseTime = 300;
    self.livePushConfig.pauseImg = [UIImage imageNamed:@"pause_publish.jpg"];
    // 是否就近选路
    self.livePushConfig.enableNearestIP = NO;
    // 耳返
    self.livePushConfig.enableAudioPreview = YES;
    // 1.2 推流对象
    self.livePush = [[TXLivePush alloc] initWithConfig:self.livePushConfig];
    // 美颜初始值
    [self.livePush setBeautyFilterDepth:_beautyLevel setWhiteningFilterDepth:_whiteningLevel];
    
    // 2. 添加控件
    // 2.1 视频画面的父view
    self.videoParentView = [[UIView alloc] initWithFrame:self.view.bounds];
    [self.view addSubview:self.videoParentView];
    // 2.2 推流模块逻辑view, 里面展示了消息列表，弹幕动画，观众列表，美颜，美白等UI
    self.decorateView = [[BWPushDecorateView alloc] initWithFrame:self.view.bounds];
    self.decorateView.delegate = self;
    self.decorateView.parentViewController = self;
    [self.view addSubview:self.decorateView];
    
    // 3. 开始推流
    [self startRTMP];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBarHidden = YES;
    
    if (self.rtmpURL) {
        [self startRTMP];
    }
    
    if (!_firstAppear) {
        // 是否有摄像头权限
        AVAuthorizationStatus cameraStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
        if (cameraStatus == AVAuthorizationStatusDenied) {
            return;
        }
        if (!_isPreviewing) {
            [self.livePush startPreview:self.videoParentView];
            _isPreviewing = YES;
        }
    } else {
        _firstAppear = NO;
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    self.navigationController.navigationBarHidden = NO;
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    
    [self stopRTMP];
}


#pragma mark - Methods

// 开始推流
- (BOOL)startRTMP {
    // 1. 判断推流地址是否合法
    if (self.rtmpURL.length == 0) {
        self.rtmpURL = RTMP_PUBLISH_URL;
    }
    if (![self.rtmpURL hasPrefix:@"rtmp://"]) {
        NSLog(@"推流地址不合法，目前只支持rtmp协议的推流！");
        return NO;
    }
    
    // 2. 检查系统硬件访问权限
    // 是否有摄像头权限
    AVAuthorizationStatus cameraStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    if (cameraStatus == AVAuthorizationStatusDenied) {
        return NO;
    }
    // 是否有麦克风权限
    AVAuthorizationStatus audioStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeAudio];
    if (audioStatus == AVAuthorizationStatusDenied) {
        return NO;
    }
    
    // 3. 检查推流对象
    if (!self.livePush) {
        return NO;
    }
    self.livePush.delegate = self;
    [self.livePush setVideoQuality:VIDEO_QUALITY_HIGH_DEFINITION];
    if (!_isPreviewing) {
        [self.livePush startPreview:self.videoParentView];
        _isPreviewing = YES;
    }
    if ([self.livePush startPush:self.rtmpURL] != 0) {
        NSLog(@"推流器启动失败！");
        return NO;
    }
    
    // 关闭系统空闲定时器，保持屏幕常亮
    [[UIApplication sharedApplication] setIdleTimerDisabled:YES];
    
    return YES;
}

// 结束推流
- (void)stopRTMP {
    if (!self.livePush) {
        return;
    }
    self.livePush.delegate = nil;
    [self.livePush stopPreview];
    _isPreviewing = NO;
    [self.livePush stopPush];
    self.livePush.config.pauseImg = nil;
    self.livePush = nil;
    
    // 恢复系统空闲定时器
    [[UIApplication sharedApplication] setIdleTimerDisabled:NO];
}


#pragma mark - BWPushDecorateDelegate (UI Events)

// 结束直播
- (void)closeRTMP {
    [self stopRTMP];
}

// 退出直播页面
- (void)closePushViewController {
    [self.navigationController popViewControllerAnimated:YES];
}

// 手动聚焦
- (void)clickScreen:(UITapGestureRecognizer *)gestureRecognizer {
    CGPoint touchPoint = [gestureRecognizer locationInView:self.videoParentView];
    [self.livePush setFocusPosition:touchPoint];
}

// 打开或关闭照明灯
- (void)clickTorch:(UIButton *)button {
    if (!self.livePush) {
        return;
    }
    if (self.livePush.frontCamera) {
        NSLog(@"当前为前置摄像头状态，不能启动照明灯");
        return;
    }
    
    _torch_on = !_torch_on;
    if (![self.livePush toggleTorch:_torch_on]) {
        _torch_on = !_torch_on;
        NSLog(@"照明灯启动失败");
    }
    if (_torch_on) {
        [button setImage:[UIImage imageNamed:@"push_torch_on"] forState:UIControlStateNormal];
    } else {
        [button setImage:[UIImage imageNamed:@"push_torch_off"] forState:UIControlStateNormal];
    }
}

// 切换前后摄像头
- (void)clickCameraSwitch:(UIButton *)button {
    if (!self.livePush) {
        return;
    }
    _camera_switch = !_camera_switch;
    [self.livePush switchCamera];
    
    if (self.livePush.frontCamera) { // 切换为前置摄像头时，照明灯会被关闭
        _torch_on = NO;
        [self.decorateView.torchButton setImage:[UIImage imageNamed:@"push_torch_off"] forState:UIControlStateNormal];
    }
}

// 显示美颜效果设置界面
- (void)clickBeauty:(UIButton *)button {
}

// 设置美颜效果参数值 及 BGM音量/麦克风音量大小
- (void)sliderValueChange:(UISlider *)sender {
    if (sender.tag == 111) { // 大眼
        _bigEyeLevel = sender.value;
        [self.livePush setEyeScaleLevel:_bigEyeLevel];
    } else if (sender.tag == 112) { // 瘦脸
        _slimFaceLevel = sender.value;
        [self.livePush setFaceScaleLevel:_slimFaceLevel];
    } else if (sender.tag == 113) { // 美颜
        _beautyLevel = sender.value;
        [self.livePush setBeautyFilterDepth:_beautyLevel setWhiteningFilterDepth:_whiteningLevel];
    } else if (sender.tag == 114) { // 美白
        _whiteningLevel = sender.value;
        [self.livePush setBeautyFilterDepth:_beautyLevel setWhiteningFilterDepth:_whiteningLevel];
    } else if (sender.tag == 115) { // 背景音乐音量调整
        [self.livePush setBGMVolume:sender.value / sender.maximumValue];
    } else if (sender.tag == 116) { // 人声(麦克风)音量调整
        [self.livePush setMicVolume:sender.value / sender.maximumValue];
    }
}

// 设置滤镜效果 (选择了滤镜类型和滤镜文件名称)
- (void)selectedFilter:(BWLiveFilterType)filterType fileName:(NSString *)fileName {
    if (self.livePush == nil) {
        return;
    }
    
    UIImage *filterImage = [UIImage imageNamed:fileName];
    if (filterImage == nil || filterType == FilterType_none) {
        [self.livePush setFilter:nil];
    } else {
        [self.livePush setFilter:filterImage];
    }
}

// 选择背景音乐
- (void)selectBGM:(UIButton *)button {
    //    MPMediaPickerController *mediaPickerController = [[MPMediaPickerController alloc] initWithMediaTypes:MPMediaTypeAnyAudio];
    //    mediaPickerController.delegate = self;
    //    mediaPickerController.editing = YES;
    //    [self presentViewController:mediaPickerController animated:YES completion:nil];
}

// 关闭背景音乐
- (void)closeBGM:(UIButton *)button {
    [self.livePush stopBGM];
}

// 设置音效类型
- (void)selectAudioEffect:(TXReverbType)effectType {
    if (self.livePush == nil) {
        return;
    }
    [self.livePush setReverbType:effectType];
}


#pragma mark - TXLivePushListener (推流相关事件)

- (void)onPushEvent:(int)EvtID withParam:(NSDictionary *)param {
    NSDictionary *paraDic = param;
    
    dispatch_async(dispatch_get_main_queue(), ^{
        if (EvtID >= 0) {
            if (EvtID == PUSH_WARNING_HW_ACCELERATION_FAIL) {
                self.livePush.config.enableHWAcceleration = NO;
            } else if (EvtID == PUSH_EVT_PUSH_BEGIN) { // 该事件表示推流成功，可以通知业务server将该流置为上线状态
                
            } else if (EvtID == PUSH_EVT_CONNECT_SUCC) { // 已经连接推流服务器
                //                BOOL isWIFIReachable = [AFNetworkReachabilityManager sharedManager].reachableViaWiFi;
                //                if (isWIFIReachable) {
                //                    [[AFNetworkReachabilityManager sharedManager] setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
                //                        if (self.rtmpURL.length == 0) {
                //                            return;
                //                        }
                //                        if (status == AFNetworkReachabilityStatusReachableViaWiFi) {
                //                            UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:@"" preferredStyle:UIAlertControllerStyleAlert];
                //                            [alert addAction:[UIAlertAction actionWithTitle:@"否" style:UIAlertActionStyleCancel handler:nil]];
                //                            [alert addAction:[UIAlertAction actionWithTitle:@"是" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                //                                [self stopRTMP];
                //                            }]];
                //                            [self presentViewController:alert animated:YES completion:nil];
                //                        }
                //                    }];
                //                }
            } else if (EvtID == PUSH_WARNING_NET_BUSY) {
                NSLog(@"您当前的网络环境不佳，请尽快更换网络保证正常直播");
            }
        } else {
            if (EvtID == PUSH_ERR_NET_DISCONNECT) { // 网络断连,且经三次抢救无效,可以放弃治疗,更多重试请自行重启推流
                
            } else if (EvtID == PUSH_ERR_OPEN_CAMERA_FAIL) { // 打开摄像头失败
                
            } else if (EvtID == PUSH_ERR_OPEN_MIC_FAIL) { // 打开麦克风失败
                
            } else {
                if (EvtID != PUSH_ERR_VIDEO_ENCODE_FAIL) { // 视频编码失败
                    
                }
            }
        }
    });
    
    long long time = [(NSNumber *)[paraDic valueForKey:EVT_TIME] longLongValue];
    int mil = time % 1000;
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:time / 1000];
    NSString *msg = (NSString *)[paraDic valueForKey:EVT_MSG];
    [self appendLog:msg time:date mills:mil];
}

- (void)onNetStatus:(NSDictionary *)param {
    NSDictionary *paraDic = param;
    
    dispatch_async(dispatch_get_main_queue(), ^{
        int netspeed  = [(NSNumber *)[paraDic valueForKey:NET_STATUS_NET_SPEED] intValue];
        int vbitrate  = [(NSNumber *)[paraDic valueForKey:NET_STATUS_VIDEO_BITRATE] intValue];
        int abitrate  = [(NSNumber *)[paraDic valueForKey:NET_STATUS_AUDIO_BITRATE] intValue];
        int cachesize = [(NSNumber *)[paraDic valueForKey:NET_STATUS_CACHE_SIZE] intValue];
        int dropsize  = [(NSNumber *)[paraDic valueForKey:NET_STATUS_DROP_SIZE] intValue];
        int jitter    = [(NSNumber *)[paraDic valueForKey:NET_STATUS_NET_JITTER] intValue];
        int fps       = [(NSNumber *)[paraDic valueForKey:NET_STATUS_VIDEO_FPS] intValue];
        int width     = [(NSNumber *)[paraDic valueForKey:NET_STATUS_VIDEO_WIDTH] intValue];
        int height    = [(NSNumber *)[paraDic valueForKey:NET_STATUS_VIDEO_HEIGHT] intValue];
        float cpu_usage    = [(NSNumber *)[paraDic valueForKey:NET_STATUS_CPU_USAGE] floatValue];
        int codecCacheSize = [(NSNumber *)[paraDic valueForKey:NET_STATUS_CODEC_CACHE] intValue];
        int nCodecDropCnt  = [(NSNumber *)[paraDic valueForKey:NET_STATUS_CODEC_DROP_CNT] intValue];
        NSString *serverIP = [paraDic valueForKey:NET_STATUS_SERVER_IP];
        
        NSString *log = [NSString stringWithFormat:@"CPU:%.1f%%\tRES:%d*%d\tSPD:%dkb/s\nJITT:%d\tFPS:%d\tARA:%dkb/s\nQUE:%d|%d\tDRP:%d|%d\tVRA:%dkb/s\nSVR:%@\t",
                         cpu_usage * 100,
                         width,
                         height,
                         netspeed,
                         jitter,
                         fps,
                         abitrate,
                         codecCacheSize,
                         cachesize,
                         nCodecDropCnt,
                         dropsize,
                         vbitrate,
                         serverIP];
        NSLog(@"%@", log);
    });
}


#pragma mark - Notification

- (void)onAppDidEnterBackground:(UIApplication *)app {
    // 暂停背景音乐
    if (self.livePush) {
        [self.livePush pauseBGM];
    }
    
    if ([self.livePush isPublishing]) {
        [[UIApplication sharedApplication] beginBackgroundTaskWithExpirationHandler:^{
            //            [self.livePush resumePush];
        }];
        [self.livePush pausePush];
    }
}

- (void)onAppWillEnterForeground:(UIApplication *)app {
    if (self.rtmpURL) {
        [self startRTMP];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            //            [[NSNotificationCenter defaultCenter] addObserver:_logicView selector:@selector(keyboardFrameDidChange:) name:UIKeyboardWillChangeFrameNotification object:nil];
        });
        return;
    }
    // 恢复背景音乐
    if (self.livePush) {
        [self.livePush resumeBGM];
    }
    
    if ([self.livePush isPublishing]) {
        [self.livePush resumePush];
    }
}

- (void)onAppWillResignActive:(NSNotification *)notification {
    [self.livePush pausePush];
}

- (void)onAppDidBecomeActive:(NSNotification *)notification {
    [self.livePush resumePush];
}


#pragma mark - MPMediaPickerControllerDelegate

- (void)mediaPicker:(MPMediaPickerController *)mediaPicker didPickMediaItems:(MPMediaItemCollection *)mediaItemCollection {
    NSArray *items = mediaItemCollection.items;
    MPMediaItem *item = [items objectAtIndex:0];
    
    NSURL *url = [item valueForProperty:MPMediaItemPropertyAssetURL];
    NSLog(@"MPMediaItemPropertyAssetURL = %@", url);
    if (mediaPicker.editing) {
        mediaPicker.editing = NO;
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.livePush stopBGM];
            [self saveAssetURLToFile:url];
        });
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

- (void)mediaPickerDidCancel:(MPMediaPickerController *)mediaPicker {
    [self dismissViewControllerAnimated:mediaPicker completion:nil];
}

// 将AssetURL(音乐)导出到App的文件夹中并播放
- (void)saveAssetURLToFile:(NSURL *)assetURL {
    AVURLAsset *songAsset = [AVURLAsset URLAssetWithURL:assetURL options:nil];
    
    AVAssetExportSession *exporter = [[AVAssetExportSession alloc] initWithAsset:songAsset presetName:AVAssetExportPresetAppleM4A];
    NSLog(@"Create exporter, supportedFileTypes: %@", exporter.supportedFileTypes);
    exporter.outputFileType = @"com.apple.m4a-audio";
    
    NSString *docDir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *exportFile = [docDir stringByAppendingPathComponent:@"exported.m4a"];
    
    BOOL exists = [[NSFileManager defaultManager] fileExistsAtPath:exportFile];
    if (exists) {
        [[NSFileManager defaultManager] removeItemAtPath:exportFile error:nil];
    }
    exporter.outputURL = [NSURL fileURLWithPath:exportFile];
    
    // do the export
    [exporter exportAsynchronouslyWithCompletionHandler:^{
        int exportStatus = exporter.status;
        switch (exportStatus) {
            case AVAssetExportSessionStatusFailed:
                NSLog(@"AVAssetExportSessionStatusFailed, error: %@", exporter.error);
                break;
            case AVAssetExportSessionStatusCompleted: {
                NSLog(@"AVAssetExportSessionStatusCompleted, %@", exporter.outputURL);
                // 播放背景音乐
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.livePush playBGM:[exporter.outputURL absoluteString]];
                });
            }
                break;
            case AVAssetExportSessionStatusUnknown:
                NSLog(@"AVAssetExportSessionStatusUnknown");
                break;
            case AVAssetExportSessionStatusExporting:
                NSLog(@"AVAssetExportSessionStatusExporting");
                break;
            case AVAssetExportSessionStatusCancelled:
                NSLog(@"AVAssetExportSessionStatusCancelled");
                break;
            case AVAssetExportSessionStatusWaiting:
                NSLog(@"AVAssetExportSessionStatusWaiting");
                break;
            default:
                NSLog(@"didn't get export status.");
                break;
        }
    }];
}


#pragma mark - Tool Methods

- (BOOL)isSuitableMachine:(int)targetPlatNum {
    int mib[2] = {CTL_HW, HW_MACHINE};
    size_t len = 0;
    char *machine;
    
    sysctl(mib, 2, NULL, &len, NULL, 0);
    
    machine = (char *)malloc(len);
    sysctl(mib, 2, machine, &len, NULL, 0);
    
    NSString *platform = [NSString stringWithCString:machine encoding:NSASCIIStringEncoding];
    free(machine);
    if ([platform length] > 6) {
        NSString *platNum = [NSString stringWithFormat:@"%C", [platform characterAtIndex:6]];
        return ([platNum intValue] >= targetPlatNum);
    } else {
        return NO;
    }
}

- (void)appendLog:(NSString *)evt time:(NSDate *)date mills:(int)mil {
    NSDateFormatter *format = [[NSDateFormatter alloc] init];
    format.dateFormat = @"hh:mm:ss";
    NSString *time = [format stringFromDate:date];
    NSString *log = [NSString stringWithFormat:@"[%@.%-3.3d] %@", time, mil, evt];
    //    if (_logMsg == nil) {
    //        _logMsg = @"";
    //    }
    NSString *logMsg = [NSString stringWithFormat:@"%@", log];
    NSLog(@"%@", logMsg);
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
