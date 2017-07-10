//
//  BWPlayDecorateView.m
//  LiveForMobile
//
//  Created by  Sierra on 2017/6/26.
//  Copyright © 2017年 BaiFuTak. All rights reserved.
//

#import "BWPlayDecorateView.h"
#import "BWMacro.h"
#import "AudienceCell.h"
#import "MessageCell.h"
#import "GiftModel.h"
#import "BWPlistHelper.h"
// 礼物展示
#import "PresentView.h"
#import "GiftOneCell.h"
#import "GiftOneModel.h"

#define TOP_Y (25) // 顶部第一行控件的y值
#define TOP_H (30) // 顶部第一行控件的高
#define TOP_LEFT_MARGIN  (10) // 顶部第一行控件的左边距
#define TOP_RIGHT_MARGIN (10) // 顶部第一行控件的右边距

#define MESSAGE_MAX_COUNT (30) // 聊天消息展示的最大条数
 
const NSUInteger ButtonCountOfPlay = 7; // 底部的功能按钮个数

@interface BWPlayDecorateView () <UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UIGestureRecognizerDelegate, UITextFieldDelegate, UITableViewDelegate, UITableViewDataSource, PresentViewDelegate> {
    CGFloat _width;
    CGFloat _height;
    
    NSUInteger _unreadMsgCount; // 未读消息个数
    
    BOOL _isBulletOn; // 是否开启了弹幕效果
    BOOL _isAutoScrollToBottom; // 是否允许消息列表自动滚动到最底部
}
@property (nonatomic, strong) UITapGestureRecognizer *tapForScreen; // 点击手势
@property (nonatomic, strong) UIPanGestureRecognizer *panForMove;  // 平移手势

// 加在self上的控件
// 关闭按钮
@property (nonatomic, strong) UIButton *closeButton;
// 主播信息 (anchor info)
@property (nonatomic, strong) UIImageView *anchorInfoView;
@property (nonatomic, strong) UIImageView *anchorAvatarImageView;
@property (nonatomic, strong) UILabel *anchorNameLabel;
@property (nonatomic, strong) UILabel *anchorIDLabel;
// 聊天输入框部分
@property (nonatomic, strong) UIView *chatInputView;
@property (nonatomic, strong) UITextField *chatInputTextField;

// 用来放置除关闭按钮以外的其他控件
@property (nonatomic, strong) UIView *decorateView;


// 加在decorateView上的控件
// 在线观看人数
@property (nonatomic, strong) UIImageView *audienceCountView;
@property (nonatomic, strong) UILabel *audienceCountLabel;
// 在线观众列表
@property (nonatomic, strong) UICollectionView *audienceCollectionView;
@property (nonatomic, strong) NSMutableArray *audienceArr;
// 消息列表
@property (nonatomic, strong) UITableView *messageTableView;
@property (nonatomic, strong) NSMutableArray *messageArr;
@property (nonatomic, strong) UIButton *unreadButton;  // 未读消息个数按钮
// 底部功能按钮
@property (nonatomic, strong) UIButton *chatButton;
@property (nonatomic, strong) UIButton *pmButton;        // 私信按钮 (Private Message)
@property (nonatomic, strong) UIButton *orderSongButton; // 点歌按钮
@property (nonatomic, strong) UIButton *giftButton;   // 礼物按钮
@property (nonatomic, strong) UIButton *cameraButton; // 录制视频按钮
@property (nonatomic, strong) UIButton *shareButton;  // 分享按钮

// 礼物展示
@property (nonatomic, strong) UIImageView *animationImageView;
@property (nonatomic, strong) NSMutableArray <GiftModel *>*giftAnimationArr;

@property (nonatomic, strong) CAEmitterLayer *praiseEmitterLayer; // 点赞效果 (粒子动画)

@property (nonatomic, strong) PresentView *giftOneView;
@property (nonatomic, strong) NSMutableArray *giftOneArr;


#warning testing
@property (nonatomic, strong) NSTimer *testTimer;

@end

@implementation BWPlayDecorateView

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

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [self.testTimer invalidate];
}


#pragma mark - Methods

// 初始化
- (void)initializeParameters {
    _width = WIDTH;
    _height = HEIGHT;
    _unreadMsgCount = 0;
    _isBulletOn = NO;
    _isAutoScrollToBottom = YES;
    
    // 注册键盘高度变化的通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillChangeFrame:) name:UIKeyboardWillChangeFrameNotification object:nil];
    
    // 1. 添加点击手势
    self.tapForScreen = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickScreen:)];
    [self addGestureRecognizer:self.tapForScreen];
    
    // 2. 添加平移手势,用来移动decorateView
    self.panForMove = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panMoveDecorateView:)];
    self.panForMove.delegate = self;
    [self addGestureRecognizer:self.panForMove];
}

// 初始化子控件并添加
- (void)addSubViews {
    // 0. 动画ImageView
    [self addSubview:self.animationImageView];
    
    [self addSubview:self.decorateView];
    
    // 加在decorateView上的控件: 1.观看人数 2.观众列表 3.底部功能按钮(6个)
    // 1. 在线观看人数
    CGFloat audienceCount_W = 64;
    CGFloat audienceCount_X = _width - TOP_RIGHT_MARGIN - audienceCount_W;
    self.audienceCountView = [[UIImageView alloc] initWithFrame:CGRectMake(audienceCount_X, TOP_Y, audienceCount_W, TOP_H)];
    self.audienceCountView.backgroundColor = [UIColor colorWithWhite:0.1 alpha:0.4];
    self.audienceCountView.layer.cornerRadius = TOP_H / 2;
    self.audienceCountView.layer.masksToBounds = YES;
    [self.decorateView addSubview:self.audienceCountView];
    
    self.audienceCountLabel = [[UILabel alloc] initWithFrame:CGRectMake(4, 0, audienceCount_W - 8, TOP_H)];
    self.audienceCountLabel.font = [UIFont systemFontOfSize:12];
    self.audienceCountLabel.textColor = [UIColor whiteColor];
    self.audienceCountLabel.textAlignment = NSTextAlignmentCenter;
    [self.audienceCountView addSubview:self.audienceCountLabel];
    
    // 2. 在线观众列表
    [self.decorateView addSubview:self.audienceCollectionView];
    
    // 3. 消息列表
    [self.decorateView addSubview:self.messageTableView];
    [self.decorateView addSubview:self.unreadButton];
    self.unreadButton.hidden = YES;
    
    // 4. 底部的功能按钮(6个)
    CGFloat button_bottomMargin = 15;
    CGFloat button_W = BottomButtonWidth;
    CGFloat button_Y = _height - button_bottomMargin - button_W;
    CGFloat button_middleMargin = (_width - (ButtonCountOfPlay * button_W)) / (ButtonCountOfPlay + 1);
    // 4.1 聊天按钮
    self.chatButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.chatButton.frame = CGRectMake(button_middleMargin, button_Y, button_W, button_W);
    [self.chatButton setImage:[UIImage imageNamed:@"push_chat"] forState:UIControlStateNormal];
    [self.chatButton addTarget:self action:@selector(clickChat:) forControlEvents:UIControlEventTouchUpInside];
    [self.decorateView addSubview:self.chatButton];
    // 4.2 私信按钮
    self.pmButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.pmButton.frame = CGRectMake(CGRectGetMaxX(self.chatButton.frame) + button_middleMargin, button_Y, button_W, button_W);
    [self.pmButton setImage:[UIImage imageNamed:@"play_pm"] forState:UIControlStateNormal];
    [self.pmButton addTarget:self action:@selector(clickPM:) forControlEvents:UIControlEventTouchUpInside];
    [self.decorateView addSubview:self.pmButton];
    // 4.3 点歌按钮
    self.orderSongButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.orderSongButton.frame = CGRectMake(CGRectGetMaxX(self.pmButton.frame) + button_middleMargin, button_Y, button_W, button_W);
    [self.orderSongButton setImage:[UIImage imageNamed:@"push_chat"] forState:UIControlStateNormal];
    [self.orderSongButton addTarget:self action:@selector(clickOrderSong:) forControlEvents:UIControlEventTouchUpInside];
    [self.decorateView addSubview:self.orderSongButton];
    // 4.4 礼物按钮
    self.giftButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.giftButton.frame = CGRectMake(CGRectGetMaxX(self.orderSongButton.frame) + button_middleMargin, button_Y, button_W, button_W);
    [self.giftButton setImage:[UIImage imageNamed:@"play_gift"] forState:UIControlStateNormal];
    [self.giftButton addTarget:self action:@selector(clickGift:) forControlEvents:UIControlEventTouchUpInside];
    [self.decorateView addSubview:self.giftButton];
    // 4.5 录制视频按钮
    self.cameraButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.cameraButton.frame = CGRectMake(CGRectGetMaxX(self.giftButton.frame) + button_middleMargin, button_Y, button_W, button_W);
    [self.cameraButton setImage:[UIImage imageNamed:@"play_video_record"] forState:UIControlStateNormal];
    [self.cameraButton setImage:[UIImage imageNamed:@"play_video_record_highlighted"] forState:UIControlStateHighlighted];
    [self.cameraButton addTarget:self action:@selector(clickCamera:) forControlEvents:UIControlEventTouchUpInside];
    [self.decorateView addSubview:self.cameraButton];
    // 4.6 分享按钮
    self.shareButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.shareButton.frame = CGRectMake(CGRectGetMaxX(self.cameraButton.frame) + button_middleMargin, button_Y, button_W, button_W);
    [self.shareButton setImage:[UIImage imageNamed:@"play_share"] forState:UIControlStateNormal];
    [self.shareButton setImage:[UIImage imageNamed:@"play_share_highlighted"] forState:UIControlStateHighlighted];
    [self.shareButton addTarget:self action:@selector(clickShare:) forControlEvents:UIControlEventTouchUpInside];
    [self.decorateView addSubview:self.shareButton];
    
    
    // 加在self上的控件: 1.关闭按钮 2.主播信息
    // 1. 关闭按钮
    self.closeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.closeButton.frame = CGRectMake(_width - button_middleMargin - button_W, button_Y, button_W, button_W);
    [self.closeButton setImage:[UIImage imageNamed:@"push_close"] forState:UIControlStateNormal];
    [self.closeButton setImage:[UIImage imageNamed:@"push_close_highlighted"] forState:UIControlStateHighlighted];
    [self.closeButton addTarget:self action:@selector(closePlay) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.closeButton];
    
    // 2. 主播信息
    CGFloat anchor_W = 125;
    CGFloat anchor_H = TOP_H;
    CGFloat anchor_label_X = anchor_H + 5;
    CGFloat anchor_label_W = anchor_W - anchor_label_X - (anchor_H / 2);
    self.anchorInfoView = [[UIImageView alloc] initWithFrame:CGRectMake(TOP_LEFT_MARGIN, TOP_Y, anchor_W, anchor_H)];
    self.anchorInfoView.backgroundColor = [UIColor colorWithWhite:0.1 alpha:0.4];
    self.anchorInfoView.layer.cornerRadius = anchor_H / 2;
    self.anchorInfoView.layer.masksToBounds = YES;
    [self addSubview:self.anchorInfoView];
    // 2.1 主播头像
    self.anchorAvatarImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, anchor_H, anchor_H)];
    self.anchorAvatarImageView.layer.cornerRadius = anchor_H / 2;
    self.anchorAvatarImageView.layer.masksToBounds = YES;
    self.anchorAvatarImageView.layer.borderColor = [UIColor whiteColor].CGColor;
    self.anchorAvatarImageView.layer.borderWidth = 0.8;
    [self.anchorInfoView addSubview:self.anchorAvatarImageView];
    // 2.2 主播昵称
    self.anchorNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(anchor_label_X, 0, anchor_label_W, anchor_H * 0.6)];
    self.anchorNameLabel.font = [UIFont boldSystemFontOfSize:12.5];
    self.anchorNameLabel.textColor = [UIColor whiteColor];
    [self.anchorInfoView addSubview:self.anchorNameLabel];
    // 2.3 主播ID
    self.anchorIDLabel = [[UILabel alloc] initWithFrame:CGRectMake(anchor_label_X, CGRectGetMaxY(self.anchorNameLabel.frame), anchor_label_W, anchor_H * 0.4)];
    self.anchorIDLabel.font = [UIFont boldSystemFontOfSize:11];
    self.anchorIDLabel.textColor = [UIColor whiteColor];
    [self.anchorInfoView addSubview:self.anchorIDLabel];
    
    // 3. 聊天输入框view
    CGFloat bullet_button_W = 50;
    CGFloat bullet_button_H = 32;
    CGFloat intput_margin = 10;
    CGFloat intput_textField_X = bullet_button_W + (2 * intput_margin);
    CGFloat intput_textField_W = WIDTH - intput_textField_X - intput_margin;
    self.chatInputView = [[UIView alloc] initWithFrame:CGRectMake(0, _height, _width, ChatInputViewHeight)];
    self.chatInputView.backgroundColor = RGB(241, 241, 244);
    [self addSubview:self.chatInputView];
    // 3.1 是否开启弹幕效果
    UIButton *bulletButton = [UIButton buttonWithType:UIButtonTypeCustom];
    bulletButton.frame = CGRectMake(intput_margin, (ChatInputViewHeight - bullet_button_H) / 2, bullet_button_W, bullet_button_H);
    [bulletButton setImage:[UIImage imageNamed:@"play_bullet_switch_off"] forState:UIControlStateNormal];
    [bulletButton setImage:[UIImage imageNamed:@"play_bullet_switch_on"] forState:UIControlStateSelected];
    [bulletButton addTarget:self action:@selector(clickBulletButton:) forControlEvents:UIControlEventTouchUpInside];
    [self.chatInputView addSubview:bulletButton];
    // 3.2 输入框
    self.chatInputTextField = [[UITextField alloc] initWithFrame:CGRectMake(intput_textField_X, (ChatInputViewHeight - bullet_button_H) / 2, intput_textField_W, bullet_button_H)];
    self.chatInputTextField.backgroundColor = RGB(233, 233, 233);
    self.chatInputTextField.layer.borderWidth = 1;
    self.chatInputTextField.layer.borderColor = RGB(244, 85, 133).CGColor;
    self.chatInputTextField.layer.masksToBounds = YES;
    self.chatInputTextField.layer.cornerRadius = bullet_button_H / 2;
    self.chatInputTextField.delegate = self;
    self.chatInputTextField.returnKeyType = UIReturnKeySend;
    self.chatInputTextField.font = [UIFont systemFontOfSize:15];
    NSAttributedString *placeholderAttriStr = [[NSAttributedString alloc] initWithString:@"  说点什么吧" attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:15], NSForegroundColorAttributeName : RGB(180, 180, 180)}];
    self.chatInputTextField.attributedPlaceholder = placeholderAttriStr;
    [self.chatInputView addSubview:self.chatInputTextField];
    
    // 4. 礼物展示
    self.giftOneView = [[PresentView alloc] initWithFrame:CGRectMake(0, 300 * HEIGHT_SCALE, WIDTH * 0.4, 100)];
    self.giftOneView.backgroundColor = [UIColor clearColor];
    self.giftOneView.delegate = self;
    [self.decorateView addSubview:self.giftOneView];
    
    
    // 测试数据
    self.anchorAvatarImageView.image = [UIImage imageNamed:@"avatar_default"];
    self.anchorNameLabel.text = @"高姿态的🛴，走了...";
    self.anchorIDLabel.text = [NSString stringWithFormat:@"ID:%@", @"11000007"];
    self.audienceCountLabel.text = [NSString stringWithFormat:@"%@人", @"1100"];
    [self.audienceArr addObject:@""];
    [self.audienceArr addObject:@""];
    [self.audienceArr addObject:@""];
    [self.audienceArr addObject:@""];
    [self.audienceArr addObject:@""];
    [self.audienceArr addObject:@""];
    [self.audienceCollectionView reloadData];
    
    [self.messageArr addObject:@" "];
    [self.messageArr addObject:@" "];
    [self.messageArr addObject:@" "];
    [self.messageArr addObject:@" "];
    [self.messageArr addObject:@" "];
    [self.messageArr addObject:@" "];
    [self.messageArr addObject:@" "];
    [self.messageArr addObject:@"直播消息: 我们提倡绿色直播，封面和直播内容含吸烟、低俗、引诱、暴露等都将会被封停账号，同时禁止直播聚众闹事、集会，网警24小时在线巡查哦！😯"];
    [self.messageTableView reloadData];
    // 滚动到最后一行
    NSIndexPath *footIndexPath = [NSIndexPath indexPathForRow:self.messageArr.count - 1 inSection:0];
    [self.messageTableView scrollToRowAtIndexPath:footIndexPath atScrollPosition:UITableViewScrollPositionBottom animated:NO];
    
    self.testTimer = [NSTimer scheduledTimerWithTimeInterval:2 target:self selector:@selector(receivedMessage) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:self.testTimer forMode:NSRunLoopCommonModes];
}


#warning testing
// 收到新消息
- (void)receivedMessage {
    int random = arc4random() % 4;
    if (random == 0) {
        [self.messageArr addObject:@"关注你了，哈哈😄!"];
    } else if (random == 1) {
        [self.messageArr addObject:@"23"];
    } else {
        [self.messageArr addObject:@"12"];
    }
    _unreadMsgCount += 1;
    
    NSUInteger count = self.messageArr.count;
    if (count > MESSAGE_MAX_COUNT) {
        NSUInteger delta = count - MESSAGE_MAX_COUNT;
        [self.messageArr removeObjectsInRange:NSMakeRange(0, delta)];
//        NSLog(@"移除消息: 0~%ld", delta - 1);
    }
    
    [self reloadMessageAndScrollToBottom];
}

- (void)reloadMessageAndScrollToBottom {
    if (_isAutoScrollToBottom) {
//        dispatch_async(dispatch_get_main_queue(), ^{
            [self.messageTableView reloadData];
            // 滚动到最后一行
            NSIndexPath *footIndexPath = [NSIndexPath indexPathForRow:self.messageArr.count - 1 inSection:0];
            [self.messageTableView scrollToRowAtIndexPath:footIndexPath atScrollPosition:UITableViewScrollPositionBottom animated:NO];
//        });
        
        _unreadMsgCount = 0;
        self.unreadButton.hidden = YES;
    } else {
        if (_unreadMsgCount == 0) {
            return;
        }
        self.unreadButton.hidden = NO;
        [self.unreadButton setTitle:[NSString stringWithFormat:@"新消息%ld条", _unreadMsgCount] forState:UIControlStateNormal];
    }
}


#pragma mark - Public Methods

// 显示礼物
- (void)shwoGift:(GiftModel *)gift {
    [self.giftAnimationArr addObject:gift];
    [self giftAnimationStart:gift];
    
    // 粒子发射器实现
    //    [self.decorateView.layer addSublayer:self.praiseEmitterLayer];
}

/** 显示礼物1 */
- (void)shwoGiftOne:(GiftOneModel *)gift {
    NSArray *models = @[gift, gift, gift, gift];
    self.giftOneArr = [NSMutableArray arrayWithArray:models];
    [self.giftOneView insertPresentMessages:self.giftOneArr showShakeAnimation:YES];
}

/** 播放礼物动画 */
- (void)giftAnimationStart:(GiftModel *)gift {
    // 播放礼物动画
    // 1. 先判断是否正在播放动画
    if (self.animationImageView.isAnimating) {
        return;
    }
    // 2. 获取礼物信息
    BWPlistHelper *plistHelper = [[BWPlistHelper alloc] initWithPropertyListFileName:@"GiftResource.plist"];
    NSArray *images = [plistHelper imagesWithGiftId:gift.giftId];
    if (images.count == 0) {
        return;
    }
    // 3. 调整动画UIImageView的frame
    CGRect frame = self.animationImageView.frame;
    frame.origin.x = [plistHelper imageXWithGiftId:gift.giftId] * WIDTH_SCALE;
    frame.origin.y = [plistHelper imageYWithGiftId:gift.giftId] * HEIGHT_SCALE;
    frame.size.width = [plistHelper imageWWithGiftId:gift.giftId] * WIDTH_SCALE;
    frame.size.height = [plistHelper imageHWithGiftId:gift.giftId] * HEIGHT_SCALE;
    self.animationImageView.frame = frame;
    // 4. 动画时长
    NSTimeInterval duration = [plistHelper durationWithGiftId:gift.giftId];
    self.animationImageView.animationImages = images;
    self.animationImageView.animationDuration = duration;
    self.animationImageView.animationRepeatCount = 1;
    // 5. 开始动画
    [self.animationImageView startAnimating];
//    NSLog(@"开始播放[%@]礼物动画", gift.giftName);
    // 6. 动画播放完成后，清除动画
    [self performSelector:@selector(giftAnimationCompleted:) withObject:nil afterDelay:duration + 0.1];
}

/** 完成礼物动画 */
- (void)giftAnimationCompleted:(id)object {
    // 1. 停止动画
    [self.animationImageView stopAnimating];
    // 2. 数组中移除已播放的动画
    [self.giftAnimationArr removeObjectAtIndex:0];
    // 3. 开始播放下一个动画
    NSUInteger count = self.giftAnimationArr.count;
    if (count == 0) {
        [_animationImageView removeFromSuperview];
        _animationImageView = nil;
        return;
    }
    GiftModel *gift = self.giftAnimationArr.firstObject;
    [self giftAnimationStart:gift];
}


#pragma mark - Events

// MARK: BWPushDecorateDelegate

// 结束播放
- (void)closePlay {
    if ([self.delegate respondsToSelector:@selector(closePlayViewController)]) {
        [self.delegate closePlayViewController];
    }
}

// 开始聊天
- (void)clickChat:(UIButton *)button {
    [self.chatInputTextField becomeFirstResponder];
}

// 是否开启弹幕效果
- (void)clickBulletButton:(UIButton *)button {
    button.selected = !button.selected;
    _isBulletOn = button.selected;
    NSLog(@"%@弹幕效果", _isBulletOn ? @"开启" : @"关闭");
}

// 私信
- (void)clickPM:(UIButton *)button {
    if ([self.delegate respondsToSelector:@selector(clickPrivateMessage:)]) {
        [self.delegate clickPrivateMessage:button];
    }
}

// 点歌
- (void)clickOrderSong:(UIButton *)button {
    if ([self.delegate respondsToSelector:@selector(clickOrderSong:)]) {
        [self.delegate clickOrderSong:button];
    }
}

// 礼物
- (void)clickGift:(UIButton *)button {
    if ([self.delegate respondsToSelector:@selector(clickGift:)]) {
        [self.delegate clickGift:button];
    }
}

// 录制视频
- (void)clickCamera:(UIButton *)button {
    if ([self.delegate respondsToSelector:@selector(clickRecord:)]) {
        [self.delegate clickRecord:button];
    }
}

// 分享
- (void)clickShare:(UIButton *)button {
    if ([self.delegate respondsToSelector:@selector(clickShare:)]) {
        [self.delegate clickShare:button];
    }
}

// 查看最新消息，滚动到最底部
- (void)readNewMessage:(UIButton *)sender {
    sender.hidden = YES;
    _isAutoScrollToBottom = YES;
    [self reloadMessageAndScrollToBottom];
}


// MARK: UIGestureRecognizer Event

// 点击了屏幕
- (void)clickScreen:(UITapGestureRecognizer *)gestureRecognizer {
    // to do something...
}

// 平移decorateView
- (void)panMoveDecorateView:(UIPanGestureRecognizer *)gestureRecognizer {
    // 当decorateView在初始位置时(即刚好充满整个屏幕时),不能向左滑动;
    // 若向右滑动，则当中心线x值 > (_width * 0.7)时，让decorateView完全移出屏幕;
    // 若向左滑动，则当中心线x值 < (_width * 1.4)时，让decorateView移回初始位置.
    
    [self endEditing:YES];
    
    CGPoint center = self.decorateView.center;
    
    // 1. 移动decorateView
    CGPoint translation = [gestureRecognizer translationInView:self];
    center = CGPointMake(center.x + translation.x, center.y);
    if (center.x < _width * 0.5) { // 在初始位置时，不能向左滑动
        return;
    }
    self.decorateView.center = center;
    
    [gestureRecognizer setTranslation:CGPointZero inView:self];
    
    // 2. 手势结束时，判断是否超过分界线
    if (gestureRecognizer.state == UIGestureRecognizerStateEnded) {
        center = self.decorateView.center;
        
        // 分界线的x值
        CGFloat centerBoundaryX = _width * 0.8;
        // 判断平移的方向
        CGPoint velocity = [gestureRecognizer velocityInView:self];
        if (velocity.x > 0) {
            centerBoundaryX = _width * 0.7;
        } else {
            centerBoundaryX = _width * 1.4;
        }
        
        [UIView animateWithDuration:0.25 animations:^{
            if (center.x > centerBoundaryX) {
                self.decorateView.center = CGPointMake(_width * 1.5, center.y);
            } else {
                self.decorateView.center = CGPointMake(_width * 0.5, center.y);
            }
        }];
    }
}


#pragma mark - PresentViewDelegate

- (PresentViewCell *)presentView:(PresentView *)presentView cellOfRow:(NSInteger)row {
    GiftOneCell *cell = [[GiftOneCell alloc] initWithRow:row];
    return cell;
}

- (void)presentView:(PresentView *)presentView configCell:(PresentViewCell *)cell model:(id<PresentModelAble>)model {
    GiftOneCell *giftOneCell = (GiftOneCell *)cell;
    giftOneCell.model = (GiftOneModel *)model;
}

- (void)presentView:(PresentView *)presentView didSelectedCellOfRowAtIndex:(NSUInteger)index {
    GiftOneModel *model = self.giftOneArr[index];
    NSLog(@"点击了: %@", model.giftName);
}

- (void)presentView:(PresentView *)presentView animationCompleted:(NSInteger)shakeNumber model:(id<PresentModelAble>)model {
    NSLog(@"%@ 礼物的连送动画执行完成", model.giftName);
}


#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.audienceArr.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    AudienceCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:AudienceCellID forIndexPath:indexPath];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
}


#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.messageArr.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *message = self.messageArr[indexPath.row];
    CGFloat height = [MessageCell heightForString:message];
    height = height < MESSAGE_CELL_MIN_H ? MESSAGE_CELL_MIN_H : height;
    return height;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MessageCell *cell = [tableView dequeueReusableCellWithIdentifier:MessageCellID forIndexPath:indexPath];
    NSString *message = self.messageArr[indexPath.row];
    cell.message = message;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
}


#pragma mark - UIScrollViewDelegate

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    if (scrollView == self.messageTableView) {
        [self endEditing:YES];
    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    if (scrollView == self.messageTableView) {
        CGFloat offsetY = scrollView.contentOffset.y;
        CGFloat maxOffsetY = scrollView.contentSize.height - scrollView.frame.size.height;
        CGFloat diff = 0.5;
        if (offsetY > 0 && (offsetY + diff >= maxOffsetY || offsetY - diff >= maxOffsetY )) { // 用户滑动到了最底部，打开自动滚动
            _isAutoScrollToBottom = YES;
        } else { // 用户向上滑动查看消息时，关闭自动滚动
            _isAutoScrollToBottom = NO;
        }
        [self reloadMessageAndScrollToBottom];
    }
}


#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    textField.text = @"";
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    NSString *messageText = [textField.text stringByTrimmingCharactersInSet:[NSMutableCharacterSet whitespaceCharacterSet]];
    if (messageText.length <= 0) {
        textField.text = @"";
        NSLog(@"消息内容不能为空");
        return YES;
    }
    
    textField.text = @"";
    
    NSLog(@"发送消息: %@", messageText);
    
    // 发送成功后，刷新列表
    [self.messageArr addObject:messageText];
    [self.messageTableView reloadData];
    // 滚动到最后一行
    NSIndexPath *footIndexPath = [NSIndexPath indexPathForRow:self.messageArr.count - 1 inSection:0];
    [self.messageTableView scrollToRowAtIndexPath:footIndexPath atScrollPosition:UITableViewScrollPositionBottom animated:YES];
    
    return YES;
}


#pragma mark - Notification

- (void)keyboardWillChangeFrame:(NSNotification *)notification {
    CGRect endKeyboardRect = [[notification.userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    CGFloat duration = [[notification.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] floatValue];
    
    CGFloat textFieldY = _height;
    CGFloat Y = 0;
    if (endKeyboardRect.origin.y == _height) { // 键盘收起
        textFieldY = _height;
        Y = 0;
//        NSLog(@"11111 键盘frame: %@", NSStringFromCGRect(endKeyboardRect));
    } else {
        textFieldY = endKeyboardRect.origin.y - ChatInputViewHeight;
        Y = 0 - (endKeyboardRect.size.height + ChatInputViewHeight - BottomButtonWidth - 25);
//        NSLog(@"22222222 键盘frame: %@", NSStringFromCGRect(endKeyboardRect));
    }
    [UIView animateWithDuration:duration animations:^{
        CGRect frame = self.frame;
        frame.origin.y = Y;
        self.frame = frame;
        
        CGRect frame1 = self.chatInputView.frame;
        frame1.origin.y = textFieldY - Y;
        self.chatInputView.frame = frame1;
    }];
}


#pragma mark - UIGestureRecognizerDelegate

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    CGPoint touchPoint = [touch locationInView:self];
    
    // 触摸点是否在观众列表区域
    BOOL isTouchAudienceCollectionView = CGRectContainsPoint(self.audienceCollectionView.frame, touchPoint);
    
    if (isTouchAudienceCollectionView) {
        if (gestureRecognizer == self.panForMove) {
            return NO;
        }
    }
    return YES;
}


#pragma mark - Getters

- (UIImageView *)animationImageView {
    if (!_animationImageView) {
        _animationImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, HEIGHT)];
    }
    return _animationImageView;
}

- (UIView *)decorateView {
    if (!_decorateView) {
        _decorateView = [[UIView alloc] initWithFrame:self.bounds];
        _decorateView.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.1];
        _decorateView.clipsToBounds = YES;
    }
    return _decorateView;
}

- (UICollectionView *)audienceCollectionView {
    if (!_audienceCollectionView) {
        CGFloat x = _width / 2;
        CGFloat w = CGRectGetMinX(self.audienceCountView.frame) - x - 2;
        
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        flowLayout.itemSize = CGSizeMake(AUDIENCE_CELL_W, AUDIENCE_CELL_H);
        flowLayout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
        flowLayout.minimumLineSpacing = 0;
        flowLayout.minimumInteritemSpacing = 0;
        
        _audienceCollectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(x, TOP_Y, w, TOP_H) collectionViewLayout:flowLayout];
        _audienceCollectionView.backgroundColor = [UIColor clearColor];
        _audienceCollectionView.showsHorizontalScrollIndicator = NO;
        _audienceCollectionView.dataSource = self;
        _audienceCollectionView.delegate = self;
        [_audienceCollectionView registerClass:[AudienceCell class] forCellWithReuseIdentifier:AudienceCellID];
    }
    return _audienceCollectionView;
}

- (NSMutableArray *)audienceArr {
    if (!_audienceArr) {
        _audienceArr = [NSMutableArray array];
    }
    return _audienceArr;
}

- (UITableView *)messageTableView {
    if (!_messageTableView) {
        CGFloat y = _height - MESSAGE_TABLEVIEW_H - BottomButtonWidth - 25;
        _messageTableView = [[UITableView alloc] initWithFrame:CGRectMake(15, y, MESSAGE_TABLEVIEW_W, MESSAGE_TABLEVIEW_H)];
        _messageTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
        _messageTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _messageTableView.showsVerticalScrollIndicator = NO;
        _messageTableView.backgroundColor = [UIColor clearColor];
        _messageTableView.delegate = self;
        _messageTableView.dataSource = self;
        [_messageTableView registerClass:[MessageCell class] forCellReuseIdentifier:MessageCellID];
    }
    return _messageTableView;
}

- (UIButton *)unreadButton {
    if (!_unreadButton) {
        CGFloat w = 85;
        CGFloat h = 23;
        CGFloat x = CGRectGetMinX(self.messageTableView.frame) + 20;
        CGFloat y = CGRectGetMaxY(self.messageTableView.frame) - h;
        _unreadButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _unreadButton.frame = CGRectMake(x, y, w, h);
        _unreadButton.backgroundColor = [UIColor whiteColor];
        _unreadButton.titleLabel.font = [UIFont systemFontOfSize:12];
        [_unreadButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_unreadButton addTarget:self action:@selector(readNewMessage:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _unreadButton;
}

- (NSMutableArray *)messageArr {
    if (!_messageArr) {
        _messageArr = [NSMutableArray array];
    }
    return _messageArr;
}

- (NSMutableArray *)giftAnimationArr {
    if (!_giftAnimationArr) {
        _giftAnimationArr = [NSMutableArray array];
    }
    return _giftAnimationArr;
}

- (NSMutableArray *)giftOneArr {
    if (!_giftOneArr) {
        _giftOneArr = [NSMutableArray array];
    }
    return _giftOneArr;
}


#pragma mark - 点赞动画效果实现

// 1. 粒子发射器实现
- (CAEmitterLayer *)praiseEmitterLayer {
    if (!_praiseEmitterLayer) {
        _praiseEmitterLayer = [CAEmitterLayer layer];
        _praiseEmitterLayer.emitterPosition = CGPointMake(WIDTH - 60, HEIGHT - 60); // 发射器的位置
        _praiseEmitterLayer.emitterSize = CGSizeMake(20, 20); // 发射器的尺寸大小
        // 渲染效果
        _praiseEmitterLayer.renderMode = kCAEmitterLayerUnordered;
        _praiseEmitterLayer.emitterShape = kCAEmitterLayerPoint;
        
        // 创建保存粒子的数组
        NSMutableArray *cells = [NSMutableArray array];
        // 创建粒子
        for (int i = 0; i < 10; i++) {
            // 发射单元
            CAEmitterCell *cell = [CAEmitterCell emitterCell];
            cell.birthRate = 1; // 粒子创建速率，默认1/s
            cell.lifetime = arc4random_uniform(4) + 1; // 粒子存活时间
            cell.lifetimeRange = 1.5; // 粒子的生存时间容差
            // 粒子的内容
            UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"play_gift"]];
            cell.contents = (id)image.CGImage;
            cell.name = [NSString stringWithFormat:@"%d", i]; // 粒子的名字
            cell.velocity = arc4random_uniform(100) + 100; // 粒子的运动速率
            cell.velocityRange = 80; // 粒子速率的容差
            cell.emissionLongitude = M_PI + M_PI_2; // 粒子在XY平面的发射角度
            cell.emissionRange = M_PI_2 / 6; // 粒子发射角度容差
            cell.scale = 0.3; // 缩放比例
            [cells addObject:cell];
        }
        // 将粒子数组放入发射器中
        _praiseEmitterLayer.emitterCells = cells;
    }
    return _praiseEmitterLayer;
}

// 2. UIView Animation实现
- (void)praiseAnimation {
    // 随机生成一个数字，以便下面拼接图片名
    int imageIndex1 = (arc4random() % 8) + 1;
    int imageIndex2 = (arc4random() % 9) + 1;
    NSString *imageName = [NSString stringWithFormat:@"parise_%d_%d_45x45_", 1, imageIndex2];
    if (imageIndex1 == 1) {
        int imageIndex2 = (arc4random() % 9) + 1;
       imageName = [NSString stringWithFormat:@"parise_%d_%d_45x45_", imageIndex1, imageIndex2];
    } else if (imageIndex1 == 2) {
        int imageIndex2 = (arc4random() % 3) + 1;
        imageName = [NSString stringWithFormat:@"parise_%d_%d_30x30_", imageIndex1, imageIndex2];
    } else if (imageIndex1 == 3) {
        int imageIndex2 = (arc4random() % 6) + 1;
        imageName = [NSString stringWithFormat:@"parise_%d_%d_45x45_", imageIndex1, imageIndex2];
    } else if (imageIndex1 == 4) {
        int imageIndex2 = (arc4random() % 3) + 1;
        imageName = [NSString stringWithFormat:@"parise_%d_%d_45x45_", imageIndex1, imageIndex2];
    } else if (imageIndex1 == 5) {
        int imageIndex2 = (arc4random() % 3) + 1;
        imageName = [NSString stringWithFormat:@"parise_%d_%d_45x45_", imageIndex1, imageIndex2];
    } else if (imageIndex1 == 6) {
        int imageIndex2 = (arc4random() % 1) + 1;
        imageName = [NSString stringWithFormat:@"parise_%d_%d_45x45_", imageIndex1, imageIndex2];
    } else if (imageIndex1 == 7) {
        int imageIndex2 = (arc4random() % 15) + 1;
        imageName = [NSString stringWithFormat:@"parise_%d_%d_30x30_", imageIndex1, imageIndex2];
    } else if (imageIndex1 == 8) {
        int imageIndex2 = (arc4random() % 16) + 1;
        imageName = [NSString stringWithFormat:@"parise_%d_%d_30x30_", imageIndex1, imageIndex2];
    }
    
    // 1. 生成一个UIImageView
    UIImageView *imageView = [[UIImageView alloc] init];
    
    // 2. 初始化frame及其他属性
    CGRect frame = self.frame;
    CGFloat imageViewW = 30;
    CGFloat imageViewH = imageViewW;
    CGFloat startX = frame.size.width - 70;
    CGFloat startY = frame.size.height - 70;
    // 初始化frame，即设置了动画的起点
    imageView.frame = CGRectMake(startX, startY, imageViewW, imageViewH);
    imageView.alpha = 0; // 初始化imageView透明度为0
    imageView.backgroundColor = [UIColor clearColor];
    imageView.clipsToBounds = YES;
    
    // 3. 用0.2秒的时间将imageView的透明度变为1.0，同时将其放大1.3倍，这里参数根据需求设置
    [UIView animateWithDuration:0.2 animations:^{
        imageView.alpha = 1.0;
        imageView.frame = CGRectMake(startX, startY - 30, imageViewW, imageViewH);
        CGAffineTransform transform = CGAffineTransformMakeScale(1.3, 1.3);
        imageView.transform = CGAffineTransformScale(transform, 1, 1);
    }];
    [self.decorateView addSubview:imageView];
    
    // 4. 设置终点frame  随机产生一个动画结束点的x值 (round(): 如果参数是小数，则求本身的四舍五入)
    CGFloat finishX = frame.size.width - round(random() % 200);
    CGFloat finishY = 300; // 动画结束点的y值
    CGFloat scale = round(random() % 2) + 0.7; // imageView在运动过程中的缩放比例 (0.7或1.7)
    scale = 1.0;
    CGFloat speed = 1 / round(random() % 900) + 0.6; // 生成一个作为速度参数的随机数 [0.6, 1.6]
    NSTimeInterval duration = 4 * speed; // 动画执行时间
    if (duration == INFINITY) { // 如果得到的时间是无穷大，就重新赋一个值
        duration = 2.412346;
    }
    
    // 5. 开始动画
    [UIView beginAnimations:nil context:(__bridge void *_Nullable)(imageView)];
    [UIView setAnimationDuration:duration];
    imageView.image = [UIImage imageNamed:imageName];
    // 设置imageView的结束frame
    imageView.frame = CGRectMake(finishX, finishY, imageViewW * scale, imageViewH * scale);
    // 设置渐渐消失的效果，这里的时间最好和动画时间一样
    [UIView animateWithDuration:duration animations:^{
        imageView.alpha = 0;
    }];
    // 6. 结束动画，调用方法销毁imageView
    [UIView setAnimationDidStopSelector:@selector(onPraiseAnimationComplete:finished:context:)];
    [UIView setAnimationDelegate:self];
    [UIView commitAnimations];
}

// 2.1 动画完成后，销毁imageView
- (void)onPraiseAnimationComplete:(NSString *)animationID finished:(NSNumber *)finished context:(void *)context {
    UIImageView *imageView = (__bridge UIImageView *)(context);
    [imageView removeFromSuperview];
    imageView = nil;
}


#pragma mark - Override

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self endEditing:YES];
    
    [self praiseAnimation];
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
