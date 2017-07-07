//
//  WaterFallCollectionLayout.m
//  LiveForMobile
//
//  Created by  Sierra on 2017/7/6.
//  Copyright © 2017年 BaiFuTak. All rights reserved.
//

#import "WaterFallCollectionLayout.h"

@interface WaterFallCollectionLayout ()

@property (nonatomic, strong) NSMutableArray <NSNumber *>*columnHeightArr; // 存储每列的总高度

@property (nonatomic, assign) CGFloat columnWidth; // Cell宽度

@end

@implementation WaterFallCollectionLayout

#pragma mark - Life Cycle

- (instancetype)init {
    if (self = [super init]) { 
    }
    return self;
}

- (instancetype)initWithItemsHeightBlock:(ItemHeightBlock)block {
    if (self = [super init]) {
        self.heightBlock = block;
    }
    return self;
}


#pragma mark - Override

- (void)prepareLayout {
    [super prepareLayout];
    
    self.columnWidth = (CGRectGetWidth(self.collectionView.frame) - ((WATERFALL_COLUMNCOUNT + 1) * WATERFALL_COLUMN_MARGIN)) / WATERFALL_COLUMNCOUNT;
    _columnHeightArr = nil;
}

// 返回每个cell的布局属性
- (NSArray<UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect {
    NSInteger itemCount = [self.collectionView numberOfItemsInSection:0];
    NSMutableArray *layoutAttriArr = [NSMutableArray array];
    for (int i = 0; i < itemCount; i++) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForItem:i inSection:0];
        UICollectionViewLayoutAttributes *layoutAttri = [self layoutAttributesForItemAtIndexPath:indexPath];
        [layoutAttriArr addObject:layoutAttri];
    }
    return layoutAttriArr;
}

// 计算每个cell的布局属性
- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewLayoutAttributes *layoutAttri = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
    // 1. 计算x/y值
    NSNumber *shortest = self.columnHeightArr[0];
    NSInteger shortColumn = 0;
    for (int i = 0; i < self.columnHeightArr.count; i++) {
        NSNumber *height = self.columnHeightArr[i];
        if (shortest.floatValue > height.floatValue) {
            shortest = height;
            shortColumn = i;
        }
    }
    CGFloat x = (shortColumn + 1) * WATERFALL_COLUMN_MARGIN + (shortColumn * self.columnWidth);
    CGFloat y = shortest.floatValue + WATERFALL_ROW_MARGIN;
    CGFloat w = self.columnWidth;
    CGFloat h = 0;
    
    // 2. 获取Cell高度 (两种获取方式:1.Block回调获取 2.从heightArr数组中获取, 两种方式可使用其中一种)
    if (self.heightBlock) {
        h = self.heightBlock(indexPath);
    } else {
        if (indexPath.row >= self.heightArr.count) {
            NSAssert(indexPath.row < self.heightArr.count, @"数组越界, 存储高度的数组越界了.");
        } else {
            NSNumber *heightNum = self.heightArr[indexPath.row];
            h = [heightNum floatValue];
        }
    }
    layoutAttri.frame = CGRectMake(x, y, w, h);
    
    // 3. 更新列高度
    self.columnHeightArr[shortColumn] = @(shortest.floatValue + WATERFALL_ROW_MARGIN + h);
    
    return layoutAttri;
}

- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds {
    return YES;
}

// 取最高一列的高度作为collectionView的content高度
- (CGSize)collectionViewContentSize {
    NSNumber *longest = self.columnHeightArr[0];
    for (int i = 0; i < self.columnHeightArr.count; i++) {
        NSNumber *height = self.columnHeightArr[i];
        if (longest.floatValue < height.floatValue) {
            longest = height;
        }
    }
    return CGSizeMake(CGRectGetWidth(self.collectionView.frame), longest.floatValue);
}


#pragma mark - Getters

- (NSMutableArray *)columnHeightArr {
    if (!_columnHeightArr) {
        _columnHeightArr = [NSMutableArray array];
        for (int i = 0; i < WATERFALL_COLUMNCOUNT; i++) {
            // 这里可以设置初始高度
            [_columnHeightArr addObject:@(0)];
        }
    }
    return _columnHeightArr;
}

@end
