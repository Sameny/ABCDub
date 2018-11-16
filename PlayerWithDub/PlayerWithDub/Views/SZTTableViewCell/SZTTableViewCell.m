//
//  SZTTableViewCell.m
//  PlayerWithDub
//
//  Created by 泽泰 舒 on 2018/11/16.
//  Copyright © 2018年 泽泰 舒. All rights reserved.
//

#import "SZTTableViewCell.h"

@implementation SZTTableViewCell

- (instancetype)initWithFrame:(CGRect)frame
{
    if (frame.size.width == 320) {
        frame = CGRectMake(frame.origin.x, frame.origin.y, SCREEN_WIDTH, frame.size.height);
    }
    self = [super initWithFrame:frame];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.accessoryType = UITableViewCellAccessoryNone;
    }
    return self;
}
@end
