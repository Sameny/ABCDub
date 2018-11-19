//
//  ABCCommonCollectionView.m
//  PlayerWithDub
//
//  Created by 泽泰 舒 on 2018/11/15.
//  Copyright © 2018年 泽泰 舒. All rights reserved.
//

#import "ABCCommonCollectionView.h"

CGFloat const ABCCommonCollectionViewCellAutoDivideWidth = 1.11;

@interface ABCCommonCollectionView () <UICollectionViewDataSource>

@property (nonatomic, assign) BOOL needAverageLineSpace; // 是否平均分配行空间

@end

@implementation ABCCommonCollectionView

- (instancetype)initWithFrame:(CGRect)frame collectionViewLayout:(UICollectionViewFlowLayout *)layout {
    self = [super initWithFrame:frame collectionViewLayout:layout];
    if (self) {
        if (layout.itemSize.width == ABCCommonCollectionViewCellAutoDivideWidth) { // 如果为（0， y）每个cell是否平均分配行空间
            self.needAverageLineSpace = YES;
        }
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

- (void)setData:(NSArray<__kindof ABCCommonCollectionViewItemData *> *)data {
    if (data.count > 0) {
        _data = [data mutableCopy];
        [self updateCollectionViewCellSize];
        if (!self.dataSource) {
            [self registerClass:[self.cellClass class] forCellWithReuseIdentifier:[self reuseId]];
            self.dataSource = self;
        }
        [self reloadData];
    }
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

- (void)updateCollectionViewCellSize {
    UICollectionViewFlowLayout *layout = (UICollectionViewFlowLayout *)self.collectionViewLayout;
    if (self.needAverageLineSpace && _data.count > 0) {
        UIEdgeInsets insets = layout.sectionInset;
        layout.itemSize = CGSizeMake((self.bounds.size.width - insets.left - insets.right)/_data.count, layout.itemSize.height);
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

