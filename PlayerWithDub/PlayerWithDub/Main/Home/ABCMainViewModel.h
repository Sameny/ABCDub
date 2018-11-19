//
//  ABCMainViewModel.h
//  PlayerWithDub
//
//  Created by 泽泰 舒 on 2018/11/15.
//  Copyright © 2018年 泽泰 舒. All rights reserved.
//

#import "ABCCommonCollectionViewItemData.h"
#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ABCMainViewModel : NSObject

@property (nonatomic, readonly) NSArray <NSString *>* bannerUrls;
@property (nonatomic, readonly) NSArray <ABCCommonCollectionViewItemData *>*itemData;
@property (nonatomic, readonly) NSArray <ABCCommonCollectionViewItemData *>*todayUpdateData;

- (void)configDataWithCompletion:(ABCSuccessHandler)completion;
- (NSInteger)numberOfSections;
- (CGFloat)heightForSection:(NSInteger)section;

@end

NS_ASSUME_NONNULL_END
