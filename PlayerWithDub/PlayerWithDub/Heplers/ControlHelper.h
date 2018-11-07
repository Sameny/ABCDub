//
//  ControlHelper.h
//  CommercialTreadmill
//
//  Created by cc on 16/9/21.
//  Copyright © 2016年 artiwares. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

@interface ControlHelper : NSObject

/*
 * button
 */
+ (UIBarButtonItem *)barButtonItemAddTarget:(id)target action:(SEL)action title:(NSString *)title titleColor:(UIColor *)titleColor;
+ (UIBarButtonItem *)resetBarButtonItemAddTarget:(id)target action:(SEL)action frame:(CGRect)rect image:(NSString *)imageName;
+ (UIButton *)baseButtonAddtarget:(id)target selector:(SEL)selector image:(NSString *)image imagePressed:(NSString *)imagePressed title:(NSString *)title font:(CGFloat)textFont textColor:(UIColor *)textColor textBold:(BOOL)isBold;

/*
 *label
 */
+ (UILabel *)getLabelWithTextColor:(UIColor *) color font:(UIFont *)font isbold:(BOOL) isbold;
+ (UILabel *)getLabelWithTextColor:(UIColor *) color TextFont:(CGFloat) font Isbold:(BOOL) isbold;
+ (UILabel *)getLabelWithTextColor:(UIColor *) color italicTextFont:(CGFloat) font;

#pragma mark - TextField
+ (UITextField *)textFieldWithKeyboardType:(UIKeyboardType)keyboardType returnKeyType:(UIReturnKeyType)returnKeyType placeholder:(NSString *)placeholder placeholderColor:(UIColor *)placeholderColor delegate:(id<UITextFieldDelegate>)delegate textColor:(UIColor *)textColor tintColor:(UIColor *)tintColor;

/*
 *line
 */
+ (UIView *)getLineView;

/*
 *iphoneType
 */
+ (NSString *)deviceVersion;

@end
