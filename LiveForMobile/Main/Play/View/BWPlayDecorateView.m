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

const NSUInteger CountOfBottomButtonInPlay = 7; // 底部的功能按钮个数

#define LEFT_MARGIN  ((WIDTH - (CountOfBottomButtonInPlay * BOTTOM_BUTTON_WIDTH_IN_PLAY)) / (CountOfBottomButtonInPlay + 1)) // 控件的左边距
#define RIGHT_MARGIN (LEFT_MARGIN) // 控件的右边距
#define TOP_MARGIN   (25)                // 顶部第一行控件的上边距
#define TOP_HEIGHT   (33 * HEIGHT_SCALE) // 顶部第一行控件的高

// 主播信息View的宽度
#define ANCHOR_INFO_VIEW_NORMAL_W (191 * WIDTH_SCALE) // 未关注时的宽度
#define ANCHOR_INFO_VIEW_FOLLOW_W (143 * WIDTH_SCALE) // 关注后的宽度

#define MESSAGE_MAX_COUNT (30) // 聊天消息展示的最大条数


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
@property (nonatomic, strong) UIImageView *anchorRankImageView;
@property (nonatomic, strong) UILabel *anchorNameLabel;
@property (nonatomic, strong) UILabel *anchorIDLabel;
@property (nonatomic, strong) UIButton *anchorFollowButton; // 关注按钮
// 聊天输入框部分
@property (nonatomic, strong) UIView *chatInputView;
@property (nonatomic, strong) UIImageView *chatBackgroundImageView;
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
// 主播金币信息 (coin info)
@property (nonatomic, strong) UIImageView *coinView;
@property (nonatomic, strong) UIImageView *coinImageView;
@property (nonatomic, strong) UIImageView *coinArrowImageView;
@property (nonatomic, strong) UILabel *coinCountLabel;
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
@property (nonatomic, strong) NSMutableArray <GiftModel *>*giftCachesArr; // 礼物的缓存数组

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
    
    // 加在decorateView上的控件: 1.观看人数 2.观众列表 3.底部功能按钮(7个)
    // 1. 在线观看人数
    CGFloat audienceCount_W = 68 * WIDTH_SCALE;
    CGFloat audienceCount_X = _width - RIGHT_MARGIN - audienceCount_W;
    self.audienceCountView = [[UIImageView alloc] initWithFrame:CGRectMake(audienceCount_X, TOP_MARGIN, audienceCount_W, TOP_HEIGHT)];
    self.audienceCountView.backgroundColor = [UIColor colorWithWhite:0.1 alpha:0.4];
    self.audienceCountView.layer.cornerRadius = TOP_HEIGHT / 2;
    self.audienceCountView.layer.masksToBounds = YES;
    self.audienceCountView.userInteractionEnabled = YES;
    [self.audienceCountView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(checkAudienceCount)]];
    [self.decorateView addSubview:self.audienceCountView];
    
    self.audienceCountLabel = [[UILabel alloc] initWithFrame:CGRectMake(4, 0, audienceCount_W - 8, TOP_HEIGHT)];
    self.audienceCountLabel.font = [UIFont boldSystemFontOfSize:12];
    self.audienceCountLabel.textColor = [UIColor whiteColor];
    self.audienceCountLabel.textAlignment = NSTextAlignmentCenter;
    [self.audienceCountView addSubview:self.audienceCountLabel];
    
    // 2. 在线观众列表
    CGFloat audienceCollectionView_margin = 8 * WIDTH_SCALE;
    CGFloat audienceCollectionView_W = audienceCount_X - (2 * audienceCollectionView_margin) - ANCHOR_INFO_VIEW_NORMAL_W - LEFT_MARGIN;
    CGFloat audienceCollectionView_X = LEFT_MARGIN + ANCHOR_INFO_VIEW_NORMAL_W + audienceCollectionView_margin;
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    flowLayout.itemSize = CGSizeMake(AUDIENCE_CELL_W, AUDIENCE_CELL_H);
    flowLayout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
    flowLayout.minimumLineSpacing = 0;
    flowLayout.minimumInteritemSpacing = 0;
    
    self.audienceCollectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(audienceCollectionView_X, TOP_MARGIN, audienceCollectionView_W, TOP_HEIGHT) collectionViewLayout:flowLayout];
    self.audienceCollectionView.backgroundColor = [UIColor clearColor];
    self.audienceCollectionView.showsHorizontalScrollIndicator = NO;
    self.audienceCollectionView.dataSource = self;
    self.audienceCollectionView.delegate = self;
    [self.audienceCollectionView registerClass:[AudienceCell class] forCellWithReuseIdentifier:AudienceCellID];
    [self.decorateView addSubview:self.audienceCollectionView];
    
    // 3. 主播金币数量 (coin)
    CGFloat coinView_H = 24 * HEIGHT_SCALE;
    CGFloat coinView_W = 68 * WIDTH_SCALE;
    CGFloat coinView_Y = CGRectGetMaxY(self.audienceCountView.frame) + (8 * HEIGHT_SCALE);
    CGFloat coinView_X = WIDTH - RIGHT_MARGIN - coinView_W;
    CGFloat coin_margin = 5 * WIDTH_SCALE;
    CGFloat coin_W = 17 * WIDTH_SCALE;
    CGFloat coin_arrow_Y = (coinView_H - coin_W) / 2;
    CGFloat coin_arrow_X = coinView_W - coin_margin - coin_W;
    CGFloat coin_label_X = coin_W + (2 * coin_margin);
    CGFloat coin_label_W = coinView_W - (2 * coin_W) - (4 * coin_margin);
    self.coinView = [[UIImageView alloc] initWithFrame:CGRectMake(coinView_X, coinView_Y, coinView_W, coinView_H)];
    self.coinView.backgroundColor = [UIColor colorWithWhite:0.1 alpha:0.4];
    self.coinView.layer.cornerRadius = coinView_H / 2;
    self.coinView.layer.masksToBounds = YES;
    self.coinView.userInteractionEnabled = YES;
    [self.coinView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(checkCoinCount)]];
    [self.decorateView addSubview:self.coinView];
    // 3.1 金币箭头
    self.coinArrowImageView = [[UIImageView alloc] initWithFrame:CGRectMake(coin_arrow_X, coin_arrow_Y, coin_W, coin_W)];
    self.coinArrowImageView.image = [UIImage imageNamed:@"live_goto_normal_14x14_"];
    [self.coinView addSubview:self.coinArrowImageView];
    // 3.2 金币数量Label
    self.coinCountLabel = [[UILabel alloc] initWithFrame:CGRectMake(coin_label_X, 0, coin_label_W, coinView_H)];
    self.coinCountLabel.textColor = [UIColor whiteColor];
    self.coinCountLabel.textAlignment = NSTextAlignmentCenter;
    self.coinCountLabel.font = [UIFont systemFontOfSize:13];
    [self.coinView addSubview:self.coinCountLabel];
    // 3.3 金币图标
    self.coinImageView = [[UIImageView alloc] initWithFrame:CGRectMake(coin_margin, coin_arrow_Y, coin_W, coin_W)];
    self.coinImageView.image = [UIImage imageNamed:@"live_coin"];
    [self.coinView addSubview:self.coinImageView];
    
    // 4. 消息列表
    [self.decorateView addSubview:self.messageTableView];
    [self.decorateView addSubview:self.unreadButton];
    self.unreadButton.hidden = YES;
    
    
    // 4. 底部的功能按钮(6个)
    CGFloat button_bottomMargin = 15;
    CGFloat button_W = BOTTOM_BUTTON_WIDTH_IN_PLAY;
    CGFloat button_Y = _height - button_bottomMargin - button_W;
    CGFloat button_middleMargin = (_width - (CountOfBottomButtonInPlay * button_W)) / (CountOfBottomButtonInPlay + 1);
    // 4.1 聊天按钮
    self.chatButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.chatButton.frame = CGRectMake(button_middleMargin, button_Y, button_W, button_W);
//    [self.chatButton setImage:[UIImage imageNamed:@"push_chat"] forState:UIControlStateNormal];
    [self.chatButton setImage:[UIImage imageNamed:@"live_button_comment_40x40_"] forState:UIControlStateNormal];
    [self.chatButton setImage:[UIImage imageNamed:@"live_button_comment_pressed_40x40_"] forState:UIControlStateHighlighted];
    [self.chatButton addTarget:self action:@selector(clickChat:) forControlEvents:UIControlEventTouchUpInside];
    [self.decorateView addSubview:self.chatButton];
    // 4.2 私信按钮
    self.pmButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.pmButton.frame = CGRectMake(CGRectGetMaxX(self.chatButton.frame) + button_middleMargin, button_Y, button_W, button_W);
    [self.pmButton setImage:[UIImage imageNamed:@"play_pm_normal"] forState:UIControlStateNormal];
    [self.pmButton setImage:[UIImage imageNamed:@"play_pm_highlighted"] forState:UIControlStateHighlighted];
    [self.pmButton addTarget:self action:@selector(clickPM:) forControlEvents:UIControlEventTouchUpInside];
    [self.decorateView addSubview:self.pmButton];
    // 4.3 点歌按钮
    self.orderSongButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.orderSongButton.frame = CGRectMake(CGRectGetMaxX(self.pmButton.frame) + button_middleMargin, button_Y, button_W, button_W);
//    [self.orderSongButton setImage:[UIImage imageNamed:@"play_music_normal"] forState:UIControlStateNormal];
//    [self.orderSongButton setImage:[UIImage imageNamed:@"play_music_highlighted"] forState:UIControlStateHighlighted];
    [self.orderSongButton setImage:[UIImage imageNamed:@"live_button_play_40x40_"] forState:UIControlStateNormal];
    [self.orderSongButton setImage:[UIImage imageNamed:@"live_button_play_pressed_40x40_"] forState:UIControlStateHighlighted];
    [self.orderSongButton addTarget:self action:@selector(clickOrderSong:) forControlEvents:UIControlEventTouchUpInside];
    [self.decorateView addSubview:self.orderSongButton];
    // 4.4 礼物按钮
    self.giftButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.giftButton.frame = CGRectMake(CGRectGetMaxX(self.orderSongButton.frame) + button_middleMargin, button_Y, button_W, button_W);
    [self.giftButton setImage:[UIImage imageNamed:@"play_gift_normal"] forState:UIControlStateNormal];
    [self.giftButton setImage:[UIImage imageNamed:@"play_gift_highlighted"] forState:UIControlStateHighlighted];
    [self.giftButton addTarget:self action:@selector(clickGift:) forControlEvents:UIControlEventTouchUpInside];
    [self.decorateView addSubview:self.giftButton];
    // 4.5 录制视频按钮
    self.cameraButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.cameraButton.frame = CGRectMake(CGRectGetMaxX(self.giftButton.frame) + button_middleMargin, button_Y, button_W, button_W);
//    [self.cameraButton setImage:[UIImage imageNamed:@"play_video_record"] forState:UIControlStateNormal];
//    [self.cameraButton setImage:[UIImage imageNamed:@"play_video_record_highlighted"] forState:UIControlStateHighlighted];
    
    [self.cameraButton setImage:[UIImage imageNamed:@"live_button_record_40x40_"] forState:UIControlStateNormal];
    [self.cameraButton setImage:[UIImage imageNamed:@"live_button_record_pressed_40x40_"] forState:UIControlStateHighlighted];
    
    [self.cameraButton addTarget:self action:@selector(clickCamera:) forControlEvents:UIControlEventTouchUpInside];
    [self.decorateView addSubview:self.cameraButton];
    // 4.6 分享按钮
    self.shareButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.shareButton.frame = CGRectMake(CGRectGetMaxX(self.cameraButton.frame) + button_middleMargin, button_Y, button_W, button_W);
//    [self.shareButton setImage:[UIImage imageNamed:@"play_share"] forState:UIControlStateNormal];
//    [self.shareButton setImage:[UIImage imageNamed:@"play_share_highlighted"] forState:UIControlStateHighlighted];
    [self.shareButton setImage:[UIImage imageNamed:@"live_button_share_40x40_"] forState:UIControlStateNormal];
    [self.shareButton setImage:[UIImage imageNamed:@"live_button_share_pressed_40x40_"] forState:UIControlStateHighlighted];
    [self.shareButton addTarget:self action:@selector(clickShare:) forControlEvents:UIControlEventTouchUpInside];
    [self.decorateView addSubview:self.shareButton];
    
    
    // 加在self上的控件: 1.关闭按钮 2.主播信息
    // 1. 关闭按钮
    self.closeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.closeButton.frame = CGRectMake(_width - button_middleMargin - button_W, button_Y, button_W, button_W);
//    [self.closeButton setImage:[UIImage imageNamed:@"push_close"] forState:UIControlStateNormal];
//    [self.closeButton setImage:[UIImage imageNamed:@"push_close_highlighted"] forState:UIControlStateHighlighted];
    [self.closeButton setImage:[UIImage imageNamed:@"live_button_close_40x40_"] forState:UIControlStateNormal];
    [self.closeButton setImage:[UIImage imageNamed:@"live_button_close_pressed_40x40_"] forState:UIControlStateHighlighted];
    [self.closeButton addTarget:self action:@selector(closePlay) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.closeButton];
    
    // 2. 主播信息
    CGFloat anchor_W = ANCHOR_INFO_VIEW_NORMAL_W;
    CGFloat anchor_H = TOP_HEIGHT;
    CGFloat anchor_rank_W = 14 * WIDTH_SCALE;
    CGFloat anchor_follow_button_W = 47 * WIDTH_SCALE;
    CGFloat anchor_follow_button_H = 22 * HEIGHT_SCALE;
    CGFloat anchor_label_X = anchor_H + 6;
    CGFloat anchor_label_W = anchor_W - anchor_follow_button_W - anchor_label_X - (anchor_H / 2);
    self.anchorInfoView = [[UIImageView alloc] initWithFrame:CGRectMake(LEFT_MARGIN, TOP_MARGIN, anchor_W, anchor_H)];
    self.anchorInfoView.backgroundColor = [UIColor colorWithWhite:0.1 alpha:0.4];
    self.anchorInfoView.layer.cornerRadius = anchor_H / 2;
    self.anchorInfoView.layer.masksToBounds = YES;
    self.anchorInfoView.userInteractionEnabled = YES;
    [self.anchorInfoView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(checkAnchorInfo)]];
    [self addSubview:self.anchorInfoView];
    // 2.1 主播头像
    self.anchorAvatarImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, anchor_H, anchor_H)];
    self.anchorAvatarImageView.layer.cornerRadius = anchor_H / 2;
    self.anchorAvatarImageView.layer.masksToBounds = YES;
    self.anchorAvatarImageView.layer.borderColor = [UIColor whiteColor].CGColor;
    self.anchorAvatarImageView.layer.borderWidth = 0.8;
    [self.anchorInfoView addSubview:self.anchorAvatarImageView];
    // 2.2 主播等级
    self.anchorRankImageView = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.anchorAvatarImageView.frame) - anchor_rank_W, anchor_H - anchor_rank_W, anchor_rank_W, anchor_rank_W)];
    [self.anchorInfoView addSubview:self.anchorRankImageView];
    // 2.3 主播昵称
    self.anchorNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(anchor_label_X, 0, anchor_label_W, anchor_H * 0.6)];
    self.anchorNameLabel.font = [UIFont boldSystemFontOfSize:12.5];
    self.anchorNameLabel.textColor = [UIColor whiteColor];
    [self.anchorInfoView addSubview:self.anchorNameLabel];
    // 2.4 主播ID
    self.anchorIDLabel = [[UILabel alloc] initWithFrame:CGRectMake(anchor_label_X, CGRectGetMaxY(self.anchorNameLabel.frame) - 0.5, anchor_label_W, anchor_H * 0.4)];
    self.anchorIDLabel.font = [UIFont boldSystemFontOfSize:11];
    self.anchorIDLabel.textColor = [UIColor whiteColor];
    [self.anchorInfoView addSubview:self.anchorIDLabel];
    // 2.5 关注按钮
    self.anchorFollowButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.anchorFollowButton.frame = CGRectMake(anchor_W - 6 - anchor_follow_button_W, (anchor_H - anchor_follow_button_H) / 2, anchor_follow_button_W, anchor_follow_button_H);
    [self.anchorFollowButton setImage:[UIImage imageNamed:@"live_follow_normal_42x20_"] forState:UIControlStateNormal];
    [self.anchorFollowButton addTarget:self action:@selector(followAnchorEvent:) forControlEvents:UIControlEventTouchUpInside];
    [self.anchorInfoView addSubview:self.anchorFollowButton];
    
    // 3. 聊天输入框view
    CGFloat bullet_button_W = 50;
    CGFloat bullet_button_H = 32;
    CGFloat input_margin = 10;
    CGFloat input_textField_X = bullet_button_W + (2 * input_margin);
    CGFloat input_textField_W = WIDTH - input_textField_X - input_margin;
    self.chatInputView = [[UIView alloc] initWithFrame:CGRectMake(0, _height, _width, ChatInputViewHeight)];
    self.chatInputView.backgroundColor = RGB(241, 241, 244);
    [self addSubview:self.chatInputView];
    // 3.1 是否开启弹幕效果
    UIButton *bulletButton = [UIButton buttonWithType:UIButtonTypeCustom];
    bulletButton.frame = CGRectMake(input_margin, (ChatInputViewHeight - bullet_button_H) / 2, bullet_button_W, bullet_button_H);
    [bulletButton setImage:[UIImage imageNamed:@"play_bullet_switch_off"] forState:UIControlStateNormal];
    [bulletButton setImage:[UIImage imageNamed:@"play_bullet_switch_on"] forState:UIControlStateSelected];
    [bulletButton addTarget:self action:@selector(clickBulletButton:) forControlEvents:UIControlEventTouchUpInside];
    [self.chatInputView addSubview:bulletButton];
    // 3.2 输入框背景
    self.chatBackgroundImageView = [[UIImageView alloc] initWithFrame:CGRectMake(input_textField_X, (ChatInputViewHeight - bullet_button_H) / 2, input_textField_W, bullet_button_H)];
    self.chatBackgroundImageView.backgroundColor = RGB(233, 233, 233);
    self.chatBackgroundImageView.layer.borderWidth = 1;
    self.chatBackgroundImageView.layer.borderColor = RGB(244, 85, 133).CGColor;
    self.chatBackgroundImageView.layer.masksToBounds = YES;
    self.chatBackgroundImageView.layer.cornerRadius = bullet_button_H / 2;
    self.chatBackgroundImageView.userInteractionEnabled = YES;
    [self.chatInputView addSubview:self.chatBackgroundImageView];
    // 3.3 输入框
    self.chatInputTextField = [[UITextField alloc] initWithFrame:CGRectMake(bullet_button_H / 2, 1, input_textField_W - bullet_button_H, bullet_button_H - 2)];
    self.chatInputTextField.backgroundColor = RGB(233, 233, 233);
    self.chatInputTextField.delegate = self;
    self.chatInputTextField.returnKeyType = UIReturnKeySend;
    self.chatInputTextField.font = [UIFont systemFontOfSize:15];
    NSAttributedString *placeholderAttriStr = [[NSAttributedString alloc] initWithString:@"说点什么吧" attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:15], NSForegroundColorAttributeName : RGB(180, 180, 180)}];
    self.chatInputTextField.attributedPlaceholder = placeholderAttriStr;
    [self.chatBackgroundImageView addSubview:self.chatInputTextField];
    
    // 4. 礼物展示
    self.giftOneView = [[PresentView alloc] initWithFrame:CGRectMake(0, 300 * HEIGHT_SCALE, WIDTH * 0.4, 100)];
    self.giftOneView.backgroundColor = [UIColor clearColor];
    self.giftOneView.delegate = self;
    [self.decorateView addSubview:self.giftOneView];
    
    
    // 测试数据
//    self.anchorAvatarImageView.image = [UIImage imageNamed:@"avatar_default"];
//    self.anchorRankImageView.image = [UIImage imageNamed:@"tuhao_1_14x14_"];
//    self.anchorNameLabel.text = @"清灵💋💋💋";
//    self.anchorIDLabel.text = [NSString stringWithFormat:@"@%@", @"120598498"];
//    self.coinCountLabel.text = @"6";
//    self.audienceCountLabel.text = [NSString stringWithFormat:@"%@人", @"1100"];
    
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
        [self.messageTableView reloadData];
        // 滚动到最后一行
        NSIndexPath *footIndexPath = [NSIndexPath indexPathForRow:self.messageArr.count - 1 inSection:0];
        [self.messageTableView scrollToRowAtIndexPath:footIndexPath atScrollPosition:UITableViewScrollPositionBottom animated:NO];
        
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
    // 1. 先把礼物存储到缓存数组中
    [self.giftCachesArr addObject:gift];
    
    // 2. 取出第一个礼物进行展示
    GiftModel *firstGift = self.giftCachesArr.firstObject;
    [self giftAnimationStart:firstGift];
    
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
    // 1. 先判断是否正在播放动画
    if (self.animationImageView.isAnimating) {
        return;
    }
    // 2. 获取礼物信息
    BWPlistHelper *plistHelper = [[BWPlistHelper alloc] initWithPropertyListFileName:@"GiftResource.plist"];
    // 2.1 礼物图片序列帧
    NSArray *images = [plistHelper imagesWithGiftId:gift.giftId];
    if (images.count == 0) {
        return;
    }
    // 2.2 礼物动画时长
    NSTimeInterval duration = [plistHelper durationWithGiftId:gift.giftId];
    // 2.3 礼物图片的位置
    CGFloat x = [plistHelper imageXWithGiftId:gift.giftId] * WIDTH_SCALE;
    CGFloat y = [plistHelper imageYWithGiftId:gift.giftId] * HEIGHT_SCALE;
    CGFloat w = [plistHelper imageWWithGiftId:gift.giftId] * WIDTH_SCALE;
    CGFloat h = [plistHelper imageHWithGiftId:gift.giftId] * HEIGHT_SCALE;
    // 3. 设置动画属性
    self.animationImageView.frame = CGRectMake(x, y, w, h);
    self.animationImageView.animationImages = images;
    self.animationImageView.animationDuration = duration;
    self.animationImageView.animationRepeatCount = 1;
    // 4. 开始动画
    [self.animationImageView startAnimating];
    // 5. 动画播放完成后，清除礼物缓存
    [self performSelector:@selector(giftAnimationCompleted:) withObject:gift.giftName afterDelay:duration + 0.1];
}

/** 完成礼物动画 */
- (void)giftAnimationCompleted:(id)object {
    // 1. 停止动画
    [self.animationImageView stopAnimating];
    // 2. 缓存数组中移除已播放的礼物
    if (self.giftCachesArr.count == 0) {
        return;
    }
    [self.giftCachesArr removeObjectAtIndex:0];
    // 3. 开始播放下一个动画 (缓存数组中的第一个)
    if (self.giftCachesArr.count == 0) {
        return;
    }
    GiftModel *firstGift = self.giftCachesArr.firstObject;
    [self giftAnimationStart:firstGift];
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

// 查看主播信息
- (void)checkAnchorInfo {
    NSLog(@"查看主播信息");
}

// 关注了主播
- (void)followAnchorEvent:(UIButton *)sender {
    sender.hidden = YES;
    
    // 调整控件frame
    CGRect frame = self.anchorInfoView.frame;
    frame.size.width = ANCHOR_INFO_VIEW_FOLLOW_W;
    self.anchorInfoView.frame = frame;
    
    frame = self.anchorNameLabel.frame;
    frame.size.width = CGRectGetWidth(self.anchorInfoView.frame) - CGRectGetMinX(frame) - CGRectGetHeight(self.anchorInfoView.frame) / 2;
    self.anchorNameLabel.frame = frame;
    
    CGFloat delta = ANCHOR_INFO_VIEW_NORMAL_W - ANCHOR_INFO_VIEW_FOLLOW_W;
    frame = self.audienceCollectionView.frame;
    frame.origin.x -= delta;
    frame.size.width += delta;
    self.audienceCollectionView.frame = frame;
    
    NSLog(@"关注了主播");
}

// 查看在线人数
- (void)checkAudienceCount {
    NSLog(@"查看在线人数");
}

// 查看金币数量
- (void)checkCoinCount {
    NSLog(@"查看金币数量");
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
        Y = 0 - (endKeyboardRect.size.height + ChatInputViewHeight - BOTTOM_BUTTON_WIDTH_IN_PLAY - 25);
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

- (NSMutableArray *)audienceArr {
    if (!_audienceArr) {
        _audienceArr = [NSMutableArray array];
    }
    return _audienceArr;
}

- (UITableView *)messageTableView {
    if (!_messageTableView) {
        CGFloat y = _height - MESSAGE_TABLEVIEW_H - BOTTOM_BUTTON_WIDTH_IN_PLAY - 25;
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

- (NSMutableArray *)giftCachesArr {
    if (!_giftCachesArr) {
        _giftCachesArr = [NSMutableArray array];
    }
    return _giftCachesArr;
}

- (NSMutableArray *)giftOneArr {
    if (!_giftOneArr) {
        _giftOneArr = [NSMutableArray array];
    }
    return _giftOneArr;
}


#pragma mark - Setters

- (void)setModel:(LiveListModel *)model {
    _model = model;
    
    [self.anchorAvatarImageView sd_setImageWithURL:[NSURL URLWithString:model.list_user_head] placeholderImage:[UIImage imageNamed:@"avatar_default"]];
    NSInteger rank = [model.rank integerValue];
    if (rank == 0) {
        self.anchorRankImageView.image = [UIImage imageNamed:@"tuhao_1_14x14_"];
    } else if (rank == 1) {
        self.anchorRankImageView.image = [UIImage imageNamed:@"tuhao_2_14x14_"];
    } else {
        self.anchorRankImageView.image = [UIImage imageNamed:@"tuhao_3_14x14_"];
    }
    self.anchorNameLabel.text = model.list_user_name;
    self.anchorIDLabel.text = [NSString stringWithFormat:@"@%@", @"120598498"];
    self.coinCountLabel.text = @"6";
    self.audienceCountLabel.text = [NSString stringWithFormat:@"%@人", model.audience_num];
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
            UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"play_gift_normal"]];
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
