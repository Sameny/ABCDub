//
//  ABCSearchHistoryViewModel.m
//  PlayerWithDub
//
//  Created by 舒泽泰 on 2018/11/23.
//  Copyright © 2018 泽泰 舒. All rights reserved.
//

#import "ABCSearchHistoryViewModel.h"

static NSString *kABCSearchHistoryDataKey = @"search_history_data_key";

@interface ABCSearchHistoryViewModel ()

@property (nonatomic, strong) NSMutableSet <NSString *>*searchHistoryData;

@end

@implementation ABCSearchHistoryViewModel

- (instancetype)init {
    self = [super init];
    if (self) {
        _searchHistoryData = [ABCSearchHistoryViewModel searchHistoryData].mutableCopy;
    }
    return self;
}

- (void)appendHistory:(NSString *)history {
    if (![_searchHistoryData containsObject:history]) {
        [_searchHistoryData addObject:history];
        [ABCSearchHistoryViewModel synSearchHistoryData:_searchHistoryData.copy];
    }
}

- (NSSet <NSString *>*)searchHistoryData {
    return [_searchHistoryData copy];
}

- (void)clearSearchHistoryData {
    [_searchHistoryData removeAllObjects];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:kABCSearchHistoryDataKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (void)synSearchHistoryData:(NSSet <NSString *>*)data {
    [[NSUserDefaults standardUserDefaults] setObject:data.allObjects forKey:kABCSearchHistoryDataKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (NSSet <NSString *>*)searchHistoryData {
    NSArray <NSString *>*history = [[NSUserDefaults standardUserDefaults] objectForKey:kABCSearchHistoryDataKey];
    return history?[NSSet setWithArray:history]:[NSSet set];
}

@end
