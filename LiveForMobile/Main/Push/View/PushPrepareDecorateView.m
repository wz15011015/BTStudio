//
//  PushPrepareDecorateView.m
//  LiveForMobile
//
//  Created by  Sierra on 2017/07/04.
//  Copyright © 2017年 BaiFuTak. All rights reserved.
//

#import "PushPrepareDecorateView.h"
#import "BWMacro.h"
#import "FilterCell.h"
#import "FilterModel.h"

#define TOOLBARVIEW_H (170)
#define TOOLSCROLLVIEW_H (TOOLBARVIEW_H * 0.7)
#define TOOLBUTTONSCROLLVIEW_H (TOOLBARVIEW_H * 0.3)

@interface PushPrepareDecorateView () <UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UITextFieldDelegate> {
    CGFloat _width;
    CGFloat _height;
    
    UIButton *_selectedToolButton;
}

@property (nonatomic, strong) UIButton *closeButton;        // 关闭按钮
@property (nonatomic, strong) UIButton *cameraSwitchButton; // 前后摄像头切换按钮
@property (nonatomic, strong) UIButton *beautyButton;       // 美颜按钮
@property (nonatomic, strong) UITextField *titleTextField;  // 直播标题输入框
@property (nonatomic, strong) UIButton *pushButton;         // 开始直播按钮

// 美颜部分: 底部用来放置各个功能模块展开后的控件的工具view
@property (nonatomic, strong) UIView *toolBarView;
@property (nonatomic, strong) UIView *toolBarAboveView; // toolBarView之上的view，用来实现点击时隐藏toolBarView
@property (nonatomic, strong) UIScrollView *toolButtonScrollView; // 放置工具按钮
@property (nonatomic, strong) UIScrollView *toolScrollView; // 放置各个工具
@property (nonatomic, strong) UIButton *toolBeautyButton;   // 美颜工具按钮
@property (nonatomic, strong) UIButton *toolFilterButton;   // 滤镜工具按钮
// 美颜工具
@property (nonatomic, strong) UISlider *sliderBigEye;    // 大眼滑杆
@property (nonatomic, strong) UISlider *sliderSlimFace;  // 瘦脸滑杆
@property (nonatomic, strong) UISlider *sliderBeauty;    // 美颜滑杆
@property (nonatomic, strong) UISlider *sliderWhitening; // 美白滑杆
// 滤镜类型
@property (nonatomic, strong) UICollectionView *filterCollectionView;
@property (nonatomic, strong) NSMutableArray <FilterModel *>*filterArr;

@end

@implementation PushPrepareDecorateView

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
    self.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.2];
    
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
}

// 初始化子控件并添加
- (void)addSubViews {
    // 1. 功能按钮
    [self addSubview:self.closeButton];
    [self addSubview:self.cameraSwitchButton];
    [self addSubview:self.beautyButton];
    [self addSubview:self.titleTextField];
    [self addSubview:self.pushButton];
    
    // 2. 工具view
    [self addSubview:self.toolBarAboveView];
    [self addSubview:self.toolBarView];
    self.toolBarAboveView.hidden = YES;
 
    // 2.1 工具按钮
    CGFloat tool_button_W = _width / 2;
    CGFloat tool_button_H = CGRectGetHeight(self.toolButtonScrollView.frame);
    // 2.1.1 美颜按钮
    self.toolBeautyButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.toolBeautyButton.tag = 101;
    self.toolBeautyButton.frame = CGRectMake(0, 0, tool_button_W, tool_button_H);
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
    self.toolFilterButton.frame = CGRectMake(tool_button_W, 0, tool_button_W, tool_button_H);
    [self.toolFilterButton setImage:[UIImage imageNamed:@"beautiful"] forState:UIControlStateNormal];
    [self.toolFilterButton setImage:[UIImage imageNamed:@"beautiful_selected"] forState:UIControlStateSelected];
    [self.toolFilterButton setTitle:@"滤镜" forState:UIControlStateNormal];
    [self.toolFilterButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.toolFilterButton setTitleColor:RGB(10, 204, 172) forState:UIControlStateSelected];
    self.toolFilterButton.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, -5);
    [self.toolFilterButton addTarget:self action:@selector(selectTool:) forControlEvents:UIControlEventTouchUpInside];
    [self.toolButtonScrollView addSubview:self.toolFilterButton];
   
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
}


#pragma mark - Events

// MARK: PushPrepareDecorateViewDelegate

// 关闭直播设置页面
- (void)closeViewController {
    [self endEditing:YES];
    if ([self.delegate respondsToSelector:@selector(pushPrepareDecorateView:dismissViewController:)]) {
        [self.delegate pushPrepareDecorateView:self dismissViewController:self.parentViewController];
    }
}

// 切换前后摄像头
- (void)cameraSwitch:(UIButton *)sender {
    [self endEditing:YES];
    if ([self.delegate respondsToSelector:@selector(pushPrepareDecorateView:cameraSwitch:)]) {
        [self.delegate pushPrepareDecorateView:self cameraSwitch:sender];
    }
}

// 显示美颜工具
- (void)showBeautyTool:(UIButton *)sender {
    [self endEditing:YES];
    [self showToolBarView];
}

// 开始直播
- (void)startPush:(UIButton *)sender {
    NSString *title = self.titleTextField.text;
    if (title.length == 0) {
        title = @"XXX 开始直播了！";
    } else if (title.length > 17) {
        title = [title substringWithRange:NSMakeRange(0, 17)];
    }
    NSLog(@"直播标题为: %@", title);
    
    if ([self.delegate respondsToSelector:@selector(pushPrepareDecorateView:startPush:)]) {
        [self.delegate pushPrepareDecorateView:self startPush:title];
    }
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
    }
}

// 美颜工具滑杆事件
- (void)sliderValueChange:(UISlider *)sender {
    if ([self.delegate respondsToSelector:@selector(pushPrepareDecorateView:sliderValueChange:)]) {
        [self.delegate pushPrepareDecorateView:self sliderValueChange:sender];
    }
}

// 显示工具view
- (void)showToolBarView {
    self.toolBarAboveView.hidden = NO;
    
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
    
    [UIView animateWithDuration:0.25 animations:^{
        CGRect frame = self.toolBarView.frame;
        frame.origin.y = HEIGHT;
        self.toolBarView.frame = frame;
    } completion:^(BOOL finished) {
    }];
}


#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if (collectionView.tag == 200) {
        return self.filterArr.count;
    }
    return 0;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (collectionView.tag == 200) {
        FilterCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:FilterCellID forIndexPath:indexPath];
        cell.filter = self.filterArr[indexPath.row];
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
        if ([self.delegate respondsToSelector:@selector(pushPrepareDecorateView:selectedFilter:fileName:)]) {
            [self.delegate pushPrepareDecorateView:self selectedFilter:filterType fileName:filterFileName];
        }
    }
}


#pragma mark - UITextFieldDelegate

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if ([string isEqualToString:@""]) { // 删除键
        return YES;
    }
    if (textField.text.length >= 17) {
        return NO;
    }
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}


#pragma mark - Override Touches 相关方法

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self endEditing:YES];
}


#pragma mark - Getters

- (UIButton *)closeButton {
    if (!_closeButton) {
        CGFloat margin = 15;
        CGFloat w = 44;
        CGFloat x = _width - margin - w;
        _closeButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _closeButton.frame = CGRectMake(x, 28, w, w);
        [_closeButton setImage:[UIImage imageNamed:@"push_close"] forState:UIControlStateNormal];
        [_closeButton setImage:[UIImage imageNamed:@"push_close_highlighted"] forState:UIControlStateHighlighted];
        [_closeButton addTarget:self action:@selector(closeViewController) forControlEvents:UIControlEventTouchUpInside];
    }
    return _closeButton;
}

- (UIButton *)cameraSwitchButton {
    if (!_cameraSwitchButton) {
        CGFloat margin = 10;
        CGFloat w = CGRectGetWidth(self.closeButton.frame);
        CGFloat x = CGRectGetMinX(self.closeButton.frame) - margin - w;
        _cameraSwitchButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _cameraSwitchButton.frame = CGRectMake(x, CGRectGetMinY(self.closeButton.frame), w, w);
        [_cameraSwitchButton setImage:[UIImage imageNamed:@"push_camera_switch"] forState:UIControlStateNormal];
        [_cameraSwitchButton addTarget:self action:@selector(cameraSwitch:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _cameraSwitchButton;
}

- (UIButton *)beautyButton {
    if (!_beautyButton) {
        CGFloat margin = 10;
        CGFloat w = CGRectGetWidth(self.closeButton.frame);
        CGFloat x = CGRectGetMinX(self.closeButton.frame);
        CGFloat y = CGRectGetMaxY(self.closeButton.frame) + margin;
        _beautyButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _beautyButton.frame = CGRectMake(x, y, w, w);
        [_beautyButton setImage:[UIImage imageNamed:@"push_beauty"] forState:UIControlStateNormal];
        [_beautyButton addTarget:self action:@selector(showBeautyTool:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _beautyButton;
}

- (UITextField *)titleTextField {
    if (!_titleTextField) {
        CGFloat x = 20;
        CGFloat w = _width - (2 * x);
        _closeButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _titleTextField = [[UITextField alloc] initWithFrame:CGRectMake(x, 220, w, 44)];
        _titleTextField.textColor = [UIColor whiteColor];
        _titleTextField.tintColor = [UIColor whiteColor];
        _titleTextField.textAlignment = NSTextAlignmentCenter;
        _titleTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
        _titleTextField.returnKeyType = UIReturnKeyDone;
        _titleTextField.delegate = self;
        NSMutableAttributedString *attriPlaceholder = [[NSMutableAttributedString alloc] initWithString:@"有标题的直播才能吸引人哦！" attributes:@{NSForegroundColorAttributeName : [UIColor colorWithWhite:1 alpha:0.7]}];
        _titleTextField.attributedPlaceholder = attriPlaceholder;
    }
    return _titleTextField;
}

- (UIButton *)pushButton {
    if (!_pushButton) {
        CGFloat bottomMargin = 40;
        CGFloat x = 45;
        CGFloat w = _width - (2 * x);
        CGFloat h = 45;
        CGFloat y = _height - bottomMargin - h;
        _pushButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _pushButton.frame = CGRectMake(x, y, w, h);
        _pushButton.backgroundColor = RGB(254, 197, 52);
        _pushButton.layer.masksToBounds = YES;
        _pushButton.layer.cornerRadius = h / 2;
        [_pushButton setTitle:@"开始直播" forState:UIControlStateNormal];
        [_pushButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_pushButton setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
        [_pushButton addTarget:self action:@selector(startPush:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _pushButton;
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

- (UIScrollView *)toolScrollView {
    if (!_toolScrollView) {
        _toolScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, _width, TOOLSCROLLVIEW_H)];
        _toolScrollView.contentSize = CGSizeMake(_width * 2, TOOLSCROLLVIEW_H);
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


/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
 */

@end
