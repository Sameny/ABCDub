//
//  ABCCommonEntryCollectionViewCell.m
//  PlayerWithDub
//
//  Created by 泽泰 舒 on 2018/11/16.
//  Copyright © 2018年 泽泰 舒. All rights reserved.
//

#import "ABCCommonEntryCollectionViewCell.h"

@implementation ABCCommonEntryCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.titleLabel.textAlignment = NSTextAlignmentCenter;
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    // image view and title label alignment center
    CGFloat verticalSpace = (self.height - 44 - 8 - 17)/2;
    self.imageView.frame = CGRectMake((self.width - 44)/2, verticalSpace, 44, 44);
    self.titleLabel.frame = CGRectMake(0, self.height - verticalSpace - 17, self.width, 17.f);
}

@end
