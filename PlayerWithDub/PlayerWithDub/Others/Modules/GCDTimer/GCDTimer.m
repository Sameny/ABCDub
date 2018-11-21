//
//  GCDTimer.m
//  PlayerWithDub
//
//  Created by 泽泰 舒 on 2018/11/1.
//  Copyright © 2018年 泽泰 舒. All rights reserved.
//

#import "GCDTimer.h"

@interface GCDTimer ()

@property (nonatomic, strong) dispatch_source_t gcdTimer;
@property (nonatomic, copy) void(^callback)(void);

@end

@implementation GCDTimer

- (instancetype)initWithQueue:(dispatch_queue_t)queue scheduleTimeInterval:(NSTimeInterval)interval block:(void(^)(void))block
{
    self = [super init];
    if (self) {
        _gcdTimer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
        _callback = block;
        _timeInterval = interval;
    }
    return self;
}

- (void)fire {
    dispatch_source_set_timer(_gcdTimer, DISPATCH_TIME_NOW, _timeInterval * NSEC_PER_SEC, 0.0 * NSEC_PER_SEC);
    dispatch_source_set_event_handler(_gcdTimer, ^{
        if (self.callback) {
            dispatch_async(dispatch_get_main_queue(), ^{
                self.callback();
            });
        }
    });
    dispatch_resume(_gcdTimer);
}

- (void)invalidate {
    dispatch_source_cancel(_gcdTimer);
    _gcdTimer = nil;
    if (self.callback) {
        self.callback = nil;
    }
}

@end
