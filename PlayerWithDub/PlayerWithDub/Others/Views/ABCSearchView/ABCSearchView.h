//
//  ABCSearchView.h
//  PlayerWithDub
//
//  Created by 泽泰 舒 on 2018/11/19.
//  Copyright © 2018年 泽泰 舒. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ABCSearchViewDelegate <NSObject>

@required
- (void)fetchResultWithSearchKey:(NSString *)key;

@optional
- (void)userDidBeginEditingSearchKey;
- (void)userInputKeyDidChange:(NSString *)key;
- (void)userDidCancelEditingSearchKey;

@end

NS_ASSUME_NONNULL_BEGIN

@interface ABCSearchView : UIView

@property (nonatomic, copy) NSString *keyWord;
@property (nonatomic, weak) id<ABCSearchViewDelegate> delegate;

- (void)reset;

@end

NS_ASSUME_NONNULL_END
