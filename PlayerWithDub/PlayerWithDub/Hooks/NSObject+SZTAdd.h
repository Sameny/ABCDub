//
//  NSObject+SZTAdd.h
//  PlayerWithDub
//
//  Created by 泽泰 舒 on 2018/11/5.
//  Copyright © 2018年 泽泰 舒. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSObject (SZTAdd)

+ (BOOL)szt_swizzleInstanceMethod:(SEL)originalSelector with:(SEL)newSelector;
+ (BOOL)szt_swizzleClassMethod:(SEL)originalSelector with:(SEL)newSelector ;

@end

NS_ASSUME_NONNULL_END
