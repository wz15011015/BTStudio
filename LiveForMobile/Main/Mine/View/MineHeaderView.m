//
//  MineHeaderView.m
//  LiveForMobile
//
//  Created by  Sierra on 2017/8/7.
//  Copyright © 2017年 BaiFuTak. All rights reserved.
//

#import "MineHeaderView.h"
#import "BWMacro.h"

@interface MineHeaderView ()

@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UILabel *IDLabel;
@property (nonatomic, strong) UILabel *infoLabel;
@property (nonatomic, strong) UIImageView *arrowImageView;
@property (nonatomic, strong) UIImageView *avatarImageView;
@property (nonatomic, weak) ItemButton *stateButton;
@property (nonatomic, weak) ItemButton *followButton;
@property (nonatomic, weak) ItemButton *fansButton;

@end

@implementation MineHeaderView

#pragma mark - Life Cycle

- (instancetype)init {
    if (self = [super init]) {
        [self initParameters];
        [self initSubViews];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self initParameters];
        [self initSubViews];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        [self initParameters];
        [self initSubViews];
    }
    return self;
}


#pragma mark - Methods

- (void)initParameters {
    self.backgroundColor = [UIColor whiteColor];
}

- (void)initSubViews {
    CGFloat leftMargin = 15 * WIDTH_SCALE;
    CGFloat rightMargin = 15 * WIDTH_SCALE;
    
    self.nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(leftMargin, 18 * HEIGHT_SCALE, WIDTH / 2, 27 * HEIGHT_SCALE)];
    self.nameLabel.textColor = RGB(70, 70, 70);
    self.nameLabel.font = [UIFont boldSystemFontOfSize:22];
    [self addSubview:self.nameLabel];
    
    self.IDLabel = [[UILabel alloc] initWithFrame:CGRectMake(leftMargin, CGRectGetMaxY(self.nameLabel.frame) + (16 * HEIGHT_SCALE), WIDTH / 2, 16 * HEIGHT_SCALE)];
    self.IDLabel.textColor = RGB(70, 70, 70);
    self.IDLabel.font = [UIFont systemFontOfSize:13];
    [self addSubview:self.IDLabel];
    
    self.infoLabel = [[UILabel alloc] initWithFrame:CGRectMake(leftMargin, CGRectGetMaxY(self.IDLabel.frame) + (16 * HEIGHT_SCALE), WIDTH / 2, 18 * HEIGHT_SCALE)];
    self.infoLabel.textColor = RGB(209, 209, 209);
    self.infoLabel.font = [UIFont systemFontOfSize:15];
    self.infoLabel.text = @"查看我的主页";
    [self addSubview:self.infoLabel];
    
    UIImageView *separator = [[UIImageView alloc] initWithFrame:CGRectMake(leftMargin, CGRectGetMaxY(self.infoLabel.frame) + (20 * HEIGHT_SCALE), WIDTH - (2 * leftMargin), 1)];
    separator.backgroundColor = RGB(241, 241, 241);
    [self addSubview:separator];
    
    CGFloat arrowW = 8 * WIDTH_SCALE;
    CGFloat arrowH = 15 * HEIGHT_SCALE;
    CGFloat arrowX = WIDTH - rightMargin - arrowW;
    CGFloat arrowY = (CGRectGetMinY(separator.frame) - arrowH) / 2;
    UIImageView *arrowImageView = [[UIImageView alloc] initWithFrame:CGRectMake(arrowX, arrowY, arrowW, arrowH)];
    arrowImageView.image = [UIImage imageNamed:@"arrow_6x11_"];
    [self addSubview:arrowImageView];
    
    CGFloat iconW = 88 * WIDTH_SCALE;
    CGFloat iconX = CGRectGetMinX(arrowImageView.frame) - (12 * WIDTH_SCALE) - iconW;
    CGFloat iconY = (CGRectGetMinY(separator.frame) - iconW) / 2;
    self.avatarImageView = [[UIImageView alloc] initWithFrame:CGRectMake(iconX, iconY, iconW, iconW)];
    self.avatarImageView.layer.cornerRadius = iconW / 2;
    self.avatarImageView.layer.masksToBounds = YES;
    self.avatarImageView.userInteractionEnabled = YES;
    [self addSubview:self.avatarImageView];
    
    // 给头像添加点击手势
    UITapGestureRecognizer *tapGR = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGestureRecognizerEvent:)];
    [self.avatarImageView addGestureRecognizer:tapGR];
    
    // 调整名称label的宽度
    CGRect frame = self.nameLabel.frame;
    frame.size.width = CGRectGetMinX(self.avatarImageView.frame) - (8 * WIDTH_SCALE) - leftMargin;
    self.nameLabel.frame = frame;
    
    // 查看我的主页 按钮
    UIButton *infoButton = [UIButton buttonWithType:UIButtonTypeCustom];
    infoButton.frame = CGRectMake(0, 0, CGRectGetWidth(self.nameLabel.frame), CGRectGetMinY(separator.frame));
    [infoButton addTarget:self action:@selector(checkInfoEvent) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:infoButton];
    
    // 3个按钮
    NSArray *titles = @[@"动态", @"关注", @"粉丝"];
    CGFloat buttonW = WIDTH / 3;
    CGFloat buttonY = CGRectGetMaxY(separator.frame);
    CGFloat buttonH = MINE_HEADER_VIEW_H - buttonY;
    for (int i = 0; i < titles.count; i++) {
        ItemButton *button = [[ItemButton alloc] initWithFrame:CGRectMake(i * buttonW, buttonY, buttonW, buttonH) title:titles[i] value:@"0"];
        button.tag = 12 + i;
        [button addTarget:self action:@selector(buttonEvent:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:button];
        if (!i) {
            self.stateButton = button;
        } else if (1 == i) {
            self.followButton = button;
        } else if (2 == i) {
            self.fansButton = button;
        }
    }
    
    
    self.nameLabel.text = @"统一阿萨姆_奶茶";
    self.IDLabel.text = [NSString stringWithFormat:@"直播号: %@", @"125320177"];
    self.avatarImageView.image = [UIImage imageNamed:@"avatar_default"];
    
    self.stateButton.value = @"12";
    self.followButton.value = @"30";
    self.fansButton.value = @"8";
}


#pragma mark - Event

// 查看我的主页
- (void)checkInfoEvent {
    if (self.buttonEventBlock) {
        self.buttonEventBlock(10);
    }
}

// 点击了头像
- (void)tapGestureRecognizerEvent:(UITapGestureRecognizer *)gestureRecognizer {
    if (self.buttonEventBlock) {
        self.buttonEventBlock(11);
    }
}

- (void)buttonEvent:(UIButton *)sender {
    if (self.buttonEventBlock) {
        self.buttonEventBlock(sender.tag);
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




@interface ItemButton ()

@property (nonatomic, strong) UILabel *valueLabel;
@property (nonatomic, strong) UILabel *itemTitleLabel;

@end

@implementation ItemButton

- (instancetype)initWithFrame:(CGRect)frame title:(NSString *)title value:(NSString *)value {
    if (self = [super initWithFrame:frame]) {
        // 添加子控件
        self.valueLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, frame.size.height * 0.2, frame.size.width, 17)];
        self.valueLabel.font = [UIFont boldSystemFontOfSize:15];
        self.valueLabel.textColor = RGB(101, 101, 101);
        self.valueLabel.textAlignment = NSTextAlignmentCenter;
        self.valueLabel.text = value;
        [self addSubview:self.valueLabel];
        
        self.itemTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, frame.size.height * 0.55, frame.size.width, 17)];
        self.itemTitleLabel.font = [UIFont systemFontOfSize:13];
        self.itemTitleLabel.textColor = RGB(209, 209, 209);
        self.itemTitleLabel.textAlignment = NSTextAlignmentCenter;
        self.itemTitleLabel.text = title;
        [self addSubview:self.itemTitleLabel];
    }
    return self;
}


#pragma mark - Setters

- (void)setValue:(NSString *)value {
    _value = value;
    
    self.valueLabel.text = [NSString stringWithFormat:@"%@", value];
}

@end
