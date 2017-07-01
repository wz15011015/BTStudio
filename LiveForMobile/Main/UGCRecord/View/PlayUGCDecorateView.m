//
//  PlayUGCDecorateView.m
//  LiveForMobile
//
//  Created by  Sierra on 2017/6/29.
//  Copyright © 2017年 BaiFuTak. All rights reserved.
//

#import "PlayUGCDecorateView.h"
#import "BWMacro.h"

@interface PlayUGCDecorateView () {
    CGFloat _width;
    CGFloat _height;
    
    BOOL _isRecording; // 是否正在录制中
}

@property (nonatomic, strong) UITapGestureRecognizer *tap;

@property (nonatomic, strong) UILabel *timerLabel; // 录制时长Label
@property (nonatomic, strong) UIButton *screenshotButton; // 截屏/重新录制按钮
@property (nonatomic, strong) UIButton *recordButton; // 录制按钮
@property (nonatomic, strong) UIButton *closeButton; // 关闭按钮

@property (nonatomic, strong) NSTimer *timer; // 录制计时器

@end

@implementation PlayUGCDecorateView

#pragma mark - Life cycle

- (id)init {
    if (self = [super init]) {
        [self initializeParameters];
        [self addSubViews];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        [self initializeParameters];
        [self addSubViews];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self initializeParameters];
        [self addSubViews];
    }
    return self;
}


#pragma mark - Methods

// 初始化
- (void)initializeParameters {
    _width = WIDTH;
    _height = HEIGHT;
    _isRecording = NO;
    self.recordDuration = 0;
    
    // 添加点击手势
    self.tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(close)];
    [self addGestureRecognizer:self.tap];
}

// 初始化子控件并添加
- (void)addSubViews {
    CGFloat button_margin = 20 * WIDTH_SCALE;
    CGFloat button_bottomMargin = 50 * HEIGHT_SCALE;
    CGFloat button_W1 = 40 * WIDTH_SCALE;
    CGFloat button_Y1 = HEIGHT - button_bottomMargin - button_W1;
    CGFloat button_W2 = 70 * WIDTH_SCALE;
    CGFloat button_X2 = (_width - button_W2) / 2;
    CGFloat button_Y2 = (button_Y1 + (button_W1 / 2)) - (button_W2 / 2);
    
    // 1. 录制时长
    self.timerLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, _width, 44 * HEIGHT_SCALE)];
    self.timerLabel.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.45];
    self.timerLabel.textColor = [UIColor whiteColor];
    self.timerLabel.font = [UIFont boldSystemFontOfSize:16];
    self.timerLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:self.timerLabel];
    self.timerLabel.hidden = YES;
    // 2. 截屏/重新录制按钮
    self.screenshotButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.screenshotButton.frame = CGRectMake(button_margin, button_Y1, button_W1, button_W1);
    [self.screenshotButton setImage:[UIImage imageNamed:@"play_screenshot"] forState:UIControlStateNormal];
    [self.screenshotButton addTarget:self action:@selector(screenshotEvent:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.screenshotButton];
    // 3. 录制按钮
    self.recordButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.recordButton.frame = CGRectMake(button_X2, button_Y2, button_W2, button_W2);
    [self.recordButton addTarget:self action:@selector(recordEvent:) forControlEvents:UIControlEventTouchUpInside];
    self.recordButton.layer.borderColor = [UIColor colorWithWhite:0 alpha:0.2].CGColor;
    self.recordButton.layer.borderWidth = button_W2 * 0.18;
    self.recordButton.backgroundColor = [UIColor whiteColor];
    self.recordButton.layer.cornerRadius = button_W2 / 2;
    self.recordButton.layer.masksToBounds = YES;
    [self addSubview:self.recordButton];
    // 4. 关闭按钮
    self.closeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.closeButton.frame = CGRectMake(_width - button_margin - button_W1, button_Y1, button_W1, button_W1);
    [self.closeButton setImage:[UIImage imageNamed:@"push_close"] forState:UIControlStateNormal];
    [self.closeButton setImage:[UIImage imageNamed:@"push_close_highlighted"] forState:UIControlStateHighlighted];
    [self.closeButton addTarget:self action:@selector(close) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.closeButton];
}

// 移除子控件
- (void)removeSubviews {
    [self.screenshotButton removeFromSuperview];
    [self.recordButton removeFromSuperview];
    [self.closeButton removeFromSuperview];
}


#pragma mark - Public Methods

/**
 显示在view上
 */
- (void)showToView:(UIView *)view {
    [view addSubview:self];
    [self addSubViews];
}

/**
 移除view
 */
- (void)dismiss {
    [self removeSubviews];
    // 关闭定时器
    [self.timer invalidate];
    // 移除self
    [self removeFromSuperview];
}


#pragma mark - Events

// 截屏/重新录制
- (void)screenshotEvent:(UIButton *)sender {
    if (_isRecording) { // 若正在录制中，则为重新录制功能
        [self resetRecord];
    } else { // 若未在录制中，则为截屏功能
        NSLog(@"截屏");
    }
}

// 录制视频
- (void)recordEvent:(UIButton *)sender {
    _isRecording = !_isRecording;
    if (_isRecording) { // 正在录制中...
        [self updateDisplayWithRecordStatus:YES];
        
        self.timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(recording) userInfo:nil repeats:YES];
        [self.timer fire];
        
        if ([self.delegate respondsToSelector:@selector(recordVideoStart)]) {
            [self.delegate recordVideoStart];
        }
        
    } else { // 未在录制中
        [self.timer invalidate];
        
        [self updateDisplayWithRecordStatus:NO];
        
        self.recordDuration = 0.0; 
        
        if (self.recordDuration < 5) {
            NSLog(@"至少要录够5秒");
            return;
        }
        if ([self.delegate respondsToSelector:@selector(recordVideoStop)]) {
            [self.delegate recordVideoStop];
        }
    }
}

// 关闭录制
- (void)close {
    if ([self.delegate respondsToSelector:@selector(closePlayUGCDecorateView)]) {
        [self.delegate closePlayUGCDecorateView];
        [self dismiss];
    }
}


// 录制中...
- (void)recording {
    self.recordDuration += 1;
}

// 重新录制
- (void)resetRecord {
    self.recordDuration = 0;
    if ([self.delegate respondsToSelector:@selector(recordVideoReset)]) {
        [self.delegate recordVideoReset];
    }
}

// 更新控件显示
- (void)updateDisplayWithRecordStatus:(BOOL)isRecording {
    CGFloat w = 85 * WIDTH_SCALE;
    CGPoint center = self.recordButton.center;
    CGRect frame = self.recordButton.frame;
    
    if (isRecording) {
        w = 85 * WIDTH_SCALE;
        frame.size.width = w;
        frame.size.height = w;
        self.recordButton.frame = frame;
        self.recordButton.center = center;
        self.recordButton.layer.borderWidth = frame.size.width * 0.3;
        self.recordButton.layer.cornerRadius = frame.size.width / 2;
        self.recordButton.layer.masksToBounds = YES;
        
        [self removeGestureRecognizer:self.tap];
        self.timerLabel.hidden = NO;
        [self.screenshotButton setImage:[UIImage imageNamed:@"play_resetRecord"] forState:UIControlStateNormal];
        
    } else {
        w = 70 * WIDTH_SCALE;
        frame.size.width = w;
        frame.size.height = w;
        self.recordButton.frame = frame;
        self.recordButton.center = center;
        self.recordButton.layer.borderWidth = frame.size.width * 0.12;
        self.recordButton.layer.cornerRadius = frame.size.width / 2;
        self.recordButton.layer.masksToBounds = YES;
        
        [self addGestureRecognizer:self.tap];
        self.timerLabel.hidden = YES;
        [self.screenshotButton setImage:[UIImage imageNamed:@"play_screenshot"] forState:UIControlStateNormal];
    }
}


#pragma mark - Getters



#pragma mark - Setters

- (void)setRecordDuration:(CGFloat)recordDuration {
    _recordDuration = recordDuration;
    
    self.timerLabel.text = [NSString stringWithFormat:@"00:%02d", (int)self.recordDuration];
    NSLog(@"录制进度: %.fs", self.recordDuration);
    
    if (recordDuration == 60) {
        NSLog(@"至多录60秒，一分钟");
        [self.timer invalidate];
        return;
    }
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
