//
//  ViewController.m
//  SyncTomCat-iPhone
//
//  Created by  Sierra on 2017/7/18.
//  Copyright © 2017年 BTStudio. All rights reserved.
//

#import "ViewController.h"
#import "BWMacro.h"
#import <AVFoundation/AVFoundation.h>
#import <CoreBluetooth/CoreBluetooth.h>

#define SERVICE_UUID @"6DAC6765-6249-44E4-8EE3-A924401E8717"
#define CHARACTERISTIC_UUID @"F97DE011-D73C-4093-B229-D5756D5FFCAD"

@interface ViewController () <CBCentralManagerDelegate, CBPeripheralDelegate> {
    BOOL _isConnected; // 是否与外设连接
}

@property (nonatomic, strong) UIImageView *backgroundImageView;
@property (nonatomic, strong) UIImageView *animationImageView;
@property (nonatomic, strong) UIView *buttonView;
@property (nonatomic, strong) UIButton *rescanButton;

@property (nonatomic, strong) AVAudioPlayer *audioPlayer;
@property (nonatomic, strong) AVAudioPlayer *otherAudioPlayer;
@property (nonatomic, strong) NSDictionary *animationInfos;

@property (nonatomic, strong) CBCentralManager *centralManager; // 中心设备
@property (nonatomic, strong) CBPeripheral *peripheral; // 外围设备
@property (nonatomic, strong) CBCharacteristic *characteristic; // 外设某个服务中的一个特征

@end

@implementation ViewController

#pragma mark - Life Cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor blackColor];
    
    // 0. 初始化参数
    _isConnected = NO;
    
    // 1. 添加控件
    [self addSubviews];
    
    // 2. 初始化中心设备
//    dispatch_queue_t bleQueue = dispatch_queue_create("BLE", DISPATCH_QUEUE_CONCURRENT);
    self.centralManager = [[CBCentralManager alloc] initWithDelegate:self queue:nil];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    
    if (@available(iOS 11.0, *)) {
        CGRect safeAreaFrame = self.view.safeAreaLayoutGuide.layoutFrame;
        CGRect frame = self.rescanButton.frame;
        frame.origin.y = safeAreaFrame.origin.y;
        self.rescanButton.frame = frame;
    } else {
        CGRect frame = self.rescanButton.frame;
        frame.origin.y = self.topLayoutGuide.length;
        self.rescanButton.frame = frame;
    }
}


#pragma mark - 数据的处理

// 蓝牙收到更新的特征值
- (void)receivedUpdateValueForCharacteristic:(NSData *)value {
    NSString *valueStr = [[NSString alloc] initWithData:value encoding:NSUTF8StringEncoding];
    // 解密一下
    valueStr = [valueStr AES256_DecryptWithKey:AES256EncryptKey];
    NSLog(@"收到的特征值(解密后)是: %@", valueStr);
    
    if ([valueStr containsString:@"BTStudio"]) { // 读取特征的值
        NSLog(@"是匹配的设备");
    }
    
    NSDictionary *animationInfo = [self.animationInfos objectForKey:valueStr];
    if (animationInfo) {
        NSString *name = animationInfo[@"name"]; // 动画名称
        NSString *count = animationInfo[@"count"]; // 动画图片数量
        [self startAnimationWithName:name count:[count integerValue]];
    }
}

// 向外设的特征写入值
- (void)writeValueToPeripheralForCharacteristicWithValue:(NSString *)valueStr {
    if (!self.peripheral || !_isConnected) {
        NSLog(@"向外设的特征写入值时，外设不存在或未连接");
        return;
    }
    if (!self.characteristic) {
        NSLog(@"要写入的特征为空");
        return;
    }
    NSLog(@"向外设的特征写入值，值为: %@", valueStr);
    // 加密一下
    NSString *encryptValue = [valueStr AES256_EncryptWithKey:AES256EncryptKey];
    NSData *value = [encryptValue dataUsingEncoding:NSUTF8StringEncoding];
    [self.peripheral writeValue:value forCharacteristic:self.characteristic type:CBCharacteristicWriteWithResponse];
}


#pragma mark - UI

- (void)addSubviews {
    // 1. 背景ImageView / 动画ImageView / 按钮View
    [self.view addSubview:self.backgroundImageView];
    [self.view addSubview:self.animationImageView];
    [self.view addSubview:self.buttonView];
    
    // 2. 重新扫描按钮
    [self.view addSubview:self.rescanButton];
    
    // 3. 功能按钮
    // 3.1 两侧的功能按钮 (可见)
    CGFloat width = CGRectGetWidth(self.animationImageView.frame);
    CGFloat height = CGRectGetHeight(self.animationImageView.frame);

    __block CGFloat button_x = 6;
    __block CGFloat button_y = height * 0.48;
    CGFloat button_w = 60;
    CGFloat margin = 18;
    NSArray *buttons = @[@"fart_button", @"cymbals_button", @"milk_button", @"bird_button", @"pie_button", @"paw_button"];
    NSArray *button_VO_Labels = @[NSLocalizedString(@"VO_fart", nil),
                                  NSLocalizedString(@"VO_cymbals", nil),
                                  NSLocalizedString(@"VO_drink milk", nil),
                                  NSLocalizedString(@"VO_eat bird", nil),
                                  NSLocalizedString(@"VO_pie", nil),
                                  NSLocalizedString(@"VO_paw", nil)];
    [buttons enumerateObjectsUsingBlock:^(NSString *imageName, NSUInteger idx, BOOL * _Nonnull stop) {
        if (idx == 3) {
            button_x = width - button_x - button_w;
            button_y = height * 0.48;
        }
        
        // 按钮的VoiceOver标签
        NSString *vo_label = button_VO_Labels[idx];
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.tag = 10 + idx;
        button.frame = CGRectMake(button_x, button_y, button_w, button_w);
        [button setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(buttonEvent:) forControlEvents:UIControlEventTouchUpInside];
        button.accessibilityLabel = vo_label;
        [self.buttonView addSubview:button];
        
        button_y = button_y + button_w + margin;
    }];
    
    // 3.2 其他的功能按钮 (不可见)
    // [knockout, happy_simple, happy_simple, yawn, yawn, sneeze, happy, stomach, angry, foot_right, foot_left]
    NSArray *hidden_button_VO_Labels = @[NSLocalizedString(@"VO_knockout", nil),
                                         NSLocalizedString(@"VO_happy simple", nil),
                                         NSLocalizedString(@"VO_happy simple", nil),
                                         NSLocalizedString(@"VO_yawn", nil),
                                         NSLocalizedString(@"VO_yawn", nil),
                                         NSLocalizedString(@"VO_sneeze", nil),
                                         NSLocalizedString(@"VO_happy", nil),
                                         NSLocalizedString(@"VO_stomach", nil),
                                         NSLocalizedString(@"VO_angry", nil),
                                         NSLocalizedString(@"VO_foot", nil),
                                         NSLocalizedString(@"VO_foot", nil)];
    CGFloat happy_simple_w = 65;
    CGFloat happy_simple_h = 72;
    CGFloat yawn_w = 120;
    CGFloat yawn_h = 70;
    CGFloat foot_w = 56;
    CGFloat foot_h = 54;
    for (int i = 0; i < hidden_button_VO_Labels.count; i++) {
        CGFloat x = 0, y = 0, w = 0, h = 0;
        
        if (i == 0) { // knockout
            w = 100;
            h = 48;
            x = (width - w) / 2;
            y = 88;
        } else if (i == 1) { // happy_simple
            w = happy_simple_w;
            h = happy_simple_h;
            x = 72;
            y = 90;
        } else if (i == 2) { // happy_simple
            w = happy_simple_w;
            h = happy_simple_h;
            x = width - 72 - w;
            y = 90;
        } else if (i == 3) { // yawn
            w = yawn_w;
            h = yawn_h;
            x = 20;
            y = 163;
        } else if (i == 4) { // yawn
            w = yawn_w;
            h = yawn_h;
            x = width - 20 - w;
            y = 163;
        } else if (i == 5) { // sneeze
            w = 85;
            h = 48;
            x = (width - w) / 2;
            y = 182;
            
        } else if (i == 6) { // happy
            w = 110;
            h = 80;
            x = (width - w) / 2;
            y = 330;
        } else if (i == 7) { // stomach
            w = 120;
            h = 80;
            x = (width - w) / 2;
            y = 430;
            
        } else if (i == 8) { // angry
            w = 50;
            h = 110;
            x = width - 76 - w;
            y = 440;
        } else if (i == 9) { // foot_right
            w = foot_w;
            h = foot_h;
            x = (width / 2) - w - 5;
            y = height - 70;
        } else if (i == 10) { // foot_left
            w = foot_w;
            h = foot_h;
            x = (width / 2) + 5;
            y = height - 70;
        }
        
        // 按钮的VoiceOver标签
        NSString *voLabel = hidden_button_VO_Labels[i];
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.tag = 16 + i;
        button.frame = CGRectMake(x, y, w, h);
        [button addTarget:self action:@selector(buttonEvent:) forControlEvents:UIControlEventTouchUpInside];
        button.accessibilityLabel = voLabel;
        [self.buttonView addSubview:button];
        // TODO: 调试代码
//        button.backgroundColor = [UIColor grayColor];
//        button.alpha = 0.5;
    }
}

- (void)updateRescanButtonWithText:(NSString *)text {
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.rescanButton setTitle:NSLocalizedString(text, nil) forState:UIControlStateNormal];
        
        // 按钮标题更新时,主动给用户发出VoiceOver内容提示,并更新按钮的accessibilityLabel
        NSString *voText = [NSString stringWithFormat:@"VO_%@", text];
        UIAccessibilityPostNotification(UIAccessibilityAnnouncementNotification, NSLocalizedString(voText, nil));
        self.rescanButton.accessibilityLabel = NSLocalizedString(voText, nil);
    });
}

- (void)startAnimationWithName:(NSString *)name count:(NSUInteger)count {
    if (self.animationImageView.isAnimating) { // 正在动画
        NSLog(@"正在播放动画序列帧");
        return;
    }
    
    NSMutableArray *images = [NSMutableArray arrayWithCapacity:count];
    for (int i = 0; i < count; i++) {
        NSString *imageName = [NSString stringWithFormat:@"%@_%02d.jpg", name, i];
        NSString *path = [[NSBundle mainBundle] pathForResource:imageName ofType:nil];
        UIImage *image = [UIImage imageWithContentsOfFile:path];
        [images addObject:image];
    }
    self.animationImageView.animationImages = images;
    self.animationImageView.animationRepeatCount = 1;
    self.animationImageView.animationDuration = count * 0.1;
    // 开始动画
    [self.animationImageView startAnimating];
    
    // 创建一个音频播放器,播放相应动作的音效
    [self createAudioPlayerWithAudioFile:name];
    
    if ([name isEqualToString:@"fart"]) {
        [self performSelector:@selector(audioPlayerPlay) withObject:nil afterDelay:0.1];
    } else if ([name isEqualToString:@"cymbals"]) {
        [self performSelector:@selector(audioPlayerPlay) withObject:nil afterDelay:0.0];
    } else if ([name isEqualToString:@"drink"]) {
        [self createOtherAudioPlayerWithAudioFile:@"pour_milk"];
        [self performSelector:@selector(otherAudioPlayer) withObject:nil afterDelay:0.8];
        [self performSelector:@selector(audioPlayerPlay) withObject:nil afterDelay:3.2];
    } else if ([name isEqualToString:@"eat"]) {
        [self performSelector:@selector(audioPlayerPlay) withObject:nil afterDelay:1.0];
    } else if ([name isEqualToString:@"pie"]) {
        [self performSelector:@selector(audioPlayerPlay) withObject:nil afterDelay:1.0];
    } else if ([name isEqualToString:@"scratch"]) {
        [self performSelector:@selector(audioPlayerPlay) withObject:nil afterDelay:1.2];
    } else if ([name isEqualToString:@"knockout"]) {
        [self createOtherAudioPlayerWithAudioFile:@"stars2s"];
        [self performSelector:@selector(audioPlayerPlay) withObject:nil afterDelay:1.4];
        [self performSelector:@selector(otherAudioPlayer) withObject:nil afterDelay:1.9];
    } else if ([name isEqualToString:@"happy_simple"]) {
        [self performSelector:@selector(audioPlayerPlay) withObject:nil afterDelay:0.0];
    } else if ([name isEqualToString:@"yawn"]) {
        [self performSelector:@selector(audioPlayerPlay) withObject:nil afterDelay:0.0];
    } else if ([name isEqualToString:@"sneeze"]) {
        [self performSelector:@selector(audioPlayerPlay) withObject:nil afterDelay:0.0];
    } else if ([name isEqualToString:@"happy"]) {
        [self createAudioPlayerWithAudioFile:@"happy_simple"];
        [self performSelector:@selector(audioPlayerPlay) withObject:nil afterDelay:0.0];
    } else if ([name isEqualToString:@"stomach"]) {
        [self createAudioPlayerWithAudioFile:@"p_belly1"];
        [self performSelector:@selector(audioPlayerPlay) withObject:nil afterDelay:0.6];
    } else if ([name isEqualToString:@"angry"]) {
        [self performSelector:@selector(audioPlayerPlay) withObject:nil afterDelay:0.1];
    } else if ([name isEqualToString:@"foot_left"]) {
        [self performSelector:@selector(audioPlayerPlay) withObject:nil afterDelay:0.4];
    } else if ([name isEqualToString:@"foot_right"]) {
        [self performSelector:@selector(audioPlayerPlay) withObject:nil afterDelay:0.7];
    } else {
        [self performSelector:@selector(audioPlayerPlay) withObject:nil afterDelay:0.2];
    }
}

// 创建音频播放器
- (void)createAudioPlayerWithAudioFile:(NSString *)fileName {
    NSString *path = [[NSBundle mainBundle] pathForResource:fileName ofType:@"m4a"];
    if ([fileName isEqualToString:@"fart"]) {
        path = [[NSBundle mainBundle] pathForResource:[NSString stringWithFormat:@"%@_%02d", fileName, arc4random() % 3 + 1] ofType:@"m4a"];
    } else if ([fileName isEqualToString:@"pie"]) {
        path = [[NSBundle mainBundle] pathForResource:[NSString stringWithFormat:@"%@_%02d", fileName, arc4random() % 2 + 1] ofType:@"m4a"];
    }
    
    self.audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:[NSURL fileURLWithPath:path] error:nil];
    [self.audioPlayer prepareToPlay];
}

// 创建其他音频播放器
- (void)createOtherAudioPlayerWithAudioFile:(NSString *)fileName {
    NSString *path = [[NSBundle mainBundle] pathForResource:fileName ofType:@"m4a"];
    self.otherAudioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:[NSURL fileURLWithPath:path] error:nil];
    [self.otherAudioPlayer prepareToPlay];
}

// 播放音频
- (void)audioPlayerPlay {
    [self.audioPlayer play];
}

// 播放其他音频
- (void)otherAudioPlayerPlay {
    [self.otherAudioPlayer play];
}


#pragma mark - Events

/// 动作按钮事件
/// @param sender 按钮
- (void)buttonEvent:(UIButton *)sender {
    if (self.animationImageView.isAnimating) { // 正在动画
        NSLog(@"正在播放动画...");
        return;
    }
    
    NSString *actionName = @"none"; // 动作名称
    if (sender.tag == 10) {
        actionName = @"fart";
    } else if (sender.tag == 11) {
        actionName = @"cymbals";
    } else if (sender.tag == 12) {
        actionName = @"drink";
    } else if (sender.tag == 13) {
        actionName = @"eat";
    } else if (sender.tag == 14) {
        actionName = @"pie";
    } else if (sender.tag == 15) {
        actionName = @"scratch";
    } else if (sender.tag == 16) {
        actionName = @"knockout";
    } else if (sender.tag == 17 || sender.tag == 18) {
        actionName = @"happy_simple";
    } else if (sender.tag == 19 || sender.tag == 20) {
        actionName = @"yawn";
    } else if (sender.tag == 21) {
        actionName = @"sneeze";
    } else if (sender.tag == 22) {
        actionName = @"happy";
    } else if (sender.tag == 23) {
        actionName = @"stomach";
    } else if (sender.tag == 24) {
        actionName = @"angry";
    } else if (sender.tag == 25) {
        actionName = @"foot_right";
    } else if (sender.tag == 26) {
        actionName = @"foot_left";
    }
    NSDictionary *animationInfo = [self.animationInfos objectForKey:actionName];
    if (animationInfo) {
        NSString *name = animationInfo[@"name"];
        NSString *count = animationInfo[@"count"];
        [self startAnimationWithName:name count:[count integerValue]];
    }
    
    // TODO: 调试 从外设读取的功能
    if (sender.tag == 10) {
        // 读取特征的值
        [self.peripheral readValueForCharacteristic:self.characteristic];
    } else {
        [self writeValueToPeripheralForCharacteristicWithValue:actionName];
    }
}

// 重新扫描
- (void)rescanEvent:(UIButton *)sender {
    if (self.centralManager.state == CBManagerStateUnknown) {
        NSLog(@"蓝牙 状态未知");
    } else if (self.centralManager.state == CBManagerStateResetting) {
        NSLog(@"蓝牙 重置中...");
    } else if (self.centralManager.state == CBManagerStateUnsupported) {
        NSLog(@"蓝牙 不支持");
    } else if (self.centralManager.state == CBManagerStateUnauthorized) {
        NSLog(@"蓝牙 未授权");
    } else if (self.centralManager.state == CBManagerStatePoweredOff) {
        NSLog(@"蓝牙 未打开");
    } else {
        BOOL isScanning = self.centralManager.isScanning;
        if (isScanning) {
            NSLog(@"正在扫描中...");
            return;
        }
        
        NSLog(@"蓝牙 已打开，重新扫描外围设备");
        CBUUID *serviceUUID = [CBUUID UUIDWithString:SERVICE_UUID];
        [self.centralManager scanForPeripheralsWithServices:@[serviceUUID] options:@{CBCentralManagerScanOptionAllowDuplicatesKey : @(YES)}];
    }
}


#pragma mark - CBCentralManagerDelegate

// 中心设备的状态变化了
- (void)centralManagerDidUpdateState:(CBCentralManager *)central {
    if (central.state == CBManagerStateUnknown) {
        NSLog(@"蓝牙 状态未知");
    } else if (central.state == CBManagerStateResetting) {
        NSLog(@"蓝牙 重置中...");
    } else if (central.state == CBManagerStateUnsupported) {
        NSLog(@"蓝牙 不支持");
    } else if (central.state == CBManagerStateUnauthorized) {
        NSLog(@"蓝牙 未授权");
    } else if (central.state == CBManagerStatePoweredOff) {
        NSLog(@"蓝牙 未打开");
    } else {
        NSLog(@"蓝牙 已打开，开始扫描外围设备");
        
        // 开始扫描外围设备
        CBUUID *serviceUUID = [CBUUID UUIDWithString:SERVICE_UUID];
        [central scanForPeripheralsWithServices:@[serviceUUID] options:@{CBCentralManagerScanOptionAllowDuplicatesKey : @(YES)}];
    }
}

// MARK: 外围设备
// 发现外围设备
- (void)centralManager:(CBCentralManager *)central didDiscoverPeripheral:(CBPeripheral *)peripheral advertisementData:(NSDictionary<NSString *,id> *)advertisementData RSSI:(NSNumber *)RSSI {
    NSLog(@"发现外围设备");
    // 停止扫描
    [self.centralManager stopScan];
    
    self.peripheral = peripheral;
    // 开始连接该外设
    [self.centralManager connectPeripheral:peripheral options:nil];
}

// 连接到了外围设备
- (void)centralManager:(CBCentralManager *)central didConnectPeripheral:(CBPeripheral *)peripheral {
    NSLog(@"连接到了外围设备");
    [self updateRescanButtonWithText:@"Connected to SyncTomCat-Mac"];
    
    _isConnected = YES;
    peripheral.delegate = self;
    
    // 搜索外设的服务
    CBUUID *serviceUUID = [CBUUID UUIDWithString:SERVICE_UUID];
    [peripheral discoverServices:@[serviceUUID]];
}

// 连接外围设备失败
- (void)centralManager:(CBCentralManager *)central didFailToConnectPeripheral:(CBPeripheral *)peripheral error:(NSError *)error {
    NSLog(@"连接外围设备失败, error: %@", error);
    [self updateRescanButtonWithText:@"Failed to connect peripherals"];
}

// 与外围设备断开了连接
- (void)centralManager:(CBCentralManager *)central didDisconnectPeripheral:(CBPeripheral *)peripheral error:(NSError *)error {
    NSLog(@"与外围设备断开了连接, error: %@", error);
    
    // 停止扫描
    [self.centralManager stopScan];
    
    [self updateRescanButtonWithText:@"Disconnected from peripherals"];
    
    _isConnected = NO;
    self.peripheral = nil;
}

// MARK: 外围设备的服务
// 发现外围设备的服务
- (void)peripheral:(CBPeripheral *)peripheral didDiscoverServices:(NSError *)error {
    if (error) {
        NSLog(@"发现外围设备的服务时出错, error: %@", error);
        return;
    }
    // 遍历服务，寻找相应的服务
    [peripheral.services enumerateObjectsUsingBlock:^(CBService * _Nonnull service, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([service.UUID.UUIDString isEqualToString:SERVICE_UUID]) { // 找到了服务
            NSLog(@"找到了外围设备中相应的服务[%@]", service.UUID.UUIDString);
            // 搜索该服务中的特征
            CBUUID *characteristicUUID = [CBUUID UUIDWithString:CHARACTERISTIC_UUID];
            [peripheral discoverCharacteristics:@[characteristicUUID] forService:service];
        }
        *stop = YES;
    }];
}

// 外围设备的服务发生了变化
- (void)peripheral:(CBPeripheral *)peripheral didModifyServices:(NSArray<CBService *> *)invalidatedServices {
    NSLog(@"外围设备的服务发生了改变");
    
    [invalidatedServices enumerateObjectsUsingBlock:^(CBService *service, NSUInteger idx, BOOL * _Nonnull stop) {
        NSString *UUIDStr = service.UUID.UUIDString;
        NSLog(@"改变后,无效的服务%lu [UUID = %@]", (unsigned long)idx, UUIDStr);
        
        if ([UUIDStr isEqualToString:SERVICE_UUID]) {
            // 停止扫描
            [self.centralManager stopScan];
            
            [self updateRescanButtonWithText:@"SyncTomCat-Mac may be disconnected and rescan"];
        }
    }];
}

// MARK: 外围设备的服务中的特征
// 发现服务中的特征
- (void)peripheral:(CBPeripheral *)peripheral didDiscoverCharacteristicsForService:(CBService *)service error:(NSError *)error {
    if (error) {
        NSLog(@"发现服务的特征时出错, error: %@", error);
        return;
    }
    // 遍历特征，寻找相应的特征
    [service.characteristics enumerateObjectsUsingBlock:^(CBCharacteristic * _Nonnull characteristic, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([characteristic.UUID.UUIDString isEqualToString:CHARACTERISTIC_UUID]) { // 找到了特征
            NSLog(@"找到了外围设备中相应服务中相应的特征[%@]", characteristic.UUID.UUIDString);
            
            // 可以直接读取或订阅特征来获取特征值
            self.characteristic = characteristic;
            
            // 查看该特征有哪些特性
            CBCharacteristicProperties properties = characteristic.properties;
            if (properties & CBCharacteristicPropertyBroadcast) {
                NSLog(@"该特征具备 广播 特性");
            }
            if (properties & CBCharacteristicPropertyRead) {
                NSLog(@"该特征具备 可读 特性");
                
                // 读取特征的值
//                [peripheral readValueForCharacteristic:characteristic];
            }
            if (properties & CBCharacteristicPropertyWriteWithoutResponse) {
                NSLog(@"该特征具备 写入值(不需要响应) 特性");
            }
            if (properties & CBCharacteristicPropertyWrite) {
                NSLog(@"该特征具备 写入值 特性");
            }
            if (properties & CBCharacteristicPropertyNotify) {
                NSLog(@"该特征具备 通知(无响应) 特性");
                
                // 订阅该特征
                [peripheral setNotifyValue:YES forCharacteristic:characteristic];
            }
        }
    }];
}

// 订阅或取消订阅外设某特征的通知
- (void)peripheral:(CBPeripheral *)peripheral didUpdateNotificationStateForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error {
    if (error) {
        NSLog(@"订阅或取消订阅外设的特征时出错, error: %@", error);
        return;
    }
    if (![characteristic.UUID.UUIDString isEqualToString:CHARACTERISTIC_UUID]) {
        NSLog(@"特征不匹配!");
        return;
    }
  
    if (characteristic.isNotifying) {
        NSLog(@"通知: 订阅了外设的特征[%@]", characteristic.UUID.UUIDString);
    } else {
        NSLog(@"通知: 取消订阅了外设的特征[%@]", characteristic.UUID.UUIDString);
    }
}

// 监听到特征值的更新
- (void)peripheral:(CBPeripheral *)peripheral didUpdateValueForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error {
    if (characteristic.value.length == 0) {
        NSLog(@"收到的特征值为空");
        return;
    }
    NSLog(@"收到的特征值是: %@", characteristic.value);
    [self receivedUpdateValueForCharacteristic:characteristic.value];
}

// 向外围设备的特征写入值后的回调
- (void)peripheral:(CBPeripheral *)peripheral didWriteValueForCharacteristic:(nonnull CBCharacteristic *)characteristic error:(nullable NSError *)error {
    if (error) {
        NSLog(@"向特征[%@]写入值失败, error: %@", characteristic.UUID.UUIDString, error);
        return;
    }
    NSLog(@"向特征[%@]写入值成功!", characteristic.UUID.UUIDString);
    
    // 此代理方法中characteristic的值为上一次 peripheral:didUpdateValueForCharacteristic:error: 代理方法被回调时,特征的值
    NSString *valueStr = [[NSString alloc] initWithData:characteristic.value encoding:NSUTF8StringEncoding];
    valueStr = [valueStr AES256_DecryptWithKey:AES256EncryptKey]; // 解密一下
    NSLog(@"特征[%@]的值(上一次收到的特征值)是: %@", characteristic.UUID.UUIDString, valueStr);
}


#pragma mark - Getters

- (UIImageView *)backgroundImageView {
    if (!_backgroundImageView) {
        _backgroundImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, HEIGHT)];
        _backgroundImageView.image = [UIImage imageNamed:@"TomCat_background"];
    }
    return _backgroundImageView;
}

- (UIImageView *)animationImageView {
    if (!_animationImageView) {
        UIImage *image = [UIImage imageNamed:@"default_TomCat.jpg"];
        CGFloat ratio = image.size.width / image.size.height;
        
        CGFloat w = WIDTH;
        CGFloat h = w / ratio;
        CGFloat y = (HEIGHT - h) / 2.0;
        _animationImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, y, w, h)];
        _animationImageView.contentMode = UIViewContentModeScaleAspectFit;
        _animationImageView.image = image;
        
        _buttonView = [[UIView alloc] initWithFrame:_animationImageView.frame];
    }
    return _animationImageView;
}

- (UIButton *)rescanButton {
    if (!_rescanButton) {
        NSString *title = @"Start scanning peripherals...";
        NSString *voTitle = [NSString stringWithFormat:@"VO_%@", title];
        
        _rescanButton = [UIButton buttonWithType:UIButtonTypeSystem];
        _rescanButton.frame = CGRectMake(10, 20, WIDTH - 20, 44);
        _rescanButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        [_rescanButton setTitle:NSLocalizedString(title, nil) forState:UIControlStateNormal];
        [_rescanButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_rescanButton addTarget:self action:@selector(rescanEvent:) forControlEvents:UIControlEventTouchUpInside];
        _rescanButton.accessibilityLabel = NSLocalizedString(voTitle, nil);
    }
    return _rescanButton;
}

- (NSDictionary *)animationInfos {
    if (!_animationInfos) {
        NSString *filePath = [[NSBundle mainBundle] pathForResource:@"animations" ofType:@"plist"];
        if (@available(iOS 11.0, *)) {
            NSError *error = nil;
            _animationInfos = [NSDictionary dictionaryWithContentsOfURL:[NSURL fileURLWithPath:filePath] error:&error];
            if (error) {
                _animationInfos = [NSDictionary dictionary];
            }
        } else {
            _animationInfos = [NSDictionary dictionaryWithContentsOfURL:[NSURL fileURLWithPath:filePath]];
        }
    }
    return _animationInfos;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
