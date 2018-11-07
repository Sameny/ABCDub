//
//  NSObject+SZTAdd.m
//  PlayerWithDub
//
//  Created by 泽泰 舒 on 2018/11/5.
//  Copyright © 2018年 泽泰 舒. All rights reserved.
//

#import <objc/runtime.h>
#import "NSObject+SZTAdd.h"

@implementation NSObject (SZTAdd)

+ (BOOL)szt_swizzleInstanceMethod:(SEL)originalSelector with:(SEL)newSelector {
    Method originalMethod = class_getInstanceMethod(self, originalSelector);
    Method newMethod = class_getInstanceMethod(self, newSelector);
    if (!originalMethod || !newMethod) {
        return NO;
    }
    
    class_addMethod(self, originalSelector, class_getMethodImplementation(self, originalSelector), method_getTypeEncoding(originalMethod));
    class_addMethod(self, newSelector, class_getMethodImplementation(self, newSelector), method_getTypeEncoding(newMethod));
    method_exchangeImplementations(originalMethod, newMethod);
    return YES;
}

+ (BOOL)szt_swizzleClassMethod:(SEL)originalSelector with:(SEL)newSelector {
    Class class = object_getClass(self); // 获取self的isa
    Method originalMethod = class_getInstanceMethod(class, originalSelector);
    Method newMethod = class_getInstanceMethod(class, newSelector);
    if (!originalMethod || !newMethod) {
        return NO;
    }
    method_exchangeImplementations(originalMethod, newMethod);
    return YES;
}

@end
