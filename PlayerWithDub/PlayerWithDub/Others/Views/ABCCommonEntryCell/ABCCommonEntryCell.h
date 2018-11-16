//
//  ABCCommonEntryCell.h
//  PlayerWithDub
//
//  Created by 泽泰 舒 on 2018/11/16.
//  Copyright © 2018年 泽泰 舒. All rights reserved.
//

#import "ABCCommonCollectionViewCell.h"
#import "SZTTableViewCell.h"

NS_ASSUME_NONNULL_BEGIN

@interface ABCCommonEntryCell : UITableViewCell

@property (nonatomic, copy) void(^selectedHandler)(NSInteger index);

@property (nonatomic, copy) NSArray <ABCCommonCollectionViewItemData *>*data;
@property (nonatomic, strong) UIFont *itemTitleFont;

@end

NS_ASSUME_NONNULL_END
