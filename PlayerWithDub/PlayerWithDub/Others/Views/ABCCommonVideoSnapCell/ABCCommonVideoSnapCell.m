//
//  ABCCommonVideoSnapCell.m
//  PlayerWithDub
//
//  Created by 泽泰 舒 on 2018/11/16.
//  Copyright © 2018年 泽泰 舒. All rights reserved.
//

#import "ABCCommonVideoSnapCell.h"

@implementation ABCCommonVideoSnapCell

- (UICollectionViewLayout *)abc_CollectionViewLayout {
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.scrollDirection = UICollectionViewScrollDirectionVertical;
    layout.minimumLineSpacing = 8;
    layout.minimumInteritemSpacing = 8;
    layout.sectionInset = UIEdgeInsetsMake(0, 8, 0, 8);
    layout.itemSize = CGSizeMake(175.f, 128.f);
    return layout;
}

- (Class)abc_CollectionViewCellClass {
    return NSClassFromString(@"ABCCommonVideoSnapCollectionViewCell");
}


@end
