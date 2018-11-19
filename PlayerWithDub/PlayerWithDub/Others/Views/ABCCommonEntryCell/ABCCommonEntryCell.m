//
//  ABCCommonEntryCell.m
//  PlayerWithDub
//
//  Created by 泽泰 舒 on 2018/11/16.
//  Copyright © 2018年 泽泰 舒. All rights reserved.
//

#import "ABCCommonCollectionView.h"
#import "ABCCommonEntryCell.h"

@implementation ABCCommonEntryCell

- (UICollectionViewLayout *)abc_CollectionViewLayout {
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    layout.minimumLineSpacing = 0;
    layout.minimumInteritemSpacing = 0;
    layout.sectionInset = UIEdgeInsetsMake(0, 10, 0, 10);
    layout.itemSize = CGSizeMake(ABCCommonCollectionViewCellAutoDivideWidth, self.height);
    return layout;
}

- (Class)abc_CollectionViewCellClass {
    return NSClassFromString(@"ABCCommonEntryCollectionViewCell");
}

@end
