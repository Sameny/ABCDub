//
//  ABCMainViewModel.m
//  PlayerWithDub
//
//  Created by 泽泰 舒 on 2018/11/15.
//  Copyright © 2018年 泽泰 舒. All rights reserved.
//

#import "ABCMainDataModel.h"
#import "ABCMainViewModel.h"

@interface ABCMainViewModel ()

@property (nonatomic, strong) ABCMainDataModel *dataModel;
@property (nonatomic, strong) NSMutableDictionary <NSString *, NSNumber *>*itemHeights;

@end

@implementation ABCMainViewModel

- (void)configDataWithCompletion:(ABCSuccessHandler)completion {
    self.dataModel = [[ABCMainDataModel alloc] init];
    if (completion) {
        completion(YES);
    }
}

- (void)setDataModel:(ABCMainDataModel *)dataModel {
    _dataModel = dataModel;
    NSInteger index = 0;
    if (dataModel.entry_data.count > 0) {
        self.itemHeights[@(index).stringValue] = @(65.f);
        index++;
    }
    if (dataModel.today_update.count > 0) {
        self.itemHeights[@(index).stringValue] = @(272.f);
        index++;
    }
}

- (NSArray<NSString *> *)bannerUrls {
    return self.dataModel.banner_urls;
}

- (NSArray<ABCCommonCollectionViewItemData *> *)itemData {
    return self.dataModel.entry_data;
}

- (NSArray<ABCCommonCollectionViewItemData *> *)todayUpdateData {
    return self.dataModel.today_update;
}

- (NSInteger)numberOfSections {
    return self.itemHeights.count;
}

- (CGFloat)heightForSection:(NSInteger)section {
    return [self.itemHeights[@(section).stringValue] floatValue];
}

#pragma mark - lazy init
- (NSMutableDictionary <NSString *, NSNumber *>*)itemHeights {
    if (!_itemHeights) {
        _itemHeights = [[NSMutableDictionary alloc] init];
    }
    return _itemHeights;
}

@end
