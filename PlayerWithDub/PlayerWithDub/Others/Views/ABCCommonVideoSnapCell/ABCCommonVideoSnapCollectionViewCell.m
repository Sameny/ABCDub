//
//  ABCCommonVideoSnapCollectionViewCell.m
//  PlayerWithDub
//
//  Created by 泽泰 舒 on 2018/11/16.
//  Copyright © 2018年 泽泰 舒. All rights reserved.
//

#import "ABCCommonVideoSnapCollectionViewCell.h"

@implementation ABCCommonVideoSnapCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.titleLabel.textAlignment = NSTextAlignmentLeft;
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    // image view alignment center
    self.imageView.frame = CGRectMake(0, 0, self.width, 94);
    self.titleLabel.frame = CGRectMake(6, self.height - (self.height - 17 - 94)/2 - 17, self.width - 12, 17.f);
}

@end
