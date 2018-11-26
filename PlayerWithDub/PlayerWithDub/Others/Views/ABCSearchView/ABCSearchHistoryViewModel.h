//
//  ABCSearchHistoryViewModel.h
//  PlayerWithDub
//
//  Created by 舒泽泰 on 2018/11/23.
//  Copyright © 2018 泽泰 舒. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ABCSearchHistoryViewModel : NSObject

- (void)appendHistory:(NSString *)history;
- (NSSet <NSString *>*)searchHistoryData;
- (void)clearSearchHistoryData;

@end

NS_ASSUME_NONNULL_END
