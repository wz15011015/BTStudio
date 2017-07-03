//
//  BWPushDecorateView.m
//  LiveForMobile
//
//  Created by  Sierra on 2017/6/21.
//  Copyright © 2017年 BaiFuTak. All rights reserved.
//

#import "BWPushDecorateView.h"
#import "BWMacro.h"
#import "AudienceCell.h"
#import "MessageCell.h"
#import "FilterCell.h"
#import "AudioEffectCell.h"
#import "FilterModel.h"
#import "AudioEffectModel.h"

#define TOP_Y (25) // 顶部第一行控件的y值
#define TOP_H (30) // 顶部第一行控件的高
#define TOP_LEFT_MARGIN  (10) // 顶部第一行控件的左边距
#define TOP_RIGHT_MARGIN (10) // 顶部第一行控件的右边距

#define TOOLBARVIEW_H (170)
#define TOOLSCROLLVIEW_H (TOOLBARVIEW_H * 0.7)
#define TOOLBUTTONSCROLLVIEW_H (TOOLBARVIEW_H * 0.3)

#define MUSICBARVIEW_H (170)
#define MUSICSCROLLVIEW_H (TOOLBARVIEW_H * 0.7)
#define MUSICAUDIOEFFECTSCROLLVIEW_H (TOOLBARVIEW_H * 0.3)

const NSUInteger ButtonCount = 6;     // 底部的功能按钮个数
const NSUInteger ToolButtonCount = 4; // 工具按钮的个数

@interface BWPushDecorateView () <UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UITextFieldDelegate, UITableViewDelegate, UITableViewDataSource> {
    CGFloat _width;
    CGFloat _height;
    
    CGPoint _touchBeganPoint;
    CGPoint _touchMovedPoint;
    
    UIButton *_selectedToolButton;
}
@property (nonatomic, strong) UITapGestureRecognizer *tapForFocus; // 聚焦点击手势
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
// 底部功能按钮
@property (nonatomic, strong) UIButton *chatButton;
@property (nonatomic, strong) UIButton *cameraSwitchButton;
@property (nonatomic, strong) UIButton *beautyButton;
@property (nonatomic, strong) UIButton *musicButton;

// 美颜部分: 底部用来放置各个功能模块展开后的控件的工具view
@property (nonatomic, strong) UIView *toolBarView;
@property (nonatomic, strong) UIView *toolBarAboveView; // toolBarView之上的view，用来实现点击时隐藏toolBarView
@property (nonatomic, strong) UIScrollView *toolButtonScrollView; // 放置工具按钮
@property (nonatomic, strong) UIScrollView *toolScrollView; // 放置各个工具
@property (nonatomic, strong) UIButton *toolBeautyButton;   // 美颜工具按钮
@property (nonatomic, strong) UIButton *toolFilterButton;   // 滤镜工具按钮
@property (nonatomic, strong) UIButton *toolMotionButton;   // 动效工具按钮
// 美颜工具
@property (nonatomic, strong) UISlider *sliderBigEye;    // 大眼滑杆
@property (nonatomic, strong) UISlider *sliderSlimFace;  // 瘦脸滑杆
@property (nonatomic, strong) UISlider *sliderBeauty;    // 美颜滑杆
@property (nonatomic, strong) UISlider *sliderWhitening; // 美白滑杆
// 滤镜类型
@property (nonatomic, strong) UICollectionView *filterCollectionView;
@property (nonatomic, strong) NSMutableArray <FilterModel *>*filterArr;

// 音效部分:
@property (nonatomic, strong) UIView *musicBarView;
@property (nonatomic, strong) UIView *musicBarAboveView; // musicBarView之上的view，用来实现点击时隐藏musicBarView
// 背景音乐BGM
@property (nonatomic, strong) UIButton *bgmSelectButton; // 选择bgm按钮
@property (nonatomic, strong) UIButton *bgmStopButton;   // 关闭bgm按钮
@property (nonatomic, strong) UISlider *sliderVolumeForBGM;   // 背景音乐音量调整滑杆
@property (nonatomic, strong) UISlider *sliderVolumeForVoice; // 人声音量调整滑杆
// 音效类型
@property (nonatomic, strong) UICollectionView *audioEffectCollectionView;
@property (nonatomic, strong) NSMutableArray <AudioEffectModel *>*audioEffectArr;

@end

@implementation BWPushDecorateView

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
    
    // 滤镜类型
    FilterModel *filter0 = [[FilterModel alloc] init];
    filter0.title = @"原图";
    filter0.icon = @"filter_icon_original";
    filter0.selected = YES;
    
    FilterModel *filter1 = [[FilterModel alloc] init];
    filter1.title = @"美白";
    filter1.icon = @"filter_icon_white";
    
    FilterModel *filter2 = [[FilterModel alloc] init];
    filter2.title = @"浪漫";
    filter2.icon = @"filter_icon_langman";
    
    FilterModel *filter3 = [[FilterModel alloc] init];
    filter3.title = @"清新";
    filter3.icon = @"filter_icon_qingxin";
    
    FilterModel *filter4 = [[FilterModel alloc] init];
    filter4.title = @"唯美";
    filter4.icon = @"filter_icon_weimei";
    
    FilterModel *filter5 = [[FilterModel alloc] init];
    filter5.title = @"粉嫩";
    filter5.icon = @"filter_icon_fennen";
    
    FilterModel *filter6 = [[FilterModel alloc] init];
    filter6.title = @"怀旧";
    filter6.icon = @"filter_icon_huaijiu";
    
    FilterModel *filter7 = [[FilterModel alloc] init];
    filter7.title = @"蓝调";
    filter7.icon = @"filter_icon_landiao";
    
    FilterModel *filter8 = [[FilterModel alloc] init];
    filter8.title = @"清凉";
    filter8.icon = @"filter_icon_qingliang";
    
    FilterModel *filter9 = [[FilterModel alloc] init];
    filter9.title = @"日系";
    filter9.icon = @"filter_icon_rixi";
    
    self.filterArr = [NSMutableArray arrayWithObjects:filter0, filter1, filter2, filter3, filter4, filter5, filter6, filter7, filter8, filter9, nil];
    
    // 音效类型
    AudioEffectModel *effect0 = [[AudioEffectModel alloc] init];
    effect0.name = @"原声";
    effect0.selected = YES;
    AudioEffectModel *effect1 = [[AudioEffectModel alloc] init];
    effect1.name = @"KTV";
    AudioEffectModel *effect2 = [[AudioEffectModel alloc] init];
    effect2.name = @"房间";
    AudioEffectModel *effect3 = [[AudioEffectModel alloc] init];
    effect3.name = @"会堂";
    AudioEffectModel *effect4 = [[AudioEffectModel alloc] init];
    effect4.name = @"低沉";
    AudioEffectModel *effect5 = [[AudioEffectModel alloc] init];
    effect5.name = @"洪亮";
    AudioEffectModel *effect6 = [[AudioEffectModel alloc] init];
    effect6.name = @"金属";
    AudioEffectModel *effect7 = [[AudioEffectModel alloc] init];
    effect7.name = @"磁性";
    self.audioEffectArr = [NSMutableArray arrayWithObjects:effect0, effect1, effect2, effect3, effect4, effect5, effect6, effect7, nil];
    
    // 注册键盘高度变化的通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillChangeFrame:) name:UIKeyboardWillChangeFrameNotification object:nil];
    
    // 1. 添加点击聚焦手势
    self.tapForFocus = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickScreen:)];
    [self addGestureRecognizer:self.tapForFocus];
    
    // 2. 添加平移手势,用来移动decorateView
    self.panForMove = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panMoveDecorateView:)];
    [self addGestureRecognizer:self.panForMove];
}

// 初始化子控件并添加
- (void)addSubViews {
    [self addSubview:self.decorateView];
    
    // 加在decorateView上的控件: 1.观看人数 2.观众列表 3.底部功能按钮(6个) 4.美颜部分 5.音效部分
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

    // 1. 底部的功能按钮
    //    CGFloat button_leftMargin = 15;
    CGFloat button_bottomMargin = 15;
    CGFloat button_W = BottomButtonWidth;
    CGFloat button_Y = _height - button_bottomMargin - button_W;
    CGFloat button_middleMargin = (_width - (ButtonCount * button_W)) / (ButtonCount + 1);
    // 1.1 聊天按钮
    self.chatButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.chatButton.frame = CGRectMake(button_middleMargin, button_Y, button_W, button_W);
    [self.chatButton setImage:[UIImage imageNamed:@"push_chat"] forState:UIControlStateNormal];
    [self.chatButton addTarget:self action:@selector(clickChat:) forControlEvents:UIControlEventTouchUpInside];
    [self.decorateView addSubview:self.chatButton];
    // 1.2 照明灯按钮
    self.torchButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.torchButton.frame = CGRectMake(CGRectGetMaxX(self.chatButton.frame) + button_middleMargin, button_Y, button_W, button_W);
    [self.torchButton setImage:[UIImage imageNamed:@"push_torch_off"] forState:UIControlStateNormal];
    [self.torchButton addTarget:self action:@selector(clickTorch:) forControlEvents:UIControlEventTouchUpInside];
    [self.decorateView addSubview:self.torchButton];
    // 1.3 前后摄像头切换按钮
    self.cameraSwitchButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.cameraSwitchButton.frame = CGRectMake(CGRectGetMaxX(self.torchButton.frame) + button_middleMargin, button_Y, button_W, button_W);
    [self.cameraSwitchButton setImage:[UIImage imageNamed:@"push_camera_switch"] forState:UIControlStateNormal];
    [self.cameraSwitchButton addTarget:self action:@selector(clickCameraSwitch:) forControlEvents:UIControlEventTouchUpInside];
    [self.decorateView addSubview:self.cameraSwitchButton];
    // 1.4 美颜按钮
    self.beautyButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.beautyButton.frame = CGRectMake(CGRectGetMaxX(self.cameraSwitchButton.frame) + button_middleMargin, button_Y, button_W, button_W);
    [self.beautyButton setImage:[UIImage imageNamed:@"push_beauty"] forState:UIControlStateNormal];
    [self.beautyButton addTarget:self action:@selector(clickBeauty:) forControlEvents:UIControlEventTouchUpInside];
    [self.decorateView addSubview:self.beautyButton];
    // 1.5 音效按钮
    self.musicButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.musicButton.frame = CGRectMake(CGRectGetMaxX(self.beautyButton.frame) + button_middleMargin, button_Y, button_W, button_W);
    [self.musicButton setImage:[UIImage imageNamed:@"push_music"] forState:UIControlStateNormal];
    [self.musicButton addTarget:self action:@selector(clickMusic:) forControlEvents:UIControlEventTouchUpInside];
    [self.decorateView addSubview:self.musicButton];
    
    // 2. 工具view
    [self.decorateView addSubview:self.toolBarAboveView];
    [self.decorateView addSubview:self.toolBarView];
    self.toolBarAboveView.hidden = YES;
    self.toolBarView.hidden = YES;
    // 2.1 工具按钮
    CGFloat tool_button_W = 60;
    CGFloat tool_button_Y = 0;
    CGFloat tool_button_H = CGRectGetHeight(self.toolButtonScrollView.frame);
    CGFloat tool_buttonMargin = (_width - (ToolButtonCount * tool_button_W)) / (ToolButtonCount + 1);
    // 2.1.1 美颜按钮
    self.toolBeautyButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.toolBeautyButton.tag = 101;
    self.toolBeautyButton.frame = CGRectMake(tool_buttonMargin, tool_button_Y, tool_button_W, tool_button_H);
    [self.toolBeautyButton setImage:[UIImage imageNamed:@"white_beauty"] forState:UIControlStateNormal];
    [self.toolBeautyButton setImage:[UIImage imageNamed:@"white_beauty_selected"] forState:UIControlStateSelected];
    [self.toolBeautyButton setTitle:@"美颜" forState:UIControlStateNormal];
    [self.toolBeautyButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.toolBeautyButton setTitleColor:RGB(10, 204, 172) forState:UIControlStateSelected];
    self.toolBeautyButton.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, -5);
    [self.toolBeautyButton addTarget:self action:@selector(selectTool:) forControlEvents:UIControlEventTouchUpInside];
    self.toolBeautyButton.selected = YES;
    [self.toolButtonScrollView addSubview:self.toolBeautyButton];
    _selectedToolButton = self.toolBeautyButton;
    // 2.1.2 滤镜按钮
    self.toolFilterButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.toolFilterButton.tag = 102;
    self.toolFilterButton.frame = CGRectMake(CGRectGetMaxX(self.toolBeautyButton.frame) + tool_buttonMargin, tool_button_Y, tool_button_W, tool_button_H);
    [self.toolFilterButton setImage:[UIImage imageNamed:@"beautiful"] forState:UIControlStateNormal];
    [self.toolFilterButton setImage:[UIImage imageNamed:@"beautiful_selected"] forState:UIControlStateSelected];
    [self.toolFilterButton setTitle:@"滤镜" forState:UIControlStateNormal];
    [self.toolFilterButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.toolFilterButton setTitleColor:RGB(10, 204, 172) forState:UIControlStateSelected];
    self.toolFilterButton.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, -5);
    [self.toolFilterButton addTarget:self action:@selector(selectTool:) forControlEvents:UIControlEventTouchUpInside];
    [self.toolButtonScrollView addSubview:self.toolFilterButton];
    // 2.1.3 动效按钮
    self.toolMotionButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.toolMotionButton.tag = 103;
    self.toolMotionButton.frame = CGRectMake(CGRectGetMaxX(self.toolFilterButton.frame) + tool_buttonMargin, tool_button_Y, tool_button_W, tool_button_H);
    [self.toolMotionButton setImage:[UIImage imageNamed:@"motion"] forState:UIControlStateNormal];
    [self.toolMotionButton setImage:[UIImage imageNamed:@"motion_selected"] forState:UIControlStateSelected];
    [self.toolMotionButton setTitle:@"动效" forState:UIControlStateNormal];
    [self.toolMotionButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.toolMotionButton setTitleColor:RGB(10, 204, 172) forState:UIControlStateSelected];
    self.toolMotionButton.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, -5);
    [self.toolMotionButton addTarget:self action:@selector(selectTool:) forControlEvents:UIControlEventTouchUpInside];
    //    [self.toolButtonScrollView addSubview:self.toolMotionButton];
    
    // 2.2 工具
    // 2.2.1 美颜工具
    CGFloat tool_beauty_LeftMargin = 10;
    CGFloat tool_beauty_TopMargin = 20;
    CGFloat tool_beauty_MiddleMargin = 15;
    CGFloat tool_beauty_H = 30;
    UIFont *tool_beauty_Font = [UIFont systemFontOfSize:12];
    NSString *tool_beauty_Title = @"大眼";
    CGSize tool_beauty_LabelSize = [tool_beauty_Title boundingRectWithSize:CGSizeMake(80, tool_beauty_H) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : tool_beauty_Font} context:nil].size;
    CGFloat tool_beauty_LabelW = tool_beauty_LabelSize.width;
    CGFloat tool_beauty_SliderW = (_width - (2 * tool_beauty_LabelW) - (2 * tool_beauty_LeftMargin) - (3 * tool_beauty_MiddleMargin)) / 2;
    
    // 2.2.1.1 大眼
    UILabel *bigEyeLabel = [[UILabel alloc] initWithFrame:CGRectMake(tool_beauty_LeftMargin, tool_beauty_TopMargin, tool_beauty_LabelW, tool_beauty_H)];
    bigEyeLabel.font = tool_beauty_Font;
    bigEyeLabel.text = @"大眼";
    [self.toolScrollView addSubview:bigEyeLabel];
    
    self.sliderBigEye = [[UISlider alloc] initWithFrame:CGRectMake(CGRectGetMaxX(bigEyeLabel.frame) + tool_beauty_MiddleMargin, tool_beauty_TopMargin, tool_beauty_SliderW, tool_beauty_H)];
    [self.sliderBigEye setThumbImage:[UIImage imageNamed:@"slider_thumb"] forState:UIControlStateNormal];
    [self.sliderBigEye setMinimumTrackImage:[UIImage imageNamed:@"slider_green"] forState:UIControlStateNormal];
    [self.sliderBigEye setMaximumTrackImage:[UIImage imageNamed:@"slider_gray"] forState:UIControlStateNormal];
    [self.sliderBigEye addTarget:self action:@selector(sliderValueChange:) forControlEvents:UIControlEventValueChanged];
    self.sliderBigEye.minimumValue = 0;
    self.sliderBigEye.maximumValue = 9;
    self.sliderBigEye.value = 0;
    self.sliderBigEye.tag = 111;
    [self.toolScrollView addSubview:self.sliderBigEye];
    
    // 2.2.1.2 瘦脸
    UILabel *slimFaceLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.sliderBigEye.frame) + tool_beauty_MiddleMargin, tool_beauty_TopMargin, tool_beauty_LabelW, tool_beauty_H)];
    slimFaceLabel.font = tool_beauty_Font;
    slimFaceLabel.text = @"瘦脸";
    [self.toolScrollView addSubview:slimFaceLabel];
    
    self.sliderSlimFace = [[UISlider alloc] initWithFrame:CGRectMake(CGRectGetMaxX(slimFaceLabel.frame) + tool_beauty_MiddleMargin, tool_beauty_TopMargin, tool_beauty_SliderW, tool_beauty_H)];
    [self.sliderSlimFace setThumbImage:[UIImage imageNamed:@"slider_thumb"] forState:UIControlStateNormal];
    [self.sliderSlimFace setMinimumTrackImage:[UIImage imageNamed:@"slider_green"] forState:UIControlStateNormal];
    [self.sliderSlimFace setMaximumTrackImage:[UIImage imageNamed:@"slider_gray"] forState:UIControlStateNormal];
    [self.sliderSlimFace addTarget:self action:@selector(sliderValueChange:) forControlEvents:UIControlEventValueChanged];
    self.sliderSlimFace.minimumValue = 0;
    self.sliderSlimFace.maximumValue = 9;
    self.sliderSlimFace.value = 0;
    self.sliderSlimFace.tag = 112;
    [self.toolScrollView addSubview:self.sliderSlimFace];
    
    // 2.2.1.3 美颜
    UILabel *beautyLabel = [[UILabel alloc] initWithFrame:CGRectMake(tool_beauty_LeftMargin, CGRectGetMaxY(bigEyeLabel.frame) + tool_beauty_TopMargin, tool_beauty_LabelW, tool_beauty_H)];
    beautyLabel.font = tool_beauty_Font;
    beautyLabel.text = @"美颜";
    [self.toolScrollView addSubview:beautyLabel];
    
    self.sliderBeauty = [[UISlider alloc] initWithFrame:CGRectMake(CGRectGetMaxX(beautyLabel.frame) + tool_beauty_MiddleMargin, CGRectGetMinY(beautyLabel.frame), tool_beauty_SliderW, tool_beauty_H)];
    [self.sliderBeauty setThumbImage:[UIImage imageNamed:@"slider_thumb"] forState:UIControlStateNormal];
    [self.sliderBeauty setMinimumTrackImage:[UIImage imageNamed:@"slider_green"] forState:UIControlStateNormal];
    [self.sliderBeauty setMaximumTrackImage:[UIImage imageNamed:@"slider_gray"] forState:UIControlStateNormal];
    [self.sliderBeauty addTarget:self action:@selector(sliderValueChange:) forControlEvents:UIControlEventValueChanged];
    self.sliderBeauty.minimumValue = 0;
    self.sliderBeauty.maximumValue = 9;
    self.sliderBeauty.value = 6.3;
    self.sliderBeauty.tag = 113;
    [self.toolScrollView addSubview:self.sliderBeauty];
    
    // 2.2.1.4 美白
    UILabel *whiteningLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.sliderBeauty.frame) + tool_beauty_MiddleMargin, CGRectGetMaxY(bigEyeLabel.frame) + tool_beauty_TopMargin, tool_beauty_LabelW, tool_beauty_H)];
    whiteningLabel.font = tool_beauty_Font;
    whiteningLabel.text = @"美白";
    [self.toolScrollView addSubview:whiteningLabel];
    
    self.sliderWhitening = [[UISlider alloc] initWithFrame:CGRectMake(CGRectGetMaxX(whiteningLabel.frame) + tool_beauty_MiddleMargin, CGRectGetMinY(whiteningLabel.frame), tool_beauty_SliderW, tool_beauty_H)];
    [self.sliderWhitening setThumbImage:[UIImage imageNamed:@"slider_thumb"] forState:UIControlStateNormal];
    [self.sliderWhitening setMinimumTrackImage:[UIImage imageNamed:@"slider_green"] forState:UIControlStateNormal];
    [self.sliderWhitening setMaximumTrackImage:[UIImage imageNamed:@"slider_gray"] forState:UIControlStateNormal];
    [self.sliderWhitening addTarget:self action:@selector(sliderValueChange:) forControlEvents:UIControlEventValueChanged];
    self.sliderWhitening.minimumValue = 0;
    self.sliderWhitening.maximumValue = 9;
    self.sliderWhitening.value = 2.7;
    self.sliderWhitening.tag = 114;
    [self.toolScrollView addSubview:self.sliderWhitening];
    
    // 2.2.2 滤镜工具
    [self.toolScrollView addSubview:self.filterCollectionView];
    
    // 2.2.3 动效工具
    
    
    // 3. 音效view
    [self.decorateView addSubview:self.musicBarAboveView];
    [self.decorateView addSubview:self.musicBarView];
    self.musicBarAboveView.hidden = YES;
    self.musicBarView.hidden = YES;
    
    CGFloat bgm_LeftMargin = 12;
    CGFloat bgm_TopMargin = 10;
    CGFloat bgm_MiddleMargin = 15;
    CGFloat bgm_button_H = 25;
    CGFloat bgm_button_W = 48;
    UIFont *bgm_button_Font = [UIFont systemFontOfSize:12];
    CGFloat bgm_label_H = 25;
    CGFloat bgm_label_W = 28;
    CGFloat bgm_slider_W = _width - (3 * bgm_LeftMargin) - bgm_label_W;
    // 选择bgm按钮
    self.bgmSelectButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.bgmSelectButton.frame = CGRectMake(bgm_LeftMargin, bgm_TopMargin, bgm_button_W, bgm_button_H);
    self.bgmSelectButton.titleLabel.font = bgm_button_Font;
    self.bgmSelectButton.layer.borderColor = RGB(10, 204, 172).CGColor;
    [self.bgmSelectButton.layer setMasksToBounds:YES];
    [self.bgmSelectButton.layer setCornerRadius:6];
    [self.bgmSelectButton.layer setBorderWidth:1.0];
    [self.bgmSelectButton setTitle:@"伴奏" forState:UIControlStateNormal];
    [self.bgmSelectButton setTitleColor:RGB(10, 204, 172) forState:UIControlStateNormal];
    [self.bgmSelectButton addTarget:self action:@selector(clickBGMSelect:) forControlEvents:UIControlEventTouchUpInside];
    [self.musicBarView addSubview:self.bgmSelectButton];
    // 关闭bgm按钮
    self.bgmStopButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.bgmStopButton.frame = CGRectMake(CGRectGetMaxX(self.bgmSelectButton.frame) + bgm_MiddleMargin, bgm_TopMargin, bgm_button_W, bgm_button_H);
    self.bgmStopButton.titleLabel.font = bgm_button_Font;
    self.bgmStopButton.layer.borderColor = RGB(10, 204, 172).CGColor;
    [self.bgmStopButton.layer setMasksToBounds:YES];
    [self.bgmStopButton.layer setCornerRadius:6];
    [self.bgmStopButton.layer setBorderWidth:1.0];
    [self.bgmStopButton setTitle:@"结束" forState:UIControlStateNormal];
    [self.bgmStopButton setTitleColor:RGB(10, 204, 172) forState:UIControlStateNormal];
    [self.bgmStopButton addTarget:self action:@selector(clickBGMClose:) forControlEvents:UIControlEventTouchUpInside];
    [self.musicBarView addSubview:self.bgmStopButton];
    
    // 背景音乐音量调整滑杆
    UILabel *bgmLabel = [[UILabel alloc] initWithFrame:CGRectMake(bgm_LeftMargin, CGRectGetMaxY(self.bgmSelectButton.frame) + bgm_TopMargin, bgm_label_W, bgm_label_H)];
    bgmLabel.font = bgm_button_Font;
    bgmLabel.textColor = RGB(10, 204, 172);
    bgmLabel.text = @"伴奏";
    [self.musicBarView addSubview:bgmLabel];
    
    self.sliderVolumeForBGM = [[UISlider alloc] initWithFrame:CGRectMake(CGRectGetMaxX(bgmLabel.frame) + bgm_MiddleMargin, CGRectGetMinY(bgmLabel.frame), bgm_slider_W, bgm_label_H)];
    [self.sliderVolumeForBGM setThumbImage:[UIImage imageNamed:@"slider_thumb"] forState:UIControlStateNormal];
    [self.sliderVolumeForBGM setMinimumTrackImage:[UIImage imageNamed:@"slider_green"] forState:UIControlStateNormal];
    [self.sliderVolumeForBGM setMaximumTrackImage:[UIImage imageNamed:@"slider_gray"] forState:UIControlStateNormal];
    [self.sliderVolumeForBGM addTarget:self action:@selector(sliderValueChange:) forControlEvents:UIControlEventValueChanged];
    self.sliderVolumeForBGM.minimumValue = 0;
    self.sliderVolumeForBGM.maximumValue = 200;
    self.sliderVolumeForBGM.value = 100;
    self.sliderVolumeForBGM.tag = 115;
    [self.musicBarView addSubview:self.sliderVolumeForBGM];
    
    // 人声音量调整滑杆
    UILabel *voiceLabel = [[UILabel alloc] initWithFrame:CGRectMake(bgm_LeftMargin, CGRectGetMaxY(bgmLabel.frame) + bgm_TopMargin, bgm_label_W, bgm_label_H)];
    voiceLabel.font = bgm_button_Font;
    voiceLabel.textColor = RGB(10, 204, 172);
    voiceLabel.text = @"人声";
    [self.musicBarView addSubview:voiceLabel];
    
    self.sliderVolumeForVoice = [[UISlider alloc] initWithFrame:CGRectMake(CGRectGetMaxX(voiceLabel.frame) + bgm_MiddleMargin, CGRectGetMinY(voiceLabel.frame), bgm_slider_W, bgm_label_H)];
    [self.sliderVolumeForVoice setThumbImage:[UIImage imageNamed:@"slider_thumb"] forState:UIControlStateNormal];
    [self.sliderVolumeForVoice setMinimumTrackImage:[UIImage imageNamed:@"slider_green"] forState:UIControlStateNormal];
    [self.sliderVolumeForVoice setMaximumTrackImage:[UIImage imageNamed:@"slider_gray"] forState:UIControlStateNormal];
    [self.sliderVolumeForVoice addTarget:self action:@selector(sliderValueChange:) forControlEvents:UIControlEventValueChanged];
    self.sliderVolumeForVoice.minimumValue = 0;
    self.sliderVolumeForVoice.maximumValue = 200;
    self.sliderVolumeForVoice.value = 100;
    self.sliderVolumeForVoice.tag = 116;
    [self.musicBarView addSubview:self.sliderVolumeForVoice];
    
    
    // 加在self上的控件: 1.关闭按钮 2.主播信息
    // 1. 关闭按钮
    self.closeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.closeButton.frame = CGRectMake(_width - button_middleMargin - button_W, button_Y, button_W, button_W);
    [self.closeButton setImage:[UIImage imageNamed:@"push_close"] forState:UIControlStateNormal];
    [self.closeButton setImage:[UIImage imageNamed:@"push_close_highlighted"] forState:UIControlStateHighlighted];
    [self.closeButton addTarget:self action:@selector(closePush) forControlEvents:UIControlEventTouchUpInside];
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
    CGFloat intput_H = 32;
    CGFloat intput_margin = 10; 
    CGFloat intput_textField_X = intput_margin;
    CGFloat intput_textField_W = WIDTH - (2 * intput_margin);
    self.chatInputView = [[UIView alloc] initWithFrame:CGRectMake(0, _height, _width, ChatInputViewHeight)];
    self.chatInputView.backgroundColor = RGB(241, 241, 244);
    [self addSubview:self.chatInputView];
    // 3.1 输入框
    self.chatInputTextField = [[UITextField alloc] initWithFrame:CGRectMake(intput_textField_X, (ChatInputViewHeight - intput_H) / 2, intput_textField_W, intput_H)];
    self.chatInputTextField.backgroundColor = RGB(233, 233, 233);
    self.chatInputTextField.layer.borderWidth = 1;
    self.chatInputTextField.layer.borderColor = RGB(244, 85, 133).CGColor;
    self.chatInputTextField.layer.masksToBounds = YES;
    self.chatInputTextField.layer.cornerRadius = intput_H / 2;
    self.chatInputTextField.delegate = self;
    self.chatInputTextField.returnKeyType = UIReturnKeySend;
    self.chatInputTextField.font = [UIFont systemFontOfSize:15];
    NSAttributedString *placeholderAttriStr = [[NSAttributedString alloc] initWithString:@"  说点什么吧" attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:15], NSForegroundColorAttributeName : RGB(180, 180, 180)}];
    self.chatInputTextField.attributedPlaceholder = placeholderAttriStr;
    [self.chatInputView addSubview:self.chatInputTextField];
    
    
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
}


#pragma mark - Events

// MARK: BWPushDecorateDelegate

// 结束直播
- (void)closePush {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:TipMsgStopPush preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
    [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        if ([self.delegate respondsToSelector:@selector(closeRTMP)]) {
            [self.delegate closeRTMP];
            
            if ([self.delegate respondsToSelector:@selector(closePushViewController)]) {
                [self.delegate closePushViewController];
            }
        }
    }]];
    [self.parentViewController presentViewController:alert animated:YES completion:nil];
}

// 开始聊天
- (void)clickChat:(UIButton *)button {
    [self.chatInputTextField becomeFirstResponder];
}

// 打开或关闭照明灯
- (void)clickTorch:(UIButton *)button {
    if ([self.delegate respondsToSelector:@selector(clickTorch:)]) {
        [self.delegate clickTorch:button];
    }
}

// 切换前后摄像头
- (void)clickCameraSwitch:(UIButton *)button {
    if ([self.delegate respondsToSelector:@selector(clickCameraSwitch:)]) {
        [self.delegate clickCameraSwitch:button];
    }
}

// 显示美颜效果设置界面
- (void)clickBeauty:(UIButton *)button {
    if ([self.delegate respondsToSelector:@selector(clickBeauty:)]) {
        [self.delegate clickBeauty:button];
        
        [self showToolBarView];
    }
}

// 开启音效
- (void)clickMusic:(UIButton *)button {
    [self showMusicBarView];
}

// 选择工具种类
- (void)selectTool:(UIButton *)button {
    _selectedToolButton.selected = NO;
    button.selected = YES;
    _selectedToolButton = button;
    
    if (button.tag == 101) { // 美颜
        [self.toolScrollView setContentOffset:CGPointMake(0, 0)];
    } else if (button.tag == 102) { // 滤镜
        [self.toolScrollView setContentOffset:CGPointMake(_width, 0)];
    } else if (button.tag == 103) { // 动效
        [self.toolScrollView setContentOffset:CGPointMake(_width * 2, 0)];
    }
}

// 美颜工具滑杆事件
- (void)sliderValueChange:(UISlider *)sender {
    if ([self.delegate respondsToSelector:@selector(sliderValueChange:)]) {
        [self.delegate sliderValueChange:sender];
    }
}

// 选择背景音乐
- (void)clickBGMSelect:(UIButton *)button {
    if ([self.delegate respondsToSelector:@selector(selectBGM:)]) {
        [self.delegate selectBGM:button];
    }
}

// 关闭背景音乐
- (void)clickBGMClose:(UIButton *)button {
    if ([self.delegate respondsToSelector:@selector(closeBGM:)]) {
        [self.delegate closeBGM:button];
    }
}

// MARK: UIGestureRecognizer Event

// 点击屏幕以手动聚焦
- (void)clickScreen:(UITapGestureRecognizer *)gestureRecognizer {
    if ([self.delegate respondsToSelector:@selector(clickScreen:)]) {
        [self.delegate clickScreen:gestureRecognizer];
    }
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

// 显示工具view
- (void)showToolBarView {
    self.toolBarAboveView.hidden = NO;
    self.toolBarView.hidden = NO;
    self.closeButton.hidden = YES;
    
    // 移除self的平移手势和点击手势
    [self removeGestureRecognizer:self.panForMove];
    [self removeGestureRecognizer:self.tapForFocus];
    
    [UIView animateWithDuration:0.25 animations:^{
        CGRect frame = self.toolBarView.frame;
        frame.origin.y = HEIGHT - TOOLBARVIEW_H;
        self.toolBarView.frame = frame;
        
    } completion:^(BOOL finished) {
    }];
}

// 隐藏工具view
- (void)hiddenToolBarView {
    self.toolBarAboveView.hidden = YES;
    
    // 添加self的平移手势和点击手势
    [self addGestureRecognizer:self.panForMove];
    [self addGestureRecognizer:self.tapForFocus];
    
    [UIView animateWithDuration:0.25 animations:^{
        CGRect frame = self.toolBarView.frame;
        frame.origin.y = HEIGHT;
        self.toolBarView.frame = frame;
        
    } completion:^(BOOL finished) {
        self.toolBarView.hidden = YES;
        self.closeButton.hidden = NO;
    }];
}

// 显示音效view
- (void)showMusicBarView {
    self.musicBarAboveView.hidden = NO;
    self.musicBarView.hidden = NO;
    self.closeButton.hidden = YES;
    
    // 移除self的平移手势和点击手势
    [self removeGestureRecognizer:self.panForMove];
    [self removeGestureRecognizer:self.tapForFocus];
    
    [UIView animateWithDuration:0.25 animations:^{
        CGRect frame = self.musicBarView.frame;
        frame.origin.y = HEIGHT - MUSICBARVIEW_H;
        self.musicBarView.frame = frame;
        
    } completion:^(BOOL finished) {
    }];
}

// 隐藏音效view
- (void)hiddenMusicBarView {
    self.musicBarAboveView.hidden = YES;
    
    // 添加self的平移手势和点击手势
    [self addGestureRecognizer:self.panForMove];
    [self addGestureRecognizer:self.tapForFocus];
    
    [UIView animateWithDuration:0.25 animations:^{
        CGRect frame = self.musicBarView.frame;
        frame.origin.y = HEIGHT;
        self.musicBarView.frame = frame;
        
    } completion:^(BOOL finished) {
        self.musicBarView.hidden = YES;
        self.closeButton.hidden = NO;
    }];
}


#pragma mark - UICollectionViewDataSource

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


#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if (collectionView.tag == 200) {
        return self.filterArr.count;
    } else if (collectionView.tag == 203) {
        return self.audioEffectArr.count;
    } else if (collectionView.tag == 204) {
        return self.audienceArr.count;
    }
    
    return self.filterArr.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (collectionView.tag == 200) {
        FilterCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:FilterCellID forIndexPath:indexPath];
        cell.filter = self.filterArr[indexPath.row];
        return cell;
    } else if (collectionView.tag == 203) {
        AudioEffectCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:AudioEffectCellID forIndexPath:indexPath];
        cell.audioEffect = self.audioEffectArr[indexPath.row];
        return cell;
    } else if (collectionView.tag == 204) {
        AudienceCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:AudienceCellID forIndexPath:indexPath];
        return cell;
    }
    
    FilterCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:FilterCellID forIndexPath:indexPath];
    cell.filter = self.filterArr[indexPath.row];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (collectionView.tag == 200) { // 滤镜选择
        [self.filterArr enumerateObjectsUsingBlock:^(FilterModel *filter, NSUInteger idx, BOOL * _Nonnull stop) {
            if (indexPath.row == idx) {
                filter.selected = YES;
            } else {
                filter.selected = NO;
            }
        }];
        [collectionView reloadData];
        
        // 滤镜类型
        BWLiveFilterType filterType = FilterType_none;
        // 滤镜文件名称
        NSString *filterFileName = @"";
        
        switch (indexPath.row) {
            case 0:
                filterType = FilterType_none;
                filterFileName = @"";
                break;
            case 1:
                filterType = FilterType_white;
                filterFileName = @"filter_white";
                break;
            case 2:
                filterType = FilterType_langman;
                filterFileName = @"filter_langman";
                break;
            case 3:
                filterType = FilterType_qingxin;
                filterFileName = @"filter_qingxin";
                break;
            case 4:
                filterType = FilterType_weimei;
                filterFileName = @"filter_weimei";
                break;
            case 5:
                filterType = FilterType_fennen;
                filterFileName = @"filter_fennen";
                break;
            case 6:
                filterType = FilterType_huaijiu;
                filterFileName = @"filter_huaijiu";
                break;
            case 7:
                filterType = FilterType_landiao;
                filterFileName = @"filter_landiao";
                break;
            case 8:
                filterType = FilterType_qingliang;
                filterFileName = @"filter_qingliang";
                break;
            case 9:
                filterType = FilterType_rixi;
                filterFileName = @"filter_rixi";
                break;
            default:
                filterType = FilterType_none;
                filterFileName = @"";
                break;
        }
        if ([self.delegate respondsToSelector:@selector(selectedFilter:fileName:)]) {
            [self.delegate selectedFilter:filterType fileName:filterFileName];
        }
        
    } else if (collectionView.tag == 203) {
        [self.audioEffectArr enumerateObjectsUsingBlock:^(AudioEffectModel *effect, NSUInteger idx, BOOL * _Nonnull stop) {
            if (indexPath.row == idx) {
                effect.selected = YES;
            } else {
                effect.selected = NO;
            }
        }];
        [collectionView reloadData];
        
        // 音效类型
        TXReverbType effectType = REVERB_TYPE_0;
        switch (indexPath.row) {
            case 0:
                effectType = REVERB_TYPE_0; // 关闭混响
                break;
            case 1:
                effectType = REVERB_TYPE_1; // KTV
                break;
            case 2:
                effectType = REVERB_TYPE_2; // 小房间
                break;
            case 3:
                effectType = REVERB_TYPE_3; // 大会堂
                break;
            case 4:
                effectType = REVERB_TYPE_4; // 低沉
                break;
            case 5:
                effectType = REVERB_TYPE_5; // 洪亮
                break;
            case 6:
                effectType = REVERB_TYPE_6; // 金属声
                break;
            case 7:
                effectType = REVERB_TYPE_7; // 磁性
                break;
            default:
                effectType = REVERB_TYPE_0;
                break;
        }
        if ([self.delegate respondsToSelector:@selector(selectAudioEffect:)]) {
            [self.delegate selectAudioEffect:effectType];
        }
        
    } else if (collectionView.tag == 204) {
        
    }
    
    [self.filterArr enumerateObjectsUsingBlock:^(FilterModel *filter, NSUInteger idx, BOOL * _Nonnull stop) {
        if (indexPath.row == idx) {
            filter.selected = YES;
        } else {
            filter.selected = NO;
        }
    }];
    [collectionView reloadData];
}


#pragma mark - UIScrollViewDelegate

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    if (scrollView == self.messageTableView) {
        [self endEditing:YES];
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
    [self.messageTableView scrollToRowAtIndexPath:footIndexPath atScrollPosition:UITableViewScrollPositionBottom animated:NO];
    
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
    } else {
        textFieldY = endKeyboardRect.origin.y - ChatInputViewHeight;
        Y = 0 - (endKeyboardRect.size.height + ChatInputViewHeight - BottomButtonWidth - 25); 
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


#pragma mark - Override Touches 相关方法

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [touches anyObject];
    _touchBeganPoint = [touch locationInView:self];
    
    [self endEditing:YES];
    
    NSLog(@"touches 开始: %@", NSStringFromCGPoint(_touchBeganPoint));
}

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [touches anyObject];
    _touchMovedPoint = [touch locationInView:self];
    
    NSLog(@"touches 移动: %@", NSStringFromCGPoint(_touchMovedPoint));
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [touches anyObject];
    CGPoint touchPoint = [touch locationInView:self];
    
    NSLog(@"touches 结束: %@", NSStringFromCGPoint(touchPoint));
}

- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event {
    return YES;
}


#pragma mark - Getters

- (UIView *)decorateView {
    if (!_decorateView) {
        _decorateView = [[UIView alloc] initWithFrame:self.bounds];
        _decorateView.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.1]; // 0.06
    }
    return _decorateView;
}

- (UIView *)toolBarAboveView {
    if (!_toolBarAboveView) {
        _toolBarAboveView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, _width, HEIGHT - TOOLBARVIEW_H)];
        
        UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hiddenToolBarView)];
        [_toolBarAboveView addGestureRecognizer:tapGestureRecognizer];
    }
    return _toolBarAboveView;
}

- (UIView *)toolBarView {
    if (!_toolBarView) {
        _toolBarView = [[UIView alloc] initWithFrame:CGRectMake(0, HEIGHT, _width, TOOLBARVIEW_H)];
        _toolBarView.backgroundColor = [UIColor whiteColor];
        
        [_toolBarView addSubview:self.toolScrollView];
        [_toolBarView addSubview:self.toolButtonScrollView];
    }
    return _toolBarView;
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
        _audienceCollectionView.tag = 204;
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

- (NSMutableArray *)messageArr {
    if (!_messageArr) {
        _messageArr = [NSMutableArray array];
    }
    return _messageArr;
}

- (UIScrollView *)toolScrollView {
    if (!_toolScrollView) {
        _toolScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, _width, TOOLSCROLLVIEW_H)];
        _toolScrollView.contentSize = CGSizeMake(_width * ToolButtonCount, TOOLSCROLLVIEW_H);
        _toolScrollView.scrollEnabled = NO;
    }
    return _toolScrollView;
}

- (UIScrollView *)toolButtonScrollView {
    if (!_toolButtonScrollView) {
        _toolButtonScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.toolScrollView.frame), _width, TOOLBUTTONSCROLLVIEW_H)];
        _toolButtonScrollView.contentSize = CGSizeMake(_width, TOOLBUTTONSCROLLVIEW_H);
    }
    return _toolButtonScrollView;
}

- (UICollectionView *)filterCollectionView {
    if (!_filterCollectionView) {
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        flowLayout.itemSize = CGSizeMake(FILTERCELLW, FILTERCELLH);
        flowLayout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
        flowLayout.minimumLineSpacing = 0;
        flowLayout.minimumInteritemSpacing = 0;
        
        _filterCollectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(_width, 0, _width, CGRectGetHeight(self.toolScrollView.frame)) collectionViewLayout:flowLayout];
        _filterCollectionView.backgroundColor = [UIColor whiteColor];
        _filterCollectionView.showsHorizontalScrollIndicator = NO;
        _filterCollectionView.dataSource = self;
        _filterCollectionView.delegate = self;
        _filterCollectionView.tag = 200;
        [_filterCollectionView registerClass:[FilterCell class] forCellWithReuseIdentifier:FilterCellID];
    }
    return _filterCollectionView;
}

- (NSMutableArray *)filterArr {
    if (!_filterArr) {
        _filterArr = [NSMutableArray array];
    }
    return _filterArr;
}

- (UIView *)musicBarAboveView {
    if (!_musicBarAboveView) {
        _musicBarAboveView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, _width, HEIGHT - MUSICBARVIEW_H)];
        
        UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hiddenMusicBarView)];
        [_musicBarAboveView addGestureRecognizer:tapGestureRecognizer];
    }
    return _musicBarAboveView;
}

- (UIView *)musicBarView {
    if (!_musicBarView) {
        _musicBarView = [[UIView alloc] initWithFrame:CGRectMake(0, HEIGHT, _width, MUSICBARVIEW_H)];
        _musicBarView.backgroundColor = [UIColor whiteColor];
        
        [_musicBarView addSubview:self.audioEffectCollectionView];
    }
    return _musicBarView;
}

- (UICollectionView *)audioEffectCollectionView {
    if (!_audioEffectCollectionView) {
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        flowLayout.itemSize = CGSizeMake(AUDIOEFFECTCELLW, AUDIOEFFECTCELLH);
        flowLayout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
        flowLayout.minimumLineSpacing = 0;
        flowLayout.minimumInteritemSpacing = 0;
        
        CGFloat y = MUSICBARVIEW_H * 0.68;
        CGFloat h = MUSICBARVIEW_H * 0.30; // 51
        _audioEffectCollectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, y, _width, h) collectionViewLayout:flowLayout];
        _audioEffectCollectionView.backgroundColor = [UIColor whiteColor];
        _audioEffectCollectionView.showsHorizontalScrollIndicator = NO;
        _audioEffectCollectionView.dataSource = self;
        _audioEffectCollectionView.delegate = self;
        _audioEffectCollectionView.tag = 203;
        [_audioEffectCollectionView registerClass:[AudioEffectCell class] forCellWithReuseIdentifier:AudioEffectCellID];
    }
    return _audioEffectCollectionView;
}

- (NSMutableArray *)audioEffectArr {
    if (!_audioEffectArr) {
        _audioEffectArr = [NSMutableArray array];
    }
    return _audioEffectArr;
}


/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
 */

@end
