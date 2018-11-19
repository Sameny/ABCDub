//
//  ABCCommonCollectionView.h
//  PlayerWithDub
//
//  Created by 泽泰 舒 on 2018/11/15.
//  Copyright © 2018年 泽泰 舒. All rights reserved.
//

#import "ABCCommonCollectionViewCell.h"

// 设置为该宽度时，宽度会自动分割
extern CGFloat const ABCCommonCollectionViewCellAutoDivideWidth;

NS_ASSUME_NONNULL_BEGIN

@interface ABCCommonCollectionView : UICollectionView

@property (nonatomic, strong) Class cellClass; // default is ABCCommonCollectionViewCell, you can offer the subclass of ABCCommonCollectionViewCel

@property (nonatomic, copy) NSArray <__kindof ABCCommonCollectionViewItemData *>*data;

@end

NS_ASSUME_NONNULL_END
