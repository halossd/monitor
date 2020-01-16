//
//  MOCollectionViewLayout.m
//  monitor
//
//  Created by cc on 2019/9/9.
//  Copyright © 2019 cc. All rights reserved.
//

#import "MOCollectionViewLayout.h"

#define WIN_WIDTH  [[UIScreen mainScreen] bounds].size.width

@interface MOCollectionViewLayout ()

/** 存放所有的布局属性 */
@property (nonatomic, strong) NSMutableArray<UICollectionViewLayoutAttributes *> *attrsArray;
/** 存放所有列的当前高度 */
@property (nonatomic, strong) NSMutableArray *columnHeights;
/** 内容的高度 */
@property (nonatomic, assign) CGFloat contentHeight;

@end

@implementation MOCollectionViewLayout

#pragma mark 懒加载
- (NSMutableArray *)attrsArr{
    if (!_attrsArray) {
        _attrsArray = [NSMutableArray array];
    }
    
    return _attrsArray;
}

- (NSMutableArray *)columnHeights{
    if (!_columnHeights) {
        _columnHeights = [NSMutableArray array];
    }
    
    return _columnHeights;
}

#pragma mark - 数据处理
/**
 * 列数
 */
- (NSUInteger)columnCount{
    if ([self.delegate respondsToSelector:@selector(columnCountForLayout)]){
        return [self.delegate columnCountForLayout];
    }
    return 3;
}

/**
 * 列间距
 */
- (CGFloat)columnMargin{
    return 10;
}

/**
 * 行间距
 */
- (CGFloat)rowMargin{
    return 10;
}

/**
 * item的内边距
 */
- (UIEdgeInsets)edgeInsets{
    return UIEdgeInsetsZero;
}

- (void)prepareLayout
{
    [super prepareLayout];
    self.contentHeight = 0;
    
    // 清除以前计算的所有高度
    [self.columnHeights removeAllObjects];
    for (NSInteger i = 0; i < self.columnCount; i++) {
        [self.columnHeights addObject:@(self.edgeInsets.top)];
    }
    
    // 清除之前所有的布局属性
    [self.attrsArray removeAllObjects];
    
    // 开始创建每一个cell对应的布局属性
    NSInteger count = [self.collectionView numberOfItemsInSection:0];
    for (NSInteger i = 0; i < count; i++) {
        // 创建位置
        NSIndexPath *indexPath = [NSIndexPath indexPathForItem:i inSection:0];
        
        // 获取indexPath位置cell对应的布局属性
        UICollectionViewLayoutAttributes *attrs = [self layoutAttributesForItemAtIndexPath:indexPath];
        [self.attrsArray addObject:attrs];
    }
}

- (NSArray<UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect
{
    return self.attrsArray;
}

- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath
{
    // 创建布局属性
    UICollectionViewLayoutAttributes *attrs = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];

    // collectionView的宽度
    //CGFloat collectionViewW = self.collectionView.frame.size.width;
    
    // 设置布局属性的frame
    CGSize itemSize = [self.delegate itemSizeForIndexPath:indexPath];
    CGFloat w = itemSize.width; //(collectionViewW - self.edgeInsets.left - self.edgeInsets.right - (self.columnCount - 1) * self.columnMargin) / self.columnCount;
    CGFloat h = itemSize.height; //[self.delegate waterflowLayout:self heightForItemAtIndex:indexPath.item itemWidth:w];
    
    // 找出高度最短的那一列
    NSInteger destColumn = 0;
    CGFloat minColumnHeight = [self.columnHeights[0] doubleValue];
    for (NSInteger i = 1; i < self.columnCount; i++) {
        // 取得第i列的高度
        CGFloat columnHeight = [self.columnHeights[i] doubleValue];
        if (minColumnHeight > columnHeight) {
            minColumnHeight = columnHeight;
            destColumn = i;
        }
    }
    
    CGFloat x = self.edgeInsets.left + destColumn * (w + self.columnMargin);
    CGFloat y = minColumnHeight;
    if (y != self.edgeInsets.top) {
        y += self.rowMargin;
    }
    attrs.frame = CGRectMake(x, y, w, h);
    
    // 更新最短那列的高度
    self.columnHeights[destColumn] = @(CGRectGetMaxY(attrs.frame));
    
    // 记录内容的高度
    CGFloat columnHeight = [self.columnHeights[destColumn] doubleValue];
    if (self.contentHeight < columnHeight) {
        self.contentHeight = columnHeight;
    }
    
    return attrs;
}

- (CGSize)collectionViewContentSize
{
    return CGSizeMake(0, self.contentHeight + self.edgeInsets.bottom);
}


@end
