//
//  ViewController.m
//  SyncTomCat-Mac
//
//  Created by  Sierra on 2017/7/19.
//  Copyright © 2017年 BTStudio. All rights reserved.
//

#import "ViewController.h"
#import "BWMacro.h"
#import <QuartzCore/QuartzCore.h>
#import <AVFoundation/AVFoundation.h>
#import <CoreBluetooth/CoreBluetooth.h>

#define SERVICE_UUID @"6DAC6765-6249-44E4-8EE3-A924401E8717"
#define CHARACTERISTIC_UUID @"F97DE011-D73C-4093-B229-D5756D5FFCAD"

@interface ViewController () <CAAnimationDelegate, CBPeripheralManagerDelegate> {
    BOOL _isAnimating; // 是否正在播放动画中
}

@property (nonatomic, strong) NSImageView *backgroundImageView;
@property (nonatomic, strong) NSImageView *animationImageView;
@property (nonatomic, strong) NSButton *rescanButton;
@property (nonatomic, strong) AVAudioPlayer *audioPlayer;
@property (nonatomic, strong) AVAudioPlayer *otherAudioPlayer;
@property (nonatomic, strong) NSDictionary *animationInfos;

@property (nonatomic, strong) CBPeripheralManager *peripheralManager; // 外设管理
@property (nonatomic, strong) CBMutableService *service; // 外设的一个服务
@property (nonatomic, strong) CBMutableCharacteristic *characteristic; // 外设某个服务中的一个特征
@property (nonatomic, strong) CBCentral *central; // 已与本外设连接的中心设备

@end

@implementation ViewController

#pragma mark - Life Cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.layer.backgroundColor = [NSColor whiteColor].CGColor;
    
    // 1. 初始化参数
    _isAnimating = NO;
    
    // 2. 添加控件
    [self addSubviews];
    
    // 3. 初始化外设管理对象
    self.peripheralManager = [[CBPeripheralManager alloc] initWithDelegate:self queue:nil];
}

- (void)setRepresentedObject:(id)representedObject {
    [super setRepresentedObject:representedObject];

    // Update the view, if already loaded.
}


#pragma mark - 数据的处理

// 向中心设备发送数据
- (void)sendValueToCentralForCharacteristicWithValue:(NSString *)valueStr {
    if (!self.characteristic) {
        NSLog(@"外设特征为空");
        return;
    }
    
    // 加密一下
    NSString *encryptValue = [valueStr AES256_EncryptWithKey:AES256EncryptKey];
    NSData *value = [encryptValue dataUsingEncoding:NSUTF8StringEncoding];
    
    NSArray *centrals = self.central ? @[self.central] : nil;
    // 给订阅的中心设备发送更新数据，centrals如果传nil，表示所有的订阅的中心设备都更新数据
    BOOL success = [self.peripheralManager updateValue:value forCharacteristic:self.characteristic onSubscribedCentrals:centrals];
    if (success) {
        NSLog(@"发送更新数据成功！数据: %@", valueStr);
    } else { // 用于传入更新值的队列是满的 (当传输队列可用时，会调用外设管理器的代理:peripheralManagerIsReadyToUpdateSubscribers:, 可以在此代理方法中再次发送更新数据)
        NSLog(@"发送更新数据失败！数据: %@", valueStr);
    }
}

// 蓝牙收到特征的写入值
- (void)receivedWriteValueForCharacteristic:(NSData *)value {
    NSString *valueStr = [[NSString alloc] initWithData:value encoding:NSUTF8StringEncoding];
    // 解密一下
    valueStr = [valueStr AES256_DecryptWithKey:AES256EncryptKey];
    NSLog(@"收到的特征写入值是: %@", valueStr);
    
    NSDictionary *animationInfo = [self.animationInfos objectForKey:valueStr];
    if (animationInfo) {
        NSString *name = animationInfo[@"name"];
        NSString *count = animationInfo[@"count"];
        [self startAnimationWithName:name count:[count integerValue]];
    }
}


#pragma mark - UI

- (void)addSubviews {
    // 1. 背景ImageView / 动画ImageView / 重新扫描按钮
    [self.view addSubview:self.backgroundImageView];
    [self.view addSubview:self.animationImageView];
    [self.view addSubview:self.rescanButton];
    
    // 2. 两侧的功能按钮 (可见)
    __block CGFloat x = 6;
    __block CGFloat y = WINDOW_HEIGHT * 0.12;
    CGFloat w = 50;
    CGFloat margin = 16;
    NSArray *buttons = @[@"milk_button", @"cymbals_button", @"fart_button", @"paw_button", @"pie_button", @"bird_button"];
    [buttons enumerateObjectsUsingBlock:^(NSString *imageName, NSUInteger idx, BOOL * _Nonnull stop) {
        if (idx == 3) {
            x = WINDOW_WIDTH - x - w;
            y = WINDOW_HEIGHT * 0.12;
        }
        
        NSButton *button = [NSButton buttonWithImage:[NSImage imageNamed:imageName] target:self action:@selector(buttonEvent:)];
        button.tag = 10 + idx;
        button.frame = CGRectMake(x, y, w, w);
        button.bordered = NO;
        [self.view addSubview:button];
        
        y = y + w + margin;
    }];
    
    // 3. 其他的功能按钮 (不可见)
    // [foot_right, foot_left, angry, stomach, happy, sneeze, yawn, yawn, happy_simple, happy_simple, knockout]
    CGFloat happy_simple_w = 50;
    CGFloat happy_simple_h = 65;
    CGFloat yawn_w = 90;
    CGFloat yawn_h = 50;
    CGFloat foot_w = 42;
    CGFloat foot_h = 38;
    for (int i = 0; i < 11; i++) {
        CGFloat x = 0, y = 0, w = 0, h = 0;
        if (i == 0) { // foot_left
            w = foot_w;
            h = foot_h;
            x = (WINDOW_WIDTH / 2) - w - 5;
            y = 18;
        } else if (i == 1) { // foot_right
            w = foot_w;
            h = foot_h;
            x = (WINDOW_WIDTH / 2) + 5;
            y = 18;
        } else if (i == 2) { // angry
            w = 36;
            h = 88;
            x = (WINDOW_WIDTH / 2) + 52;
            y = 46;
        } else if (i == 3) { // stomach
            w = 100;
            h = 60;
            x = (WINDOW_WIDTH - w) / 2;
            y = 70;
        } else if (i == 4) { // happy
            w = 86;
            h = 50;
            x = (WINDOW_WIDTH - w) / 2;
            y = 160;
        } else if (i == 5) { // sneeze
            w = 80;
            h = 38;
            x = (WINDOW_WIDTH - w) / 2 + 3;
            y = 316;
        } else if (i == 6) { // yawn
            w = yawn_w;
            h = yawn_h;
            x = 18;
            y = 320;
        } else if (i == 7) { // yawn
            w = yawn_w;
            h = yawn_h;
            x = WINDOW_WIDTH - 18 - w;
            y = 320;
        } else if (i == 8) { // happy_simple
            w = happy_simple_w;
            h = happy_simple_h;
            x = 60;
            y = 372;
        } else if (i == 9) { // happy_simple
            w = happy_simple_w;
            h = happy_simple_h;
            x = WINDOW_WIDTH - 60 - w;
            y = 372;
        } else if (i == 10) { // knockout
            w = 90;
            h = 44;
            x = (WINDOW_WIDTH - w) / 2;
            y = 388;
        }
        
        NSButton *button = [[NSButton alloc] initWithFrame:NSMakeRect(x, y, w, h)];
        button.tag = 16 + i;
        button.title = @"";
        button.bordered = NO;
        [button setButtonType:NSButtonTypeMomentaryChange];
        button.target = self;
        button.action = @selector(buttonEvent:);
        [self.view addSubview:button];
        // TODO: 调试
//        button.wantsLayer = YES;
//        button.layer.backgroundColor = [NSColor colorWithWhite:0 alpha:0.3].CGColor;
    }
}

- (void)updateRescanButtonWithText:(NSString *)text {
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.rescanButton setTitle:text];
    });
}

- (void)startAnimationWithName:(NSString *)name count:(NSUInteger)count {
    if (_isAnimating) { // 正在动画
        return;
    }
    
    // 1. 动画
    NSMutableArray *images = [NSMutableArray arrayWithCapacity:count];
    for (int i = 0; i < count; i++) {
        NSString *imageName = [NSString stringWithFormat:@"%@_%02d.jpg", name, i];
        NSImage *image = [NSImage imageNamed:imageName];
        [images addObject:image];
    }
    
    CAKeyframeAnimation *animation = [CAKeyframeAnimation animationWithKeyPath:@"contents"];
    animation.values = images;
    animation.duration = 0.1 * count;
    animation.repeatCount = 1;
    animation.calculationMode = kCAAnimationDiscrete;
    animation.delegate = self;
    animation.removedOnCompletion = YES;
    
    CALayer *animationLayer = [CALayer layer];
    animationLayer.frame = self.animationImageView.bounds;
    [animationLayer addAnimation:animation forKey:nil];
    
    self.animationImageView.layer = animationLayer;
    self.animationImageView.wantsLayer = YES;
    
 
    // 2. 创建一个音频播放器,播放相应动作的音效
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
- (void)buttonEvent:(NSButton *)sender {
    if (_isAnimating) {
        NSLog(@"正在播放动画...");
        return;
    }
    
    NSString *actionName = @"none"; // 动作名称
    if (sender.tag == 10) {
        actionName = @"drink";
    } else if (sender.tag == 11) {
        actionName = @"cymbals";
    } else if (sender.tag == 12) {
        actionName = @"fart";
    } else if (sender.tag == 13) {
        actionName = @"scratch";
    } else if (sender.tag == 14) {
        actionName = @"pie";
    } else if (sender.tag == 15) {
        actionName = @"eat";
    } else if (sender.tag == 16) {
        actionName = @"foot_right";
    } else if (sender.tag == 17) {
        actionName = @"foot_left";
    } else if (sender.tag == 18) {
        actionName = @"angry";
    } else if (sender.tag == 19) {
        actionName = @"stomach";
    } else if (sender.tag == 20) {
        actionName = @"happy";
    } else if (sender.tag == 21) {
        actionName = @"sneeze";
    } else if (sender.tag == 22 || sender.tag == 23) {
        actionName = @"yawn";
    } else if (sender.tag == 24 || sender.tag == 25) {
        actionName = @"happy_simple";
    } else if (sender.tag == 26) {
        actionName = @"knockout";
    }
    NSDictionary *animationInfo = [self.animationInfos objectForKey:actionName];
    if (animationInfo) {
        NSString *name = animationInfo[@"name"];
        NSString *count = animationInfo[@"count"];
        [self startAnimationWithName:name count:[count integerValue]];
    }

    [self sendValueToCentralForCharacteristicWithValue:actionName];
}

- (void)rescanEvent:(NSButton *)sender {
    BOOL isAdvertising = self.peripheralManager.isAdvertising;
    if (isAdvertising) {
        NSLog(@"正在广播中...");
        return;
    }
    
    // 重新广播
    NSLog(@"重新广播");
    CBUUID *serviceUUID = [CBUUID UUIDWithString:SERVICE_UUID];
    [self.peripheralManager startAdvertising:@{CBAdvertisementDataLocalNameKey : @"SyncTomCat-Mac", CBAdvertisementDataServiceUUIDsKey : @[serviceUUID]}];
}


#pragma mark - CAAnimationDelegate

- (void)animationDidStart:(CAAnimation *)anim {
    _isAnimating = YES;
}

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag {
    _isAnimating = NO;
    
    CALayer *imageLayer = [CALayer layer];
    imageLayer.contents = [NSImage imageNamed:@"default_TomCat"];
    self.animationImageView.layer = imageLayer;
}


#pragma mark - CBPeripheralManagerDelegate

// 外围设备的状态变化了
- (void)peripheralManagerDidUpdateState:(CBPeripheralManager *)peripheral {
    if (peripheral.state == CBPeripheralManagerStateUnknown) {
        NSLog(@"蓝牙 状态未知");
    } else if (peripheral.state == CBPeripheralManagerStateResetting) {
        NSLog(@"蓝牙 重置中...");
    } else if (peripheral.state == CBPeripheralManagerStateUnsupported) {
        NSLog(@"蓝牙 不支持");
    } else if (peripheral.state == CBPeripheralManagerStateUnauthorized) {
        NSLog(@"蓝牙 未授权");
    } else if (peripheral.state == CBPeripheralManagerStatePoweredOff) {
        NSLog(@"蓝牙 未打开");
    } else {
        NSLog(@"蓝牙 已打开，开始服务");
        
        // 开始中心服务
        
//        CBUUID *characteristicUUID = [CBUUID UUIDWithString:CHARACTERISTIC_UUID];
//        // 1. 可以通知的特征
//        CBMutableCharacteristic *characteristic1 = [[CBMutableCharacteristic alloc] initWithType:characteristicUUID properties:CBCharacteristicPropertyNotify value:nil permissions:CBAttributePermissionsReadable];
//        // 2. 可以读写的特征
//        CBMutableCharacteristic *characteristic2 = [[CBMutableCharacteristic alloc] initWithType:characteristicUUID properties:CBCharacteristicPropertyRead | CBCharacteristicPropertyWrite value:nil permissions:CBAttributePermissionsReadable | CBAttributePermissionsWriteable];
//        // 3. 只读的特征
//        CBMutableCharacteristic *characteristic3 = [[CBMutableCharacteristic alloc] initWithType:characteristicUUID properties:CBCharacteristicPropertyRead value:nil permissions:CBAttributePermissionsReadable];
        
        // 1. 通过UUID创建一个特征
        CBUUID *characteristicUUID = [CBUUID UUIDWithString:CHARACTERISTIC_UUID];
        self.characteristic = [[CBMutableCharacteristic alloc] initWithType:characteristicUUID properties:CBCharacteristicPropertyNotify | CBCharacteristicPropertyRead | CBCharacteristicPropertyWrite value:nil permissions:CBAttributePermissionsReadable | CBAttributePermissionsWriteable];
        
//        CBUUID *descriptorUUID = [CBUUID UUIDWithString:CBUUIDCharacteristicUserDescriptionString];
//        CBMutableDescriptor *descriptor = [[CBMutableDescriptor alloc] initWithType:descriptorUUID value:@"readAndNotify"];
//        self.characteristic.descriptors = @[descriptor];
        
        // 2. 通过UUID创建一个服务
        CBUUID *serviceUUID = [CBUUID UUIDWithString:SERVICE_UUID];
        self.service = [[CBMutableService alloc] initWithType:serviceUUID primary:YES];
        [self.service setCharacteristics:@[self.characteristic]];
        
        // 3. 使用这个服务 (Services cannot be added more than once)
        [peripheral addService:self.service];
    }
}

// 添加服务成功
- (void)peripheralManager:(CBPeripheralManager *)peripheral didAddService:(CBService *)service error:(NSError *)error {
    if (error) {
        NSLog(@"添加服务出错！error: %@", error);
        return;
    }
    NSString *serviceUUIDStr = service.UUID.UUIDString;
    NSLog(@"添加服务成功[%@]，准备开始广播", serviceUUIDStr);
    
    CBUUID *serviceUUID = [CBUUID UUIDWithString:serviceUUIDStr];
    [peripheral startAdvertising:@{CBAdvertisementDataLocalNameKey : @"SyncTomCat-Mac", CBAdvertisementDataServiceUUIDsKey : @[serviceUUID]}];
}

// 开始广播
- (void)peripheralManagerDidStartAdvertising:(CBPeripheralManager *)peripheral error:(NSError *)error {
    if (error) {
        NSLog(@"开始广播时出错，error = %@", error);
        
        // 停止广播
        [peripheral stopAdvertising];
        
        return;
    }
    NSLog(@"开始广播...");
}

// 监听到来自中心设备的"读"请求
- (void)peripheralManager:(CBPeripheralManager *)peripheral didReceiveReadRequest:(CBATTRequest *)request {
    NSLog(@"收到来自中心设备的\"读\"请求");
    
    CBCentral *central = request.central;
    CBCharacteristic *characteristic = request.characteristic; 
    
    self.central = central;
    
    // 1. 判断当前外设的特征是否与远程中心设备请求的特征相匹配
    if (![characteristic.UUID.UUIDString isEqualToString:CHARACTERISTIC_UUID]) {
        NSLog(@"远程中心设备请求的特征 与 当前外设的特征 不匹配");
        [peripheral respondToRequest:request withResult:CBATTErrorReadNotPermitted];
        return;
    }
    
    // 2. 确保请求读取数据的索引没有超出特征值的范围
//    if (request.offset > self.characteristic.value.length) {
//        [peripheral respondToRequest:request withResult:CBATTErrorInvalidOffset];
//        NSLog(@"请求读取数据的索引 超出 特征值的范围");
//        return;
//    }
    
    // 3. 给请求设置值
    // 加密一下
    NSString *encryptValue = [@"BTStudio-SyncTomCat" AES256_EncryptWithKey:AES256EncryptKey];
    NSData *value = [encryptValue dataUsingEncoding:NSUTF8StringEncoding];
    request.value = value;
    
    // 4. 通知远程的中心设备已经请求成功
    [peripheral respondToRequest:request withResult:CBATTErrorSuccess];
}

// 监听到来自中心设备的"写"请求
- (void)peripheralManager:(CBPeripheralManager *)peripheral didReceiveWriteRequests:(NSArray<CBATTRequest *> *)requests {
    NSLog(@"收到来自中心设备的\"写\"请求");
    
    CBATTRequest *request = requests.firstObject;
    CBCentral *central = request.central;
    // 需要转换成CBMutableCharacteristic对象才能进行写值
    CBMutableCharacteristic *characteristic = (CBMutableCharacteristic *)request.characteristic;
    
    self.central = central;
    
    // 判断该特征是否有写入特性
    if (request.characteristic.properties & CBCharacteristicPropertyWrite) {
        characteristic.value = request.value;
        
        // 获取特征的写入值
        if (characteristic.value.length == 0) {
            NSLog(@"收到的特征写入值为空");
            [peripheral respondToRequest:request withResult:CBATTErrorInvalidHandle];
            return;
        } 
        // 对"写"请求作出成功响应
        [peripheral respondToRequest:request withResult:CBATTErrorSuccess];
        // 处理特征的写入值
        [self receivedWriteValueForCharacteristic:characteristic.value];
    } else {
        [peripheral respondToRequest:request withResult:CBATTErrorWriteNotPermitted];
    }
}

// 中心设备订阅了该外设的特征
- (void)peripheralManager:(CBPeripheralManager *)peripheral central:(CBCentral *)central didSubscribeToCharacteristic:(CBCharacteristic *)characteristic {
    // 停止广播
    [peripheral stopAdvertising];
    
    // 特征UUID
    NSString *UUIDStr = characteristic.UUID.UUIDString;
    NSLog(@"中心设备订阅了该外设的特征,特征UUID = %@", UUIDStr);
    
    [self updateRescanButtonWithText:@"已连接至: SyncTomCat-iPhone"];
    
    self.central = central;
    
    // 通知中心设备订阅本外设的某个特征成功
    NSString *valueStr = [NSString stringWithFormat:@"subscribe success. [%@]", UUIDStr];
    NSString *encryptValue = [valueStr AES256_EncryptWithKey:AES256EncryptKey]; // 加密一下
    NSData *value = [encryptValue dataUsingEncoding:NSUTF8StringEncoding];
    
    // 给订阅的中心设备发送更新数据，centrals如果传nil，表示所有的订阅的中心设备都更新数据
    BOOL success = [peripheral updateValue:value forCharacteristic:self.characteristic onSubscribedCentrals:@[central]];
    if (success) {
        NSLog(@"订阅后发送更新数据成功！数据: %@", valueStr);
    } else { // 用于传入更新值的队列是满的 (当传输队列可用时，会调用外设管理器的代理:peripheralManagerIsReadyToUpdateSubscribers:, 可以在此代理方法中再次发送更新数据)
        NSLog(@"订阅后发送更新数据失败！数据: %@", valueStr);
    }
}

// 中心设备取消了订阅该外设的特征
- (void)peripheralManager:(CBPeripheralManager *)peripheral central:(CBCentral *)central didUnsubscribeFromCharacteristic:(CBCharacteristic *)characteristic {
    // 停止广播
    [peripheral stopAdvertising];
    
    NSString *UUIDStr = characteristic.UUID.UUIDString; // 特征UUID
    NSLog(@"中心设备取消了订阅该外设的特征,特征UUID = %@", UUIDStr);
    
    [self updateRescanButtonWithText:@"SyncTomCat-iPhone 可能断开了连接,重新扫描"];
}

// 当传输队列可用时，会调用外设管理器的代理:peripheralManagerIsReadyToUpdateSubscribers:, 可以在此代理方法中再次发送更新数据
- (void)peripheralManagerIsReadyToUpdateSubscribers:(CBPeripheralManager *)peripheral {
    NSLog(@"需要再次发送更新数据");
}


#pragma mark - Getters

- (NSImageView *)backgroundImageView {
    if (!_backgroundImageView) {
        _backgroundImageView = [[NSImageView alloc] initWithFrame:NSMakeRect(0, 0, WINDOW_WIDTH, WINDOW_HEIGHT)];
        _backgroundImageView.image = [NSImage imageNamed:@"default_TomCat"];
    }
    return _backgroundImageView;
}

- (NSImageView *)animationImageView {
    if (!_animationImageView) {
        _animationImageView = [[NSImageView alloc] initWithFrame:NSMakeRect(0, 0, WINDOW_WIDTH, WINDOW_HEIGHT)];
        _animationImageView.image = [NSImage imageNamed:@"default_TomCat"];
    }
    return _animationImageView;
}

- (NSButton *)rescanButton {
    if (!_rescanButton) {
        _rescanButton = [NSButton buttonWithTitle:@"" target:self action:@selector(rescanEvent:)];
        _rescanButton.frame = CGRectMake(10, WINDOW_HEIGHT - 44, WINDOW_WIDTH - 20, 44);
        _rescanButton.highlighted = NO; // 不显示高亮状态
        _rescanButton.bordered = NO; // 不显示边框
        // 设置背景颜色
        _rescanButton.wantsLayer = YES;
        _rescanButton.layer.backgroundColor = [NSColor clearColor].CGColor;
    }
    return _rescanButton;
}

- (NSDictionary *)animationInfos {
    if (!_animationInfos) {
        NSString *filePath = [[NSBundle mainBundle] pathForResource:@"animations" ofType:@"plist"];
        if (@available(macOS 10.13, *)) {
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

@end
