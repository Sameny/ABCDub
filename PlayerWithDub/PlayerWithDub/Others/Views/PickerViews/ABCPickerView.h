//
//  SZTPickerView.h
//  PlayerWithDub
//
//  Created by 舒泽泰 on 2018/11/26.
//  Copyright © 2018 泽泰 舒. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ABCPickerViewDelegate <NSObject>

- (void)didSelectedAtView:(UIView *)selectedView fromView:(UIView *)fromView;
- (void)didSelectedAtRow:(NSInteger)row component:(NSInteger)component title:(NSString *)title;

@end

NS_ASSUME_NONNULL_BEGIN

@interface ABCPickerView : UIView

@property (nonatomic, copy) CGSize(^itemSize)(NSInteger component);
@property (nonatomic, copy) UIView *(^itemView)(NSInteger row, NSInteger component, NSString *title, UIView *reusingView);

@property (nonatomic, copy) NSArray *dataSource; // NSArray <NSString *> or NSArray <NSArray <NSString *>*>
@property (nonatomic, readonly) NSIndexPath *selectedIndexPath;
@property (nonatomic, weak) id<ABCPickerViewDelegate> delegate;

+ (instancetype)showPickerViewOnView:(nullable UIView *)onView;
- (void)showOnView:(UIView *)onView;

@end

NS_ASSUME_NONNULL_END
