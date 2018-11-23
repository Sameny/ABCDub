//
//  SZTWaveAnimationView.m
//  PlayerWithDub
//
//  Created by 舒泽泰 on 2018/11/23.
//  Copyright © 2018 泽泰 舒. All rights reserved.
//

#import "SZTWaveAnimationView.h"

@interface SZTWaveAnimationView ()

@end

@implementation SZTWaveAnimationView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        _amplitude = 0.5;
        _cycle = 1.0;
        _offset = CGPointMake(0, 0);
    }
    return self;
}

@end
