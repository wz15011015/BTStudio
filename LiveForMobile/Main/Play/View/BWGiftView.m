//
//  BWGiftView.m
//  LiveForMobile
//
//  Created by  Sierra on 2017/6/28.
//  Copyright © 2017年 BaiFuTak. All rights reserved.
//

#import "BWGiftView.h"
#import "BWMacro.h"
#import "GiftCell.h"
#import "GiftModel.h"

#define CONTENTVIEW_H (216)
#define COLLECTIONVIEW_H (164)

const NSUInteger CountOfGiftPerPage = 10; // 每页礼物的个数

@interface BWGiftView () <UICollectionViewDelegateFlowLayout, UICollectionViewDelegate, UICollectionViewDataSource> {
    CGFloat _width;
    CGFloat _height;
}
@property (nonatomic, strong) UIView *blankView; // 空白view
@property (nonatomic, strong) UIView *contentView;

@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) UIPageControl *pageControl;
@property (nonatomic, strong) NSMutableArray *dataArr;

@property (nonatomic, strong) UIButton *sendButton;

@property (nonatomic, assign) NSUInteger pageCountOfGift; // 礼物的页数

@property (nonatomic, strong) GiftModel *selectedGift;

@end

@implementation BWGiftView

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
    
    GiftModel *model0 = [[GiftModel alloc] init];
    model0.giftId = @"0";
    model0.giftName = @"布加迪";
    model0.giftImageName = @"bugatti";
    model0.giftImageCount = 68;
    model0.giftDuration = 2.27;
    
    GiftModel *model1 = [[GiftModel alloc] init];
    model1.giftId = @"1";
    model1.giftName = @"巧克力";
    model1.giftImageName = @"ChocoFall";
    model1.giftImageCount = 33;
    model1.giftDuration = 1.07;
    
    GiftModel *model2 = [[GiftModel alloc] init];
    model2.giftId = @"2";
    model2.giftName = @"花";
    model2.giftImageName = @"gift_animation_31";
    model2.giftImageCount = 22;
    model2.giftDuration = 1.07;
    
    GiftModel *model3 = [[GiftModel alloc] init];
    model3.giftId = @"3";
    model3.giftName = @"爱心";
    model3.giftImageName = @"LoveFalling";
    model3.giftImageCount = 16;
    model3.giftDuration = 1.5;
    
    [self.dataArr addObject:model0];
    [self.dataArr addObject:model0];
    [self.dataArr addObject:model0];
    [self.dataArr addObject:model0];
    [self.dataArr addObject:model1];
    [self.dataArr addObject:model1];
    [self.dataArr addObject:model1];
    [self.dataArr addObject:model1];
    [self.dataArr addObject:model1];
    [self.dataArr addObject:model2];
    [self.dataArr addObject:model2];
    [self.dataArr addObject:model2];
    [self.dataArr addObject:model2];
    [self.dataArr addObject:model3];
    [self.dataArr addObject:model3];
    [self.dataArr addObject:model3];
    [self.dataArr addObject:model3];
    [self.dataArr addObject:model3];
    [self.dataArr addObject:model3];
    
    self.pageControl.numberOfPages = self.pageCountOfGift;
}

// 添加子控件
- (void)addSubViews {
    [self addSubview:self.blankView];
    [self addSubview:self.contentView];
    [self.contentView addSubview:self.collectionView];
    [self.contentView addSubview:self.pageControl];
    [self.contentView addSubview:self.sendButton];
    
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

- (void)pageControlEvent:(UIPageControl *)sender {
    NSInteger currentPage = sender.currentPage;
    [self.collectionView setContentOffset:CGPointMake(currentPage * WIDTH, 0) animated:YES];
}

- (void)sendGiftEvent:(UIButton *)sender {
    [self dismiss];
    
    if ([self.delegate respondsToSelector:@selector(giftView:sendGift:)]) {
        [self.delegate giftView:self sendGift:self.selectedGift];
    }
}


#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.pageCountOfGift;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    GiftCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:GiftCellID forIndexPath:indexPath];
    
    NSMutableArray *dataArr = [NSMutableArray array];
    NSUInteger count = self.dataArr.count;
    if (self.pageCountOfGift == 1) { // 只有一页
        dataArr = [NSMutableArray arrayWithArray:self.dataArr];
    } else { // 多页
        if (indexPath.row == self.pageCountOfGift - 1) { // 最后一页
            NSInteger remainder = count % CountOfGiftPerPage;
            if (remainder == 0) { // 余数等于0，说明最后一页刚好10个
                dataArr = [NSMutableArray arrayWithArray:[self.dataArr subarrayWithRange:NSMakeRange(indexPath.row * CountOfGiftPerPage, CountOfGiftPerPage)]];
            } else { // 余数不等于0，说明最后一页不够10个
                dataArr = [NSMutableArray arrayWithArray:[self.dataArr subarrayWithRange:NSMakeRange(indexPath.row * CountOfGiftPerPage, remainder)]];
            }
        } else { // 中间页
            dataArr = [NSMutableArray arrayWithArray:[self.dataArr subarrayWithRange:NSMakeRange(indexPath.row * CountOfGiftPerPage, CountOfGiftPerPage)]];
        }
    }
    cell.dataArr = dataArr;
    
    // Block回调
    cell.selectGiftBlock = ^(GiftModel *cellModel) {
        self.sendButton.enabled = YES;
        self.selectedGift = cellModel;
    };
    return cell;
}


#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    CGFloat offsetX = scrollView.contentOffset.x;
    NSInteger page = offsetX / WIDTH;
    self.pageControl.currentPage = page;
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
        _contentView.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.85];
    }
    return _contentView;
}

- (UICollectionView *)collectionView {
    if (!_collectionView) {
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        flowLayout.itemSize = CGSizeMake(GIFT_CELL_W, GIFT_CELL_H);
        flowLayout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
        flowLayout.minimumLineSpacing = 0;
        flowLayout.minimumInteritemSpacing = 0;
        
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, _width, COLLECTIONVIEW_H) collectionViewLayout:flowLayout];
        _collectionView.backgroundColor = [UIColor clearColor];
        _collectionView.showsHorizontalScrollIndicator = NO;
        _collectionView.dataSource = self;
        _collectionView.delegate = self;
        _collectionView.pagingEnabled = YES;
        [_collectionView registerClass:[GiftCell class] forCellWithReuseIdentifier:GiftCellID];
    }
    return _collectionView;
}

- (UIPageControl *)pageControl {
    if (!_pageControl) {
        _pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(0, COLLECTIONVIEW_H, _width, 20)];
        _pageControl.currentPageIndicatorTintColor = [UIColor whiteColor];
        _pageControl.pageIndicatorTintColor = RGB(82, 78, 77);
        _pageControl.hidesForSinglePage = YES;
        [_pageControl addTarget:self action:@selector(pageControlEvent:) forControlEvents:UIControlEventValueChanged];
    }
    return _pageControl;
}

- (NSMutableArray *)dataArr {
    if (!_dataArr) {
        _dataArr = [NSMutableArray array];
    }
    return _dataArr;
}

- (UIButton *)sendButton {
    if (!_sendButton) {
        CGFloat w = 78;
        CGFloat h = 42;
        CGFloat x = _width - w;
        CGFloat y = CONTENTVIEW_H - h;
        _sendButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _sendButton.frame = CGRectMake(x, y, w, h);
        _sendButton.backgroundColor = RGB(245, 29, 93);
        _sendButton.titleLabel.font = [UIFont systemFontOfSize:15];
        [_sendButton setTitle:@"发送" forState:UIControlStateNormal];
        [_sendButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_sendButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
        [_sendButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateDisabled];
        [_sendButton addTarget:self action:@selector(sendGiftEvent:) forControlEvents:UIControlEventTouchUpInside];
        
        _sendButton.enabled = NO;
    }
    return _sendButton;
}

- (NSUInteger)pageCountOfGift {
    NSUInteger count = self.dataArr.count;
    NSInteger pageCount = (count % CountOfGiftPerPage) == 0 ? (count / CountOfGiftPerPage) : (count / CountOfGiftPerPage + 1);
    return pageCount;
}


/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
 */

@end
