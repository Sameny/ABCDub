//
//  NSArray+YYModelAdd.m
//  PlayerWithDub
//
//  Created by 泽泰 舒 on 2018/11/19.
//  Copyright © 2018年 泽泰 舒. All rights reserved.
//

#import "NSArray+YYModelAdd.h"

@implementation NSArray (YYModelAdd)

- (NSArray *)arrayOfClass:(Class)aClass {
    NSMutableArray *ma = @[].mutableCopy;
    for (NSDictionary *dict in self) {
        if ([dict isKindOfClass:[NSDictionary class]]) {
            id obj = [aClass yy_modelWithDictionary:dict];
            if (obj) {
                [ma addObject:obj];
            }
        } else if ([dict isKindOfClass:aClass]) {
            [ma addObject:dict];
        }
    }
    if (ma.count == 0) {
        ma = nil;
    }
    return ma;
}

- (NSArray *)arrayToDict:(Class) aClass {
    NSMutableArray *ma = @[].mutableCopy;
    
    for (id model in self) {
        if ([model isKindOfClass:aClass]) {
            NSDictionary *dict = [model yy_modelToJSONObject];
            if (dict) {
                [ma addObject:dict];
            }
        }
        else if([model isKindOfClass:[NSDictionary class]]) {
            [ma addObject:model];
        }
    }
    
    if (ma.count == 0) {
        return nil;
    }
    return ma;
}

@end
