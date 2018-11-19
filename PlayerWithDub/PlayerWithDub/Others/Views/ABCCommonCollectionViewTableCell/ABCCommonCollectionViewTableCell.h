//
//  ABCCommonCollectionViewTableCell.h
//  PlayerWithDub
//
//  Created by 泽泰 舒 on 2018/11/16.
//  Copyright © 2018年 泽泰 舒. All rights reserved.
//

#import "ABCCommonCollectionViewItemData.h"
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ABCCommonCollectionViewTableCell : UITableViewCell

@property (nonatomic, copy) void(^selectedHandler)(NSInteger index);

@property (nonatomic, copy) NSArray <ABCCommonCollectionViewItemData *>*data;

// subclass can override all two methods to custom you collection view
- (UICollectionViewLayout *)abc_CollectionViewLayout;
- (Class)abc_CollectionViewCellClass;

@end

NS_ASSUME_NONNULL_END
