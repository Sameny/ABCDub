//
//  ABCCommonCollectionView.h
//  PlayerWithDub
//
//  Created by 泽泰 舒 on 2018/11/15.
//  Copyright © 2018年 泽泰 舒. All rights reserved.
//

#import "ABCCommonCollectionViewCell.h"

NS_ASSUME_NONNULL_BEGIN

@interface ABCCommonCollectionView : UICollectionView

@property (nonatomic, assign) CGSize itemSize; // 如果为（0， y）每个cell是否平均分配行空间
@property (nonatomic, strong) Class cellClass; // default is ABCCommonCollectionViewCell, you can offer the subclass of ABCCommonCollectionViewCell

@property (nonatomic, copy) NSArray <__kindof ABCCommonCollectionViewItemData *>*data;

@end

NS_ASSUME_NONNULL_END
