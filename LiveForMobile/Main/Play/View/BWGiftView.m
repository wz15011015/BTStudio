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

#define CONTENTVIEW_H    (270 * HEIGHT_SCALE)
#define CATEGORY_VIEW_H  (40 * HEIGHT_SCALE)
#define COLLECTIONVIEW_H (172 * HEIGHT_SCALE)
#define PAGECONTROL_H    (13 * HEIGHT_SCALE)
#define SEND_BUTTON_H    (45 * HEIGHT_SCALE)

const NSUInteger CountOfGiftPerPage = 10; // 每页礼物的个数

@interface BWGiftView () <UICollectionViewDelegateFlowLayout, UICollectionViewDelegate, UICollectionViewDataSource> {
    CGFloat _width;
    CGFloat _height;
    UIButton *_selectedCategoryButton; // 选中的分类按钮
    GiftModel *_selectedGift; // 选中的礼物model
}
@property (nonatomic, strong) UIView *blankView; // 空白view
@property (nonatomic, strong) UIView *contentView;

@property (nonatomic, strong) UIScrollView *categoryScrollView; // 礼物分类scrollView
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) UIPageControl *pageControl;
@property (nonatomic, strong) UIButton *coinButton; // 金币数量按钮
@property (nonatomic, strong) UIButton *sendButton; // 发送礼物按钮

@property (nonatomic, strong) NSMutableArray *categories;
@property (nonatomic, strong) NSMutableArray *dataArr;
@property (nonatomic, strong) NSMutableArray *dataArr2;
@property (nonatomic, strong) NSMutableArray *dataArr3;
@property (nonatomic, strong) NSMutableArray *dataArr4;

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
    
    [self.categories addObjectsFromArray:@[@"热门", @"节日", @"本地", @"奢华"]];
    
    GiftModel *model0 = [[GiftModel alloc] init];
    model0.giftId = @"0";
    model0.giftName = @"金话筒";
    model0.giftImageName = @"gift_goldenMicrophone_icon";
    model0.giftImageCount = 1;
    model0.giftDuration = 0;
    model0.giftPrice = @"1";
    
    GiftModel *model1 = [[GiftModel alloc] init];
    model1.giftId = @"41";
    model1.giftName = @"布加迪跑车";
    model1.giftImageName = @"gift_bujiadi_icon";
    model1.giftImageCount = 68;
    model1.giftDuration = 2.27;
    model1.giftPrice = @"666";
    
    GiftModel *model2 = [[GiftModel alloc] init];
    model2.giftId = @"42";
    model2.giftName = @"巧克力雨";
    model2.giftImageName = @"gift_chocolate_icon";
    model2.giftImageCount = 33;
    model2.giftDuration = 1.07;
    model2.giftPrice = @"8";
    
    GiftModel *model3 = [[GiftModel alloc] init];
    model3.giftId = @"43";
    model3.giftName = @"花";
    model3.giftImageName = @"gift_flower_icon";
    model3.giftImageCount = 22;
    model3.giftDuration = 1.07;
    model3.giftPrice = @"369";
    
    GiftModel *model4 = [[GiftModel alloc] init];
    model4.giftId = @"44";
    model4.giftName = @"爱心雨";
    model4.giftImageName = @"gift_loveFalling_icon";
    model4.giftImageCount = 16;
    model4.giftDuration = 1.5;
    model4.giftPrice = @"1314";
    
    GiftModel *model5 = [[GiftModel alloc] init];
    model5.giftId = @"45";
    model5.giftName = @"流星钻石";
    model5.giftImageName = @"gift_meteor_icon";
    model5.giftImageCount = 45;
    model5.giftDuration = 2.9;
    model5.giftPrice = @"10000";
    
    // 小礼物
    GiftModel *model6 = [[GiftModel alloc] init];
    model6.giftId = @"44";
    model6.giftName = @"浪漫告白";
    model6.giftImageName = @"gift_langmangaobai";
    model6.giftImageCount = 0;
    model6.giftDuration = 0;
    model6.giftPrice = @"888";
    
    GiftModel *model7 = [[GiftModel alloc] init];
    model7.giftId = @"43";
    model7.giftName = @"表白花语";
    model7.giftImageName = @"gift_biaobaihuayu";
    model7.giftImageCount = 0;
    model7.giftDuration = 0;
    model7.giftPrice = @"520";
    
    GiftModel *model8 = [[GiftModel alloc] init];
    model8.giftId = @"43";
    model8.giftName = @"蓝色妖姬";
    model8.giftImageName = @"gift_lanseyaoji";
    model8.giftImageCount = 0;
    model8.giftDuration = 0;
    model8.giftPrice = @"1234";
    
    GiftModel *model9 = [[GiftModel alloc] init];
    model9.giftId = @"42";
    model9.giftName = @"向日葵";
    model9.giftImageName = @"gift_icon_20";
    model9.giftImageCount = 0;
    model9.giftDuration = 0;
    model9.giftPrice = @"111";
    
    GiftModel *model10 = [[GiftModel alloc] init];
    model10.giftId = @"0";
    model10.giftName = @"小太阳";
    model10.giftImageName = @"gift_icon_21";
    model10.giftImageCount = 0;
    model10.giftDuration = 0;
    model10.giftPrice = @"222";
    
    GiftModel *model11 = [[GiftModel alloc] init];
    model11.giftId = @"45";
    model11.giftName = @"一见钟情";
    model11.giftImageName = @"gift_icon_22";
    model11.giftImageCount = 0;
    model11.giftDuration = 0;
    model11.giftPrice = @"1314";
    
    GiftModel *model12 = [[GiftModel alloc] init];
    model12.giftId = @"44";
    model12.giftName = @"快乐摆摆船";
    model12.giftImageName = @"gift_icon_23";
    model12.giftImageCount = 0;
    model12.giftDuration = 0;
    model12.giftPrice = @"6666";
    
    GiftModel *model13 = [[GiftModel alloc] init];
    model13.giftId = @"44";
    model13.giftName = @"浪漫碰碰车";
    model13.giftImageName = @"gift_icon_24";
    model13.giftImageCount = 0;
    model13.giftDuration = 0;
    model13.giftPrice = @"10000";
    
    GiftModel *model14 = [[GiftModel alloc] init];
    model14.giftId = @"44";
    model14.giftName = @"甜蜜之旅";
    model14.giftImageName = @"gift_icon_25";
    model14.giftImageCount = 0;
    model14.giftDuration = 0;
    model14.giftPrice = @"10000";
    
    
    [self.dataArr addObject:model0];
    [self.dataArr addObject:model4];
    [self.dataArr addObject:model1];
    [self.dataArr addObject:model6];
    [self.dataArr addObject:model7];
    [self.dataArr addObject:model8];
    [self.dataArr addObject:model9];
    [self.dataArr addObject:model10];
    [self.dataArr addObject:model11];
    [self.dataArr addObject:model12];
    [self.dataArr addObject:model13];
    
    [self.dataArr2 addObject:model2];
    [self.dataArr2 addObject:model14];
    
    [self.dataArr3 addObject:model3];
    
    [self.dataArr4 addObject:model5];
    
    self.pageControl.numberOfPages = [self pageCountOfGifts:self.dataArr];
}

// 添加子控件
- (void)addSubViews {
    [self addSubview:self.blankView];
    [self addSubview:self.contentView];
    [self.contentView addSubview:self.categoryScrollView];
    [self.contentView addSubview:self.collectionView];
    [self.contentView addSubview:self.pageControl];
    [self.contentView addSubview:self.coinButton];
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

// 更新金币数量
- (void)updateCoinCount:(NSString *)value {
    UILabel *countLabel = (UILabel *)[self.coinButton viewWithTag:20];
    UIImageView *arrowImageView = (UIImageView *)[self.coinButton viewWithTag:21];
    countLabel.text = [NSString stringWithFormat:@"%@", value];
    
    CGFloat maxW = WIDTH * 0.3;
    CGSize size = [countLabel.text boundingRectWithSize:CGSizeMake(maxW, CGRectGetHeight(countLabel.frame)) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName: countLabel.font} context:nil].size;
    CGRect frame = countLabel.frame;
    frame.size.width = size.width;
    countLabel.frame = frame;
    
    frame = arrowImageView.frame;
    frame.origin.x = CGRectGetMaxX(countLabel.frame) + 2;
    arrowImageView.frame = frame;
    
    frame = self.coinButton.frame;
    frame.size.width = CGRectGetMaxX(arrowImageView.frame);
    self.coinButton.frame = frame;
}


#pragma mark - Event

// 选择礼物分类
- (void)selectCategoryEvent:(UIButton *)sender {
    _selectedCategoryButton.selected = NO;
    sender.selected = YES;
    _selectedCategoryButton = sender;
    
    NSInteger count1 = [self pageCountOfGifts:self.dataArr];
    NSInteger count2 = [self pageCountOfGifts:self.dataArr2];
    NSInteger count3 = [self pageCountOfGifts:self.dataArr3];
    NSInteger count4 = [self pageCountOfGifts:self.dataArr4];
    NSInteger numberOfPages = count1;
    if (sender.tag == 10) {
        numberOfPages = count1;
        [self.collectionView setContentOffset:CGPointMake(0, 0) animated:YES];
    } else if (sender.tag == 11) {
        numberOfPages = count2;
        [self.collectionView setContentOffset:CGPointMake(count1 * _width, 0) animated:YES];
    } else if (sender.tag == 12) {
        numberOfPages = count3;
        [self.collectionView setContentOffset:CGPointMake((count1 + count2) * _width, 0) animated:YES];
    } else if (sender.tag == 13) {
        numberOfPages = count4;
        [self.collectionView setContentOffset:CGPointMake((count1 + count2 + count3) * _width, 0) animated:YES];
    }
    // 设置分页指示器
    self.pageControl.numberOfPages = numberOfPages;
    self.pageControl.currentPage = 0;
}

- (void)pageControlEvent:(UIPageControl *)sender {
    //    NSInteger currentPage = sender.currentPage;
    //    [self.collectionView setContentOffset:CGPointMake(currentPage * WIDTH, 0) animated:YES];
}

// 去充值
- (void)rechargeEvent {
    NSLog(@"去充值...");
}

// 送礼物
- (void)sendGiftEvent:(UIButton *)sender {
    [self dismiss];
    
    if ([self.delegate respondsToSelector:@selector(giftView:sendGift:)]) {
        [self.delegate giftView:self sendGift:_selectedGift];
    }
}


#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    NSInteger count1 = [self pageCountOfGifts:self.dataArr];
    NSInteger count2 = [self pageCountOfGifts:self.dataArr2];
    NSInteger count3 = [self pageCountOfGifts:self.dataArr3];
    NSInteger count4 = [self pageCountOfGifts:self.dataArr4];
    NSInteger count = count1 + count2 + count3 + count4;
    NSLog(@"一共有 %ld 页礼物", count);
    return count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    GiftCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:GiftCellID forIndexPath:indexPath];
    
    // 每类礼物的页数
    NSInteger count1 = [self pageCountOfGifts:self.dataArr];
    NSInteger count2 = [self pageCountOfGifts:self.dataArr2];
    NSInteger count3 = [self pageCountOfGifts:self.dataArr3];
    NSInteger count4 = [self pageCountOfGifts:self.dataArr4];
    
    NSMutableArray *tempArr = [NSMutableArray array];
    NSMutableArray *cellDataArr = [NSMutableArray array];
    NSUInteger pageCount = count1;
    NSUInteger indexRow = indexPath.row;
    
    if (indexPath.row < count1) {
        pageCount = count1;
        tempArr = [NSMutableArray arrayWithArray:self.dataArr];
    } else if (indexPath.row < (count1 + count2)) {
        pageCount = count2;
        tempArr = [NSMutableArray arrayWithArray:self.dataArr2];
        indexRow = indexPath.row - count1;
    } else if (indexPath.row < (count1 + count2 + count3)) {
        pageCount = count3;
        tempArr = [NSMutableArray arrayWithArray:self.dataArr3];
        indexRow = indexPath.row - (count1 + count2);
    } else {
        pageCount = count4;
        tempArr = [NSMutableArray arrayWithArray:self.dataArr4];
        indexRow = indexPath.row - (count1 + count2 + count3);
    }
    
    if (pageCount == 1) { // 只有一页
        cellDataArr = [NSMutableArray arrayWithArray:tempArr];
    } else { // 多页
        NSUInteger count = tempArr.count; // 每类礼物的个数
        if (indexRow == pageCount - 1) { // 最后一页
            NSInteger remainder = count % CountOfGiftPerPage;
            if (remainder == 0) { // 余数等于0，说明最后一页刚好10个
                cellDataArr = [NSMutableArray arrayWithArray:[tempArr subarrayWithRange:NSMakeRange(indexRow * CountOfGiftPerPage, CountOfGiftPerPage)]];
            } else { // 余数不等于0，说明最后一页不够10个
                cellDataArr = [NSMutableArray arrayWithArray:[tempArr subarrayWithRange:NSMakeRange(indexRow * CountOfGiftPerPage, remainder)]];
            }
        } else { // 中间页
            cellDataArr = [NSMutableArray arrayWithArray:[tempArr subarrayWithRange:NSMakeRange(indexRow * CountOfGiftPerPage, CountOfGiftPerPage)]];
        }
    }
    cell.dataArr = cellDataArr;

    // Block回调
    cell.selectGiftBlock = ^(GiftModel *cellModel, BOOL selected) {
        self.sendButton.enabled = selected;
        if (selected) {
            _selectedGift.selectedForSend = NO;
            cellModel.selectedForSend = YES;
            _selectedGift = cellModel;
            
            [collectionView reloadData];
        } else {
            _selectedGift = nil;
        }
    };
    return cell;
}

//- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
//    if ([kind isEqualToString:UICollectionElementKindSectionHeader]) { // 分区头部视图
//        UICollectionReusableView *view = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"CollectionView_Header_View" forIndexPath:indexPath];
//        view.backgroundColor = [UIColor orangeColor];
//        return view;
//    } else { // 分区尾部视图
//        UICollectionReusableView *view = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"CollectionView_Footer_View" forIndexPath:indexPath];
//        view.backgroundColor = [UIColor greenColor];
//        return view;
//    }
//}


#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    CGFloat offsetX = scrollView.contentOffset.x;
    NSInteger page = offsetX / WIDTH;
    
    NSInteger count1 = [self pageCountOfGifts:self.dataArr];
    NSInteger count2 = [self pageCountOfGifts:self.dataArr2];
    NSInteger count3 = [self pageCountOfGifts:self.dataArr3];
    NSInteger count4 = [self pageCountOfGifts:self.dataArr4];
    
    NSInteger tag = 10;
    NSInteger numberOfPages = count1;
    NSInteger currentPage = 0;
    if (page < count1) {
        tag = 10;
        numberOfPages = count1;
        currentPage = page;
    } else if (page < (count1 + count2)) {
        tag = 11;
        numberOfPages = count2;
        currentPage = page - count1;
    } else if (page < (count1 + count2 + count3)) {
        tag = 12;
        numberOfPages = count3;
        currentPage = page - (count1 + count2);
    } else {
        tag = 13;
        numberOfPages = count4;
        currentPage = page - (count1 + count2 + count3);
    }
    // 设置分页指示器
    self.pageControl.numberOfPages = numberOfPages;
    self.pageControl.currentPage = currentPage;
    
    // 设置分类按钮选中状态
    UIButton *button = (UIButton *)[self.categoryScrollView viewWithTag:tag];
    _selectedCategoryButton.selected = NO;
    button.selected = YES;
    _selectedCategoryButton = button;
}


#pragma mark - Getters

- (UIView *)blankView {
    if (!_blankView) {
        CGFloat h = _height - CONTENTVIEW_H;
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
        _contentView.backgroundColor = RGB(50, 31, 56);
    }
    return _contentView;
}

- (UIScrollView *)categoryScrollView {
    if (!_categoryScrollView) {
        _categoryScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, _width, CATEGORY_VIEW_H)];
        _categoryScrollView.backgroundColor = RGB(76, 59, 84);
        
        for (int i = 0; i < self.categories.count; i++) {
            NSString *name = self.categories[i];
            
            CGFloat w = _width / self.categories.count;
            CGFloat x = i * w;
            CGFloat h = CATEGORY_VIEW_H - 0.5;
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            button.tag = 10 + i;
            button.frame = CGRectMake(x, 0, w, h);
            button.titleLabel.font = [UIFont systemFontOfSize:15];
            button.backgroundColor = RGB(58, 42, 66);
            [button setTitle:name forState:UIControlStateNormal];
            [button setTitleColor:RGB(156, 148, 161) forState:UIControlStateNormal];
            [button setTitleColor:RGB(255, 83, 160) forState:UIControlStateSelected];
            [button addTarget:self action:@selector(selectCategoryEvent:) forControlEvents:UIControlEventTouchUpInside];
            if (!i) {
                button.selected = YES;
                _selectedCategoryButton = button;
            }
            [_categoryScrollView addSubview:button];
        }
    }
    return _categoryScrollView;
}

- (UICollectionView *)collectionView {
    if (!_collectionView) {
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        flowLayout.itemSize = CGSizeMake(GIFT_CELL_W, GIFT_CELL_H);
        flowLayout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
        flowLayout.minimumLineSpacing = 0;
        flowLayout.minimumInteritemSpacing = 0;
        //        // 分区头部大小
        //        flowLayout.headerReferenceSize = CGSizeMake(20, COLLECTIONVIEW_H);
        //        // 分区尾部大小
        //        flowLayout.footerReferenceSize = CGSizeMake(20, COLLECTIONVIEW_H);
        
        CGFloat y = CGRectGetMaxY(self.categoryScrollView.frame);
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, y, _width, COLLECTIONVIEW_H) collectionViewLayout:flowLayout];
        _collectionView.backgroundColor = [UIColor clearColor];
        _collectionView.showsHorizontalScrollIndicator = NO;
        _collectionView.dataSource = self;
        _collectionView.delegate = self;
        _collectionView.pagingEnabled = YES;
        [_collectionView registerClass:[GiftCell class] forCellWithReuseIdentifier:GiftCellID];
        //        [_collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"CollectionView_Header_View"];
        //        [_collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"CollectionView_Footer_View"];
    }
    return _collectionView;
}

- (UIPageControl *)pageControl {
    if (!_pageControl) {
        CGFloat y = CGRectGetMaxY(self.collectionView.frame);
        _pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(0, y, _width, PAGECONTROL_H)];
        _pageControl.currentPageIndicatorTintColor = [UIColor whiteColor];
        _pageControl.pageIndicatorTintColor = RGB(82, 78, 77);
        _pageControl.hidesForSinglePage = NO;
        [_pageControl addTarget:self action:@selector(pageControlEvent:) forControlEvents:UIControlEventValueChanged];
        _pageControl.userInteractionEnabled = NO;
    }
    return _pageControl;
}

- (NSMutableArray *)categories {
    if (!_categories) {
        _categories = [NSMutableArray array];
    }
    return _categories;
}

- (NSMutableArray *)dataArr {
    if (!_dataArr) {
        _dataArr = [NSMutableArray array];
    }
    return _dataArr;
}

- (NSMutableArray *)dataArr2 {
    if (!_dataArr2) {
        _dataArr2 = [NSMutableArray array];
    }
    return _dataArr2;
}

- (NSMutableArray *)dataArr3 {
    if (!_dataArr3) {
        _dataArr3 = [NSMutableArray array];
    }
    return _dataArr3;
}

- (NSMutableArray *)dataArr4 {
    if (!_dataArr4) {
        _dataArr4 = [NSMutableArray array];
    }
    return _dataArr4;
}

- (UIButton *)coinButton {
    if (!_coinButton) {
        CGFloat w = 54 * WIDTH_SCALE;
        CGFloat h = 48 * HEIGHT_SCALE;
        CGFloat x = 10 * WIDTH_SCALE;
        CGFloat y = CONTENTVIEW_H - h;
        
        _coinButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _coinButton.frame = CGRectMake(x, y, w, h);
        [_coinButton addTarget:self action:@selector(rechargeEvent) forControlEvents:UIControlEventTouchUpInside];
        
        h = 24 * HEIGHT_SCALE;
        y = (CGRectGetHeight(_coinButton.frame) - h) / 2;
        UIImageView *coinImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, y, h, h)];
        coinImageView.image = [UIImage imageNamed:@"live_coin"];
        [_coinButton addSubview:coinImageView];
        
        x = CGRectGetMaxX(coinImageView.frame) + 2;
        UILabel *coinCountLabel = [[UILabel alloc] initWithFrame:CGRectMake(x, y, 18, h)];
        coinCountLabel.textColor = RGB(255, 204, 0);
        coinCountLabel.font = [UIFont systemFontOfSize:17];
        coinCountLabel.text = @"0";
        coinCountLabel.tag = 20;
        [_coinButton addSubview:coinCountLabel];
        
        w = 9 * WIDTH_SCALE;
        h = 18 * HEIGHT_SCALE;
        x = CGRectGetWidth(_coinButton.frame) - w;
        y = (CGRectGetHeight(_coinButton.frame) - h) / 2;
        UIImageView *arrowImageView = [[UIImageView alloc] initWithFrame:CGRectMake(x, y, w, h)];
        arrowImageView.image = [UIImage imageNamed:@"present_arrow_7x13_"];
        arrowImageView.tag = 21;
        [_coinButton addSubview:arrowImageView];
    }
    return _coinButton;
}

- (UIButton *)sendButton {
    if (!_sendButton) {
        CGFloat w = 78;
        CGFloat h = SEND_BUTTON_H;
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

/** 根据礼物数组返回礼物的页数 (以每页展示10个礼物为单位来计算) */
- (NSUInteger)pageCountOfGifts:(NSArray *)dataArr {
    NSUInteger count = dataArr.count;
    NSUInteger pageCount = (count % CountOfGiftPerPage) == 0 ? (count / CountOfGiftPerPage) : (count / CountOfGiftPerPage + 1);
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







/*
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

#define CONTENTVIEW_H    (270 * HEIGHT_SCALE)
#define CATEGORY_VIEW_H  (40 * HEIGHT_SCALE)
#define COLLECTIONVIEW_H (172 * HEIGHT_SCALE)
#define PAGECONTROL_H    (13 * HEIGHT_SCALE)
#define SEND_BUTTON_H    (45 * HEIGHT_SCALE)

const NSUInteger CountOfGiftPerPage = 10; // 每页礼物的个数

@interface BWGiftView () <UICollectionViewDelegateFlowLayout, UICollectionViewDelegate, UICollectionViewDataSource> {
    CGFloat _width;
    CGFloat _height;
    UIButton *_selectedCategoryButton; // 选中的分类按钮
    GiftModel *_selectedGift; // 选中的礼物model
}
@property (nonatomic, strong) UIView *blankView; // 空白view
@property (nonatomic, strong) UIView *contentView;

@property (nonatomic, strong) UIScrollView *categoryScrollView;
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) UIPageControl *pageControl;
@property (nonatomic, strong) UIButton *coinButton; // 金币数量按钮
@property (nonatomic, strong) UIButton *sendButton;

@property (nonatomic, strong) NSMutableArray *categories;
@property (nonatomic, strong) NSMutableArray *dataArr;
@property (nonatomic, strong) NSMutableArray *dataArr2;
@property (nonatomic, strong) NSMutableArray *dataArr3;
@property (nonatomic, strong) NSMutableArray *dataArr4;
@property (nonatomic, assign) NSUInteger pageCountOfGift; // 礼物的页数

@property (nonatomic, strong) UICollectionView *collectionViewTest;

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
    
    [self.categories addObjectsFromArray:@[@"热门", @"节日", @"本地", @"奢华"]];
    
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
    [self.dataArr addObject:model3];
    [self.dataArr addObject:model3];
    
    [self.dataArr2 addObject:model2];
    [self.dataArr2 addObject:model3];
    [self.dataArr2 addObject:model3];
    [self.dataArr2 addObject:model3];
    [self.dataArr2 addObject:model3];
    [self.dataArr2 addObject:model3];
    [self.dataArr2 addObject:model3];
    
    [self.dataArr3 addObject:model2];
    [self.dataArr3 addObject:model3];
    [self.dataArr3 addObject:model3];
    [self.dataArr3 addObject:model3];
    [self.dataArr3 addObject:model3];
    [self.dataArr3 addObject:model3];
    [self.dataArr3 addObject:model3];
    [self.dataArr3 addObject:model2];
    [self.dataArr3 addObject:model3];
    [self.dataArr3 addObject:model3];
    
    [self.dataArr4 addObject:model3];
    [self.dataArr4 addObject:model3];
    [self.dataArr4 addObject:model3];
    [self.dataArr4 addObject:model3];
    [self.dataArr4 addObject:model2];
    [self.dataArr4 addObject:model3];
    [self.dataArr4 addObject:model3];
    [self.dataArr4 addObject:model3];
    [self.dataArr4 addObject:model3];
    [self.dataArr4 addObject:model2];
    [self.dataArr4 addObject:model3];
    [self.dataArr4 addObject:model3];
    [self.dataArr4 addObject:model3];
    [self.dataArr4 addObject:model3];
    
    self.pageControl.numberOfPages = self.pageCountOfGift;
}

// 添加子控件
- (void)addSubViews {
    [self addSubview:self.blankView];
    [self addSubview:self.contentView];
    [self.contentView addSubview:self.categoryScrollView];
//    [self.contentView addSubview:self.collectionView];
    [self.contentView addSubview:self.collectionViewTest];
    [self.contentView addSubview:self.pageControl];
    [self.contentView addSubview:self.coinButton];
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
 *//*
- (void)showToView:(UIView *)view {
    [view addSubview:self]; 
}
*/
/**
 移除view
 */
/*
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

// 更新金币数量
- (void)updateCoinCount:(NSString *)value {
    UILabel *countLabel = (UILabel *)[self.coinButton viewWithTag:20];
    UIImageView *arrowImageView = (UIImageView *)[self.coinButton viewWithTag:21];
    countLabel.text = [NSString stringWithFormat:@"%@", value];
    
    CGFloat maxW = WIDTH * 0.3;
    CGSize size = [countLabel.text boundingRectWithSize:CGSizeMake(maxW, CGRectGetHeight(countLabel.frame)) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName: countLabel.font} context:nil].size;
    CGRect frame = countLabel.frame;
    frame.size.width = size.width;
    countLabel.frame = frame;
    
    frame = arrowImageView.frame;
    frame.origin.x = CGRectGetMaxX(countLabel.frame) + 2;
    arrowImageView.frame = frame;
    
    frame = self.coinButton.frame;
    frame.size.width = CGRectGetMaxX(arrowImageView.frame);
    self.coinButton.frame = frame;
}


#pragma mark - Event

// 选择礼物分类
- (void)selectCategoryEvent:(UIButton *)sender {
    _selectedCategoryButton.selected = NO;
    sender.selected = YES;
    _selectedCategoryButton = sender;
    
    NSInteger count1 = [self pageCountOfGiftWithDataArr:self.dataArr];
    NSInteger count2 = [self pageCountOfGiftWithDataArr:self.dataArr2];
    NSInteger count3 = [self pageCountOfGiftWithDataArr:self.dataArr3];
    NSInteger count4 = [self pageCountOfGiftWithDataArr:self.dataArr4];
    NSInteger numberOfPages = count1;
    if (sender.tag == 10) {
        numberOfPages = count1;
        [self.collectionViewTest setContentOffset:CGPointMake(0, 0) animated:YES];
    } else if (sender.tag == 11) {
        numberOfPages = count2;
        [self.collectionViewTest setContentOffset:CGPointMake(count1 * _width, 0) animated:YES];
    } else if (sender.tag == 12) {
        numberOfPages = count3;
        [self.collectionViewTest setContentOffset:CGPointMake((count1 + count2) * _width, 0) animated:YES];
    } else if (sender.tag == 13) {
        numberOfPages = count4;
        [self.collectionViewTest setContentOffset:CGPointMake((count1 + count2 + count3) * _width, 0) animated:YES];
    }
    // 设置分页指示器
    self.pageControl.numberOfPages = numberOfPages;
    self.pageControl.currentPage = 0;
}

- (void)pageControlEvent:(UIPageControl *)sender {
//    NSInteger currentPage = sender.currentPage;
//    [self.collectionView setContentOffset:CGPointMake(currentPage * WIDTH, 0) animated:YES];
}

// 去充值
- (void)rechargeEvent {
    NSLog(@"去充值...");
}

// 送礼物
- (void)sendGiftEvent:(UIButton *)sender {
    [self dismiss];
    
    if ([self.delegate respondsToSelector:@selector(giftView:sendGift:)]) {
        [self.delegate giftView:self sendGift:_selectedGift];
    }
}


#pragma mark - UICollectionViewDataSource

//- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
//    return self.pageCountOfGift;
//}
//
//- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
//    GiftCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:GiftCellID forIndexPath:indexPath];
//    
//    NSMutableArray *dataArr = [NSMutableArray array];
//    NSUInteger count = self.dataArr.count;
//    if (self.pageCountOfGift == 1) { // 只有一页
//        dataArr = [NSMutableArray arrayWithArray:self.dataArr];
//    } else { // 多页
//        if (indexPath.row == self.pageCountOfGift - 1) { // 最后一页
//            NSInteger remainder = count % CountOfGiftPerPage;
//            if (remainder == 0) { // 余数等于0，说明最后一页刚好10个
//                dataArr = [NSMutableArray arrayWithArray:[self.dataArr subarrayWithRange:NSMakeRange(indexPath.row * CountOfGiftPerPage, CountOfGiftPerPage)]];
//            } else { // 余数不等于0，说明最后一页不够10个
//                dataArr = [NSMutableArray arrayWithArray:[self.dataArr subarrayWithRange:NSMakeRange(indexPath.row * CountOfGiftPerPage, remainder)]];
//            }
//        } else { // 中间页
//            dataArr = [NSMutableArray arrayWithArray:[self.dataArr subarrayWithRange:NSMakeRange(indexPath.row * CountOfGiftPerPage, CountOfGiftPerPage)]];
//        }
//    }
//    cell.dataArr = dataArr;
//    
//    // Block回调
//    cell.selectGiftBlock = ^(GiftModel *cellModel) {
//        self.sendButton.enabled = YES;
//        _selectedGift = cellModel;
//    };
//    return cell;
//}



- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 4;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if (section == 0) { // 返回10的整数倍,凑成一页来显示
        return [self numberOfTenIntegralMultipleWithCount:self.dataArr.count];
    } else if (section == 1) {
        return [self numberOfTenIntegralMultipleWithCount:self.dataArr2.count];
    } else if (section == 2) {
        return [self numberOfTenIntegralMultipleWithCount:self.dataArr3.count];
    } else {
        return [self numberOfTenIntegralMultipleWithCount:self.dataArr4.count];
    }
}

//- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
//    if ([kind isEqualToString:UICollectionElementKindSectionHeader]) { // 分区头部视图
//        UICollectionReusableView *view = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"CollectionView_Header_View" forIndexPath:indexPath];
//        view.backgroundColor = [UIColor orangeColor];
//        return view;
//    } else { // 分区尾部视图
//        UICollectionReusableView *view = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"CollectionView_Footer_View" forIndexPath:indexPath];
//        view.backgroundColor = [UIColor greenColor];
//        return view;
//    }
//}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        if (indexPath.row < self.dataArr.count) {
            SingleGiftCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:SingleGiftCellID forIndexPath:indexPath];
            GiftModel *model = self.dataArr[indexPath.row];
            cell.model = model;
            return cell;
        } else {
            SingleGiftBlankCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:SingleGiftBlankCellID forIndexPath:indexPath];
            return cell;
        }
        
    } else if (indexPath.section == 1) {
        if (indexPath.row < self.dataArr2.count) {
            SingleGiftCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:SingleGiftCellID forIndexPath:indexPath];
            GiftModel *model = self.dataArr2[indexPath.row];
            cell.model = model;
            return cell;
        } else {
            SingleGiftBlankCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:SingleGiftBlankCellID forIndexPath:indexPath];
            return cell;
        }
        
    } else if (indexPath.section == 2) {
        if (indexPath.row < self.dataArr3.count) {
            SingleGiftCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:SingleGiftCellID forIndexPath:indexPath];
            GiftModel *model = self.dataArr3[indexPath.row];
            cell.model = model;
            return cell;
        } else {
            SingleGiftBlankCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:SingleGiftBlankCellID forIndexPath:indexPath];
            return cell;
        }
        
    } else {
        if (indexPath.row < self.dataArr4.count) {
            SingleGiftCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:SingleGiftCellID forIndexPath:indexPath];
            GiftModel *model = self.dataArr4[indexPath.row];
            cell.model = model;
            return cell;
        } else {
            SingleGiftBlankCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:SingleGiftBlankCellID forIndexPath:indexPath];
            return cell;
        }  
    }
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
//    if (self.selectGiftBlock) {
//        GiftModel *model = self.dataArr[indexPath.row];
//        self.selectGiftBlock(model);
//    }
    
    self.sendButton.enabled = YES;
    if (indexPath.section == 0) {
        if (indexPath.row < self.dataArr.count) {
            GiftModel *model = self.dataArr[indexPath.row];
            _selectedGift = model;
        }
    } else if (indexPath.section == 1) {
        if (indexPath.row < self.dataArr2.count) {
            GiftModel *model = self.dataArr2[indexPath.row];
            _selectedGift = model;
        }
    } else if (indexPath.section == 2) {
        if (indexPath.row < self.dataArr3.count) {
            GiftModel *model = self.dataArr3[indexPath.row];
            _selectedGift = model;
        }
    } else {
        if (indexPath.row < self.dataArr4.count) {
            GiftModel *model = self.dataArr4[indexPath.row];
            _selectedGift = model;
        }
    }
}


#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
//    CGFloat offsetX = scrollView.contentOffset.x;
//    NSInteger page = offsetX / WIDTH;
//    self.pageControl.currentPage = page;
    
    
    CGFloat offsetX = scrollView.contentOffset.x;
    NSInteger page = offsetX / WIDTH;
    
    NSInteger count1 = [self pageCountOfGiftWithDataArr:self.dataArr];
    NSInteger count2 = [self pageCountOfGiftWithDataArr:self.dataArr2];
    NSInteger count3 = [self pageCountOfGiftWithDataArr:self.dataArr3];
    NSInteger count4 = [self pageCountOfGiftWithDataArr:self.dataArr4];
    
    NSInteger tag = 10;
    NSInteger numberOfPages = count1;
    NSInteger currentPage = 0;
    if (page < count1) {
        tag = 10;
        numberOfPages = count1;
        currentPage = page;
    } else if (page < (count1 + count2)) {
        tag = 11;
        numberOfPages = count2;
        currentPage = page - count1;
    } else if (page < (count1 + count2 + count3)) {
        tag = 12;
        numberOfPages = count3;
        currentPage = page - (count1 + count2);
    } else {
        tag = 13;
        numberOfPages = count4;
        currentPage = page - (count1 + count2 + count3);
    }
    // 设置分页指示器
    self.pageControl.numberOfPages = numberOfPages;
    self.pageControl.currentPage = currentPage;
    
    // 设置分类按钮选中状态
    UIButton *button = (UIButton *)[self.categoryScrollView viewWithTag:tag];
    _selectedCategoryButton.selected = NO;
    button.selected = YES;
    _selectedCategoryButton = button;
}


#pragma mark - Getters

- (UIView *)blankView {
    if (!_blankView) {
        CGFloat h = _height - CONTENTVIEW_H;
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
        _contentView.backgroundColor = RGB(50, 31, 56);
    }
    return _contentView;
}

- (UIScrollView *)categoryScrollView {
    if (!_categoryScrollView) {
        _categoryScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, _width, CATEGORY_VIEW_H)];
        _categoryScrollView.backgroundColor = RGB(76, 59, 84);
        
        for (int i = 0; i < self.categories.count; i++) {
            NSString *name = self.categories[i];
            
            CGFloat w = _width / self.categories.count;
            CGFloat x = i * w;
            CGFloat h = CATEGORY_VIEW_H - 0.5;
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            button.tag = 10 + i;
            button.frame = CGRectMake(x, 0, w, h);
            button.titleLabel.font = [UIFont systemFontOfSize:15];
            button.backgroundColor = RGB(58, 42, 66);
            [button setTitle:name forState:UIControlStateNormal];
            [button setTitleColor:RGB(156, 148, 161) forState:UIControlStateNormal];
            [button setTitleColor:RGB(255, 83, 160) forState:UIControlStateSelected];
            [button addTarget:self action:@selector(selectCategoryEvent:) forControlEvents:UIControlEventTouchUpInside];
            if (!i) {
                button.selected = YES;
                _selectedCategoryButton = button;
            }
            [_categoryScrollView addSubview:button];
        }
    }
    return _categoryScrollView;
}

- (UICollectionView *)collectionView {
    if (!_collectionView) {
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        flowLayout.itemSize = CGSizeMake(GIFT_CELL_W, GIFT_CELL_H);
        flowLayout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
        flowLayout.minimumLineSpacing = 0;
        flowLayout.minimumInteritemSpacing = 0;
        
        CGFloat y = CGRectGetMaxY(self.categoryScrollView.frame);
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, y, _width, COLLECTIONVIEW_H) collectionViewLayout:flowLayout];
        _collectionView.backgroundColor = [UIColor clearColor];
        _collectionView.showsHorizontalScrollIndicator = NO;
        _collectionView.dataSource = self;
        _collectionView.delegate = self;
        _collectionView.pagingEnabled = YES;
        [_collectionView registerClass:[GiftCell class] forCellWithReuseIdentifier:GiftCellID];
    }
    return _collectionView;
}

- (UICollectionView *)collectionViewTest {
    if (!_collectionViewTest) {
        CGFloat y = CGRectGetMaxY(self.categoryScrollView.frame);
        
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        flowLayout.itemSize = CGSizeMake(SINGLEGIFT_CELL_W, SINGLEGIFT_CELL_H);
        flowLayout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
        flowLayout.minimumLineSpacing = 0;
        flowLayout.minimumInteritemSpacing = 0;
//        // 分区头部大小
//        flowLayout.headerReferenceSize = CGSizeMake(20, COLLECTIONVIEW_H);
//        // 分区尾部大小
//        flowLayout.footerReferenceSize = CGSizeMake(20, COLLECTIONVIEW_H);
        
        _collectionViewTest = [[UICollectionView alloc] initWithFrame:CGRectMake(0, y, _width, COLLECTIONVIEW_H) collectionViewLayout:flowLayout];
        _collectionViewTest.backgroundColor = [UIColor clearColor];
        _collectionViewTest.showsHorizontalScrollIndicator = NO;
        _collectionViewTest.dataSource = self;
        _collectionViewTest.delegate = self;
        _collectionViewTest.pagingEnabled = YES;
        _collectionViewTest.contentSize = CGSizeMake(_width, COLLECTIONVIEW_H);
        [_collectionViewTest registerClass:[SingleGiftCell class] forCellWithReuseIdentifier:SingleGiftCellID];
        [_collectionViewTest registerClass:[SingleGiftBlankCell class] forCellWithReuseIdentifier:SingleGiftBlankCellID];
        
//        [_collectionViewTest registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"CollectionView_Header_View"];
//        [_collectionViewTest registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"CollectionView_Footer_View"];
    }
    return _collectionViewTest;
}

- (UIPageControl *)pageControl {
    if (!_pageControl) {
        CGFloat y = CGRectGetMaxY(self.collectionView.frame);
        _pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(0, y, _width, PAGECONTROL_H)];
        _pageControl.currentPageIndicatorTintColor = [UIColor whiteColor];
        _pageControl.pageIndicatorTintColor = RGB(82, 78, 77);
        _pageControl.hidesForSinglePage = NO;
        [_pageControl addTarget:self action:@selector(pageControlEvent:) forControlEvents:UIControlEventValueChanged];
    }
    return _pageControl;
}

- (NSMutableArray *)categories {
    if (!_categories) {
        _categories = [NSMutableArray array];
    }
    return _categories;
}

- (NSMutableArray *)dataArr {
    if (!_dataArr) {
        _dataArr = [NSMutableArray array];
    }
    return _dataArr;
}

- (NSMutableArray *)dataArr2 {
    if (!_dataArr2) {
        _dataArr2 = [NSMutableArray array];
    }
    return _dataArr2;
}

- (NSMutableArray *)dataArr3 {
    if (!_dataArr3) {
        _dataArr3 = [NSMutableArray array];
    }
    return _dataArr3;
}

- (NSMutableArray *)dataArr4 {
    if (!_dataArr4) {
        _dataArr4 = [NSMutableArray array];
    }
    return _dataArr4;
}

- (UIButton *)coinButton {
    if (!_coinButton) {
        CGFloat w = 54 * WIDTH_SCALE;
        CGFloat h = 48 * HEIGHT_SCALE;
        CGFloat x = 10 * WIDTH_SCALE;
        CGFloat y = CONTENTVIEW_H - h;
        
        _coinButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _coinButton.frame = CGRectMake(x, y, w, h);
        [_coinButton addTarget:self action:@selector(rechargeEvent) forControlEvents:UIControlEventTouchUpInside];
        
        h = 24 * HEIGHT_SCALE;
        y = (CGRectGetHeight(_coinButton.frame) - h) / 2;
        UIImageView *coinImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, y, h, h)];
        coinImageView.image = [UIImage imageNamed:@"live_coin"];
        [_coinButton addSubview:coinImageView];
        
        x = CGRectGetMaxX(coinImageView.frame) + 2;
        UILabel *coinCountLabel = [[UILabel alloc] initWithFrame:CGRectMake(x, y, 18, h)];
        coinCountLabel.textColor = RGB(255, 204, 0); 
        coinCountLabel.font = [UIFont systemFontOfSize:17];
        coinCountLabel.text = @"0";
        coinCountLabel.tag = 20;
        [_coinButton addSubview:coinCountLabel]; 
        
        w = 9 * WIDTH_SCALE;
        h = 18 * HEIGHT_SCALE;
        x = CGRectGetWidth(_coinButton.frame) - w;
        y = (CGRectGetHeight(_coinButton.frame) - h) / 2;
        UIImageView *arrowImageView = [[UIImageView alloc] initWithFrame:CGRectMake(x, y, w, h)];
        arrowImageView.image = [UIImage imageNamed:@"present_arrow_7x13_"];
        arrowImageView.tag = 21;
        [_coinButton addSubview:arrowImageView];
    }
    return _coinButton;
}

- (UIButton *)sendButton {
    if (!_sendButton) {
        CGFloat w = 78;
        CGFloat h = SEND_BUTTON_H;
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
*/
/** 根据数据源数组返回礼物的页数(每页10个) *//*
- (NSUInteger)pageCountOfGiftWithDataArr:(NSArray *)dataArr {
    NSUInteger count = dataArr.count;
    NSInteger pageCount = (count % CountOfGiftPerPage) == 0 ? (count / CountOfGiftPerPage) : (count / CountOfGiftPerPage + 1);
    return pageCount;
}
*/
/** 根据count返回10的整数倍 *//*
- (NSUInteger)numberOfTenIntegralMultipleWithCount:(NSInteger)count {
    NSUInteger number = 0;
    
    if (count <= 10) { // <=10,返回10
        number = 10;
    } else { // >=10 && <20,返回20
        // 余数
        NSInteger remainder = count % 10;
        // 商数
        NSInteger quotient = count / 10;
        
        number = remainder == 0 ? count : (quotient + 1) * 10;
    }
    return number;
}
*/

/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
 */
/*
@end

*/
