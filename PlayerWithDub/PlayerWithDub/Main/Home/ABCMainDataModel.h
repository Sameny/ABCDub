//
//  ABCMainDataModel.h
//  PlayerWithDub
//
//  Created by 泽泰 舒 on 2018/11/16.
//  Copyright © 2018年 泽泰 舒. All rights reserved.
//

#import "ABCCommonCollectionViewItemData.h"

NS_ASSUME_NONNULL_BEGIN

@interface ABCMainDataModel : NSObject

@property (nonatomic, strong) NSArray <NSString *>* banner_urls;
@property (nonatomic, strong) NSArray <ABCCommonCollectionViewItemData *>*entry_data;
@property (nonatomic, strong) NSArray <ABCCommonCollectionViewItemData *>*today_update;


@end

NS_ASSUME_NONNULL_END
