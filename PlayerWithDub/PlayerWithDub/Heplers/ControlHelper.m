//
//  ControlHelper.m
//  CommercialTreadmill
//
//  Created by cc on 16/9/21.
//  Copyright © 2016年 artiwares. All rights reserved.
//

#import "ControlHelper.h"
#import "sys/utsname.h"

@implementation ControlHelper

#pragma mark - Button

+ (UIBarButtonItem *)barButtonItemAddTarget:(id)target action:(SEL)action title:(NSString *)title titleColor:(UIColor *)titleColor{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setTitle:title forState:UIControlStateNormal];
    [btn setTitleColor:titleColor forState:UIControlStateNormal];
    [btn setBackgroundColor:[UIColor clearColor]];
    [btn addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    [btn sizeToFit];
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:btn];
    return item;
}

+ (UIBarButtonItem *)resetBarButtonItemAddTarget:(id)target action:(SEL)action frame:(CGRect)rect image:(NSString *)imageName{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setBackgroundImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
    [btn setFrame:rect];
    [btn setBackgroundColor:[UIColor clearColor]];
    [btn addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:btn];
    return item;
}

+ (UIButton *)baseButtonAddtarget:(id)target selector:(SEL)selector image:(NSString *)image imagePressed:(NSString *)imagePressed title:(NSString *)title font:(CGFloat)textFont textColor:(UIColor *)textColor textBold:(BOOL)isBold {
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    if (image) {
        [button setImage:ImageWithName(image) forState:UIControlStateNormal];
    }
    if (imagePressed){
        [button setImage:ImageWithName(imagePressed) forState:UIControlStateHighlighted];
    }
    if (title) {
        [button setTitle:title forState:UIControlStateNormal];
    }
    if (textColor) {
        [button setTitleColor:textColor forState:UIControlStateNormal];
    }
    if (textFont) {
        [button.titleLabel setFont:[UIFont systemFontOfSize:textFont]];
    }
    if (isBold) {
        [button.titleLabel setFont:[UIFont boldSystemFontOfSize:textFont]];
    }
    [button addTarget:target action:selector forControlEvents:UIControlEventTouchUpInside];
    return button;
}

#pragma mark - Label
+ (UILabel *)getLabelWithTextColor:(UIColor *) color TextFont:(CGFloat) font Isbold:(BOOL) isbold;
{
    UILabel *label = [UILabel new];
    [label setTextColor:color];
    isbold?[label setFont:[UIFont boldSystemFontOfSize:font]]:[label setFont:[UIFont systemFontOfSize:font]];
    return label;
}

+ (UILabel *)getLabelWithTextColor:(UIColor *) color font:(UIFont *)font isbold:(BOOL) isbold;
{
    UILabel *label = [UILabel new];
    [label setTextColor:color];
    [label setFont:font];
    return label;
}

+ (UILabel *)getLabelWithTextColor:(UIColor *) color italicTextFont:(CGFloat) font {
    UILabel *label = [UILabel new];
    [label setTextColor:color];
    [label setFont:[UIFont fontWithName:AWBOLD_ITALIC_FONT_COMMON_NAME size:font]];
    return label;
}

#pragma mark - TextField
+ (UITextField *)textFieldWithKeyboardType:(UIKeyboardType)keyboardType returnKeyType:(UIReturnKeyType)returnKeyType placeholder:(NSString *)placeholder placeholderColor:(UIColor *)placeholderColor delegate:(id<UITextFieldDelegate>)delegate textColor:(UIColor *)textColor tintColor:(UIColor *)tintColor  {
    UITextField *textField = [[UITextField alloc] init];
    textField.returnKeyType = returnKeyType;
    textField.keyboardType = keyboardType;
    if (placeholder) {
        textField.placeholder = placeholder;
    }
    if (placeholderColor) {
        [textField setValue:placeholderColor forKeyPath:@"_placeholderLabel.textColor"];
    }
    if (tintColor) {
        textField.tintColor = tintColor;
    }
    if (delegate) {
        textField.delegate = delegate;
    }
    if (textColor) {
        textField.textColor = textColor;
    }
    return textField;
}

#pragma mark - Line
+ (UIView *)getLineView {
    UIView *line = [[UIView alloc] init];
    line.backgroundColor = ABCCOMMON_SPLIT_LINE_COLOR;
    return line;
}

+ (NSString *)deviceVersion {
    struct utsname systemInfo;
    uname(&systemInfo);
    
    NSString *platform = [NSString stringWithCString:systemInfo.machine encoding:NSASCIIStringEncoding];
    
    if ([platform isEqualToString:@"iPhone1,1"]) return @"iPhone 2G";
    
    if ([platform isEqualToString:@"iPhone1,2"]) return @"iPhone 3G";
    
    if ([platform isEqualToString:@"iPhone2,1"]) return @"iPhone 3GS";
    
    if ([platform isEqualToString:@"iPhone3,1"]) return @"iPhone 4";
    
    if ([platform isEqualToString:@"iPhone3,2"]) return @"iPhone 4";
    
    if ([platform isEqualToString:@"iPhone3,3"]) return @"iPhone 4";
    
    if ([platform isEqualToString:@"iPhone4,1"]) return @"iPhone 4S";
    
    if ([platform isEqualToString:@"iPhone5,1"]) return @"iPhone 5";
    
    if ([platform isEqualToString:@"iPhone5,2"]) return @"iPhone 5";
    
    if ([platform isEqualToString:@"iPhone5,3"]) return @"iPhone 5c";
    
    if ([platform isEqualToString:@"iPhone5,4"]) return @"iPhone 5c";
    
    if ([platform isEqualToString:@"iPhone6,1"]) return @"iPhone 5s";
    
    if ([platform isEqualToString:@"iPhone6,2"]) return @"iPhone 5s";
    
    if ([platform isEqualToString:@"iPhone7,1"]) return @"iPhone 6 Plus";
    
    if ([platform isEqualToString:@"iPhone7,2"]) return @"iPhone 6";
    
    if ([platform isEqualToString:@"iPhone8,1"]) return @"iPhone 6s";
    
    if ([platform isEqualToString:@"iPhone8,2"]) return @"iPhone 6s Plus";
    
    if ([platform isEqualToString:@"iPhone8,4"]) return @"iPhone SE";
    
    if ([platform isEqualToString:@"iPhone9,1"]) return @"iPhone 7";
    
    if ([platform isEqualToString:@"iPhone9,2"]) return @"iPhone 7 Plus";
    
    if ([platform isEqualToString:@"iPod1,1"])   return @"iPod Touch 1G";
    
    if ([platform isEqualToString:@"iPod2,1"])   return @"iPod Touch 2G";
    
    if ([platform isEqualToString:@"iPod3,1"])   return @"iPod Touch 3G";
    
    if ([platform isEqualToString:@"iPod4,1"])   return @"iPod Touch 4G";
    
    if ([platform isEqualToString:@"iPod5,1"])   return @"iPod Touch 5G";
    
    if ([platform isEqualToString:@"iPad1,1"])   return @"iPad 1G";
    
    if ([platform isEqualToString:@"iPad2,1"])   return @"iPad 2";
    
    if ([platform isEqualToString:@"iPad2,2"])   return @"iPad 2";
    
    if ([platform isEqualToString:@"iPad2,3"])   return @"iPad 2";
    
    if ([platform isEqualToString:@"iPad2,4"])   return @"iPad 2";
    
    if ([platform isEqualToString:@"iPad2,5"])   return @"iPad Mini 1G";
    
    if ([platform isEqualToString:@"iPad2,6"])   return @"iPad Mini 1G";
    
    if ([platform isEqualToString:@"iPad2,7"])   return @"iPad Mini 1G";
    
    if ([platform isEqualToString:@"iPad3,1"])   return @"iPad 3";
    
    if ([platform isEqualToString:@"iPad3,2"])   return @"iPad 3";
    
    if ([platform isEqualToString:@"iPad3,3"])   return @"iPad 3";
    
    if ([platform isEqualToString:@"iPad3,4"])   return @"iPad 4";
    
    if ([platform isEqualToString:@"iPad3,5"])   return @"iPad 4";
    
    if ([platform isEqualToString:@"iPad3,6"])   return @"iPad 4";
    
    if ([platform isEqualToString:@"iPad4,1"])   return @"iPad Air";
    
    if ([platform isEqualToString:@"iPad4,2"])   return @"iPad Air";
    
    if ([platform isEqualToString:@"iPad4,3"])   return @"iPad Air";
    
    if ([platform isEqualToString:@"iPad4,4"])   return @"iPad Mini 2G";
    
    if ([platform isEqualToString:@"iPad4,5"])   return @"iPad Mini 2G";
    
    if ([platform isEqualToString:@"iPad4,6"])   return @"iPad Mini 2G";
    
    if ([platform isEqualToString:@"i386"])      return @"iPhone Simulator";
    
    if ([platform isEqualToString:@"x86_64"])    return @"iPhone Simulator";
    
    
    return platform;
}

@end
