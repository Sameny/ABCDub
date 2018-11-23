//
//  SZTPageControl.m
//  PlayerWithDub
//
//  Created by 泽泰 舒 on 2018/11/14.
//  Copyright © 2018年 泽泰 舒. All rights reserved.
//

#import "SZTPageControl.h"

@implementation SZTPageControl

- (void)setCurrentPage:(NSInteger)currentPage {
    [super setCurrentPage:currentPage];
    if (CGSizeEqualToSize(self.dotSize, CGSizeZero)) {
        self.dotSize = CGSizeMake(10, 10);
    }
    if (CGSizeEqualToSize(self.selectedDotSize, CGSizeZero)) {
        self.selectedDotSize = CGSizeMake(10, 10);
    }
    for (NSUInteger subviewIndex = 0; subviewIndex < [self.subviews count]; subviewIndex++) {
        UIImageView* subview = [self.subviews objectAtIndex:subviewIndex];
        CGSize oldSize = subview.bounds.size;
        CGSize size;
        if (subviewIndex == currentPage) {
            size = self.selectedDotSize;
        }
        else {
            size = self.dotSize;
        }
        [subview setFrame:CGRectMake(subview.frame.origin.x - (size.width - oldSize.width)/2, subview.frame.origin.y - (size.height - oldSize.height)/2, size.width,size.height)];
        subview.layer.cornerRadius = size.width/2;
    }
}

@end
