//
//  NSNumber+STAdd.m
//  Treadmill
//
//  Created by 泽泰 舒 on 2017/12/7.
//  Copyright © 2017年 artiwares. All rights reserved.
//

#import "NSNumber+STAdd.h"

@implementation NSNumber (STAdd)

- (NSString *)stringWithNumberOfDigit:(NSInteger)digitNum formatStyle:(NSNumberFormatterStyle)formatStyle {
    NSNumberFormatter *numFormat = [[NSNumberFormatter alloc] init];
    numFormat.numberStyle = formatStyle;
    numFormat.maximumFractionDigits = digitNum;
    numFormat.minimumFractionDigits = digitNum;
    return [numFormat stringFromNumber:self];
}

@end
