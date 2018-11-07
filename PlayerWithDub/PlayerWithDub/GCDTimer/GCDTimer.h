//
//  GCDTimer.h
//  PlayerWithDub
//
//  Created by 泽泰 舒 on 2018/11/1.
//  Copyright © 2018年 泽泰 舒. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface GCDTimer : NSObject

@property (nonatomic, readonly) NSTimeInterval timeInterval;

- (instancetype)initWithQueue:(dispatch_queue_t)queue scheduleTimeInterval:(NSTimeInterval)interval block:(void(^)(void))block;

- (void)fire;
- (void)invalidate;

@end

NS_ASSUME_NONNULL_END

/*
 Dispatch Source Timer 是间隔定时器，也就是说每隔一段时间间隔定时器就会触发。在 NSTimer 中要做到同样的效果需要手动把 repeats 设置为 YES。
 dispatch_source_set_timer 中第二个参数，当我们使用dispatch_time 或者 DISPATCH_TIME_NOW 时，系统会使用默认时钟来进行计时。然而当系统休眠的时候，默认时钟是不走的，也就会导致计时器停止。使用 dispatch_walltime 可以让计时器按照真实时间间隔进行计时。
 dispatch_source_set_timer 的第四个参数 leeway 指的是一个期望的容忍时间，将它设置为 1 秒，意味着系统有可能在定时器时间到达的前 1 秒或者后 1 秒才真正触发定时器。在调用时推荐设置一个合理的 leeway 值。需要注意，就算指定 leeway 值为 0，系统也无法保证完全精确的触发时间，只是会尽可能满足这个需求。
 event handler block 中的代码会在指定的 queue 中执行。当 queue 是后台线程的时候，dispatch timer 相比 NSTimer 就好操作一些了。因为 NSTimer 是需要 Runloop 支持的，如果要在后台 dispatch queue 中使用，则需要手动添加 Runloop。使用 dispatch timer 就简单很多了。
 dispatch_source_set_event_handler 这个函数在执行完之后，block 会立马执行一遍，后面隔一定时间间隔再执行一次。而 NSTimer 第一次执行是到计时器触发之后。这也是和 NSTimer 之间的一个显著区别。

 停止 Timer
 
 停止 Dispatch Timer 有两种方法，一种是使用 dispatch_suspend，另外一种是使用 dispatch_source_cancel。
 
 dispatch_suspend 严格上只是把 Timer 暂时挂起，它和 dispatch_resume 是一个平衡调用，两者分别会减少和增加 dispatch 对象的挂起计数。当这个计数大于 0 的时候，Timer 就会执行。在挂起期间，产生的事件会积累起来，等到 resume 的时候会融合为一个事件发送。
 
 需要注意的是：dispatch source 并没有提供用于检测 source 本身的挂起计数的 API，也就是说外部不能得知一个 source 当前是不是挂起状态，在设计代码逻辑时需要考虑到这一点。
 
 dispatch_source_cancel 则是真正意义上的取消 Timer。被取消之后如果想再次执行 Timer，只能重新创建新的 Timer。这个过程类似于对 NSTimer 执行 invalidate。
 
 关于取消 Timer，另外一个很重要的注意事项：dispatch_suspend 之后的 Timer，是不能被释放的！下面的代码会引起崩溃：
 - (void)stopTimer
 {
     dispatch_suspend(_timer);
     _timer = nil; // EXC_BAD_INSTRUCTION 崩溃
 }
 
 因此使用 dispatch_suspend 时，Timer 本身的实例需要一直保持。使用 dispatch_source_cancel 则没有这个限制：
 
 - (void)stopTimer
 {
     dispatch_source_cancel(_timer);
     _timer = nil; // OK
 }
 */
