//
//  ABCCommonCollectionView.m
//  PlayerWithDub
//
//  Created by 泽泰 舒 on 2018/11/15.
//  Copyright © 2018年 泽泰 舒. All rights reserved.
//

#import "ABCCommonCollectionView.h"

@interface ABCCommonCollectionView () <UICollectionViewDataSource>



@end

@implementation ABCCommonCollectionView

- (instancetype)initWithFrame:(CGRect)frame collectionViewLayout:(UICollectionViewFlowLayout *)layout {
    self = [super initWithFrame:frame collectionViewLayout:layout];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        self.itemSize = CGSizeZero;
    }
    return self;
}

- (void)setData:(NSArray<__kindof ABCCommonCollectionViewItemData *> *)data {
    _data = [data mutableCopy];
    [self updateCollectionViewCellSize];
    if (!self.dataSource) {
        [self registerClass:[self.cellClass class] forCellWithReuseIdentifier:[self reuseId]];
        self.dataSource = self;
    }
    [self reloadData];
}

- (void)setFrame:(CGRect)frame {
    [super setFrame:frame];
    [self updateCollectionViewCellSize];
    if (self.dataSource) {
        [self reloadData];
    }
}

- (NSString *)reuseId {
    __kindof ABCCommonCollectionViewCell *cellClass = (__kindof ABCCommonCollectionViewCell *)self.cellClass;
    return [cellClass abc_reuseId];
}

- (void)setItemSize:(CGSize)itemSize {
    if (!CGSizeEqualToSize(self.itemSize, itemSize)) {
        _itemSize = itemSize;
        [self updateCollectionViewCellSize];
    }
    if (self.dataSource) {
        [self reloadData];
    }
}

- (void)updateCollectionViewCellSize {
    UICollectionViewFlowLayout *layout = (UICollectionViewFlowLayout *)self.collectionViewLayout;
    if (self.itemSize.width == 0) {
        UIEdgeInsets insets = layout.sectionInset;
        layout.itemSize = CGSizeMake((self.bounds.size.width - insets.left - insets.right)/_data.count, layout.itemSize.height);
    }
    else {
        layout.itemSize = self.itemSize;
    }
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return _data.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    __kindof ABCCommonCollectionViewCell *cell = (__kindof ABCCommonCollectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:[self reuseId] forIndexPath:indexPath];
    __kindof ABCCommonCollectionViewItemData *data = _data[indexPath.row];
    [cell setCellWithCellItemData:data];
    return cell;
}

- (Class)cellClass {
    if (_cellClass) {
        return _cellClass;
    }
    return NSClassFromString(@"ABCCommonCollectionViewCell");
}

@end

