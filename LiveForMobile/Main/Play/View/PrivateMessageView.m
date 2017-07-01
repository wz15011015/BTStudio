//
//  PrivateMessageView.m
//  LiveForMobile
//
//  Created by  Sierra on 2017/6/27.
//  Copyright © 2017年 BaiFuTak. All rights reserved.
//

#import "PrivateMessageView.h"
#import "BWMacro.h"
#import "PrivateMessageCell.h"

#define CONTENTVIEW_H (240)
#define HEADERVIEW_H (44)

@interface PrivateMessageView () <UITableViewDelegate, UITableViewDataSource> {
    CGFloat _width;
    CGFloat _height;
}
@property (nonatomic, strong) UIView *blankView; // 空白view
@property (nonatomic, strong) UIView *contentView;
@property (nonatomic, strong) UIView *headerView;

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataArr;

@end

@implementation PrivateMessageView

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
}

// 添加子控件
- (void)addSubViews {
    [self addSubview:self.blankView];
    [self addSubview:self.contentView];
    [self.contentView addSubview:self.headerView];
    [self.contentView addSubview:self.tableView];
    
    // 动画效果
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.25];
    
    CGRect frame = self.contentView.frame;
    frame.origin.y = HEIGHT - frame.size.height;
    self.contentView.frame = frame;
    
    [UIView commitAnimations];
}

// 移除子控件
- (void)removeSubviews {
    [self.blankView removeFromSuperview];
    [self.contentView removeFromSuperview];
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
    [UIView animateWithDuration:0.25 animations:^{
        CGRect frame = self.contentView.frame;
        frame.origin.y = HEIGHT;
        self.contentView.frame = frame;
        
    } completion:^(BOOL finished) {
        if (finished) {
            [self removeSubviews];
            
            // 移除self
            [self removeFromSuperview];
        }
    }];
}


#pragma mark - Event



#pragma mark - UICollectionViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArr.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return PRIVATEMESSAGE_CELL_H;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    PrivateMessageCell *cell = [tableView dequeueReusableCellWithIdentifier:PrivateMessageCellID forIndexPath:indexPath];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
}


#pragma mark - Getters

- (UIView *)blankView {
    if (!_blankView) {
        CGFloat h = HEIGHT - CONTENTVIEW_H;
        _blankView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, _width, h)];
        _blankView.backgroundColor = [UIColor clearColor];
        
        // 添加点击手势
        UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismiss)];
        [_blankView addGestureRecognizer:tapGestureRecognizer];
    }
    return _blankView;
}

- (UIView *)contentView {
    if (!_contentView) {
        _contentView = [[UIView alloc] initWithFrame:CGRectMake(0, HEIGHT, _width, CONTENTVIEW_H)];
        _contentView.backgroundColor = [UIColor colorWithWhite:1.0 alpha:1.0];
    }
    return _contentView;
}

- (UIView *)headerView {
    if (!_headerView) {
        _headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, _width, HEADERVIEW_H)];
        _headerView.backgroundColor = [UIColor whiteColor];
        
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(12, 0, 36, HEADERVIEW_H)];
        titleLabel.font = [UIFont systemFontOfSize:17];
        titleLabel.textColor = RGB(36, 36, 36);
        titleLabel.text = @"消息";
        [_headerView addSubview:titleLabel];
        
        UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, HEADERVIEW_H - 1, _width, 1)];
        lineView.backgroundColor = RGB(230, 230, 230);
        [_headerView addSubview:lineView];
    }
    return _headerView;
}

- (UITableView *)tableView {
    if (!_tableView) {
        CGFloat h = CONTENTVIEW_H - HEADERVIEW_H;
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, HEADERVIEW_H, _width, h)];
        _tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        [_tableView registerClass:[PrivateMessageCell class] forCellReuseIdentifier:PrivateMessageCellID];
    }
    return _tableView;
}

- (NSMutableArray *)dataArr {
    if (!_dataArr) {
        _dataArr = [NSMutableArray array];
        
        [_dataArr addObject:@""];
        [_dataArr addObject:@""];
    }
    return _dataArr;
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
