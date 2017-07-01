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

#define TOP_Y (25) // 顶部第一行控件的y值
#define TOP_H (30) // 顶部第一行控件的高
#define TOP_LEFT_MARGIN  (10) // 顶部第一行控件的左边距
#define TOP_RIGHT_MARGIN (10) // 顶部第一行控件的右边距

const NSUInteger ButtonCountOfPlay = 7;     // 底部的功能按钮个数

@interface BWPlayDecorateView () <UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UIGestureRecognizerDelegate> {
    CGFloat _width;
    CGFloat _height;
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


// 用来放置除关闭按钮以外的其他控件
@property (nonatomic, strong) UIView *decorateView;

// 加在decorateView上的控件
// 在线观看人数
@property (nonatomic, strong) UIImageView *audienceCountView;
@property (nonatomic, strong) UILabel *audienceCountLabel;
// 在线观众列表
@property (nonatomic, strong) UICollectionView *audienceCollectionView;
@property (nonatomic, strong) NSMutableArray *audienceArr;
// 底部功能按钮
@property (nonatomic, strong) UIButton *chatButton;
@property (nonatomic, strong) UIButton *pmButton;        // 私信按钮 (Private Message)
@property (nonatomic, strong) UIButton *orderSongButton; // 点歌按钮
@property (nonatomic, strong) UIButton *giftButton;   // 礼物按钮
@property (nonatomic, strong) UIButton *cameraButton; // 录制视频按钮
@property (nonatomic, strong) UIButton *shareButton;  // 分享按钮

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
        _width = frame.size.width;
        _height = frame.size.height;
        
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
    
    // 3. 底部的功能按钮(6个)
    CGFloat button_bottomMargin = 15;
    CGFloat button_W = BottomButtonWidth;
    CGFloat button_Y = _height - button_bottomMargin - button_W;
    CGFloat button_middleMargin = (_width - (ButtonCountOfPlay * button_W)) / (ButtonCountOfPlay + 1);
    // 3.1 聊天按钮
    self.chatButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.chatButton.frame = CGRectMake(button_middleMargin, button_Y, button_W, button_W);
    [self.chatButton setImage:[UIImage imageNamed:@"push_chat"] forState:UIControlStateNormal];
    [self.chatButton addTarget:self action:@selector(clickChat:) forControlEvents:UIControlEventTouchUpInside];
    [self.decorateView addSubview:self.chatButton];
    // 3.2 私信按钮
    self.pmButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.pmButton.frame = CGRectMake(CGRectGetMaxX(self.chatButton.frame) + button_middleMargin, button_Y, button_W, button_W);
    [self.pmButton setImage:[UIImage imageNamed:@"play_pm"] forState:UIControlStateNormal];
    [self.pmButton addTarget:self action:@selector(clickPM:) forControlEvents:UIControlEventTouchUpInside];
    [self.decorateView addSubview:self.pmButton];
    // 3.3 点歌按钮
    self.orderSongButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.orderSongButton.frame = CGRectMake(CGRectGetMaxX(self.pmButton.frame) + button_middleMargin, button_Y, button_W, button_W);
    [self.orderSongButton setImage:[UIImage imageNamed:@"push_chat"] forState:UIControlStateNormal];
    [self.orderSongButton addTarget:self action:@selector(clickOrderSong:) forControlEvents:UIControlEventTouchUpInside];
    [self.decorateView addSubview:self.orderSongButton];
    // 3.4 礼物按钮
    self.giftButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.giftButton.frame = CGRectMake(CGRectGetMaxX(self.orderSongButton.frame) + button_middleMargin, button_Y, button_W, button_W);
    [self.giftButton setImage:[UIImage imageNamed:@"play_gift"] forState:UIControlStateNormal];
    [self.giftButton addTarget:self action:@selector(clickGift:) forControlEvents:UIControlEventTouchUpInside];
    [self.decorateView addSubview:self.giftButton];
    // 3.5 录制视频按钮
    self.cameraButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.cameraButton.frame = CGRectMake(CGRectGetMaxX(self.giftButton.frame) + button_middleMargin, button_Y, button_W, button_W);
    [self.cameraButton setImage:[UIImage imageNamed:@"play_video_record"] forState:UIControlStateNormal];
    [self.cameraButton setImage:[UIImage imageNamed:@"play_video_record_highlighted"] forState:UIControlStateHighlighted];
    [self.cameraButton addTarget:self action:@selector(clickCamera:) forControlEvents:UIControlEventTouchUpInside];
    [self.decorateView addSubview:self.cameraButton];
    // 3.6 分享按钮
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
    NSLog(@"此时应弹出键盘，准备输入...");
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

- (UIView *)decorateView {
    if (!_decorateView) {
        _decorateView = [[UIView alloc] initWithFrame:self.bounds];
        _decorateView.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.1];
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

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
