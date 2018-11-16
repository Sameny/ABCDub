//
//  ABCCommonCollectionViewCell.h
//  PlayerWithDub
//
//  Created by 泽泰 舒 on 2018/11/15.
//  Copyright © 2018年 泽泰 舒. All rights reserved.
//

#import "ABCCommonCollectionViewItemData.h"
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ABCCommonCollectionViewCell : UICollectionViewCell

// user need set the frame or layout for imageView and titleLabel
@property (nonatomic, strong, readonly) UIImageView *imageView;
@property (nonatomic, strong, readonly) UILabel *titleLabel;

// can override
- (void)setCellWithImage:(UIImage *)image title:(NSString *)title;
// can override
- (void)setCellWithImageUrl:(NSString *)imageUrl title:(NSString *)title;
// can override
- (void)setCellWithCellItemData:(__kindof ABCCommonCollectionViewItemData *)itemData;

+ (NSString *)abc_reuseId;

@end

NS_ASSUME_NONNULL_END
