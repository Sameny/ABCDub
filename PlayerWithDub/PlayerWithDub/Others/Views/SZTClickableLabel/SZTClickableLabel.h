//
//  SZTClickableLabel.h
//  PlayerWithDub
//
//  Created by 舒泽泰 on 2018/11/21.
//  Copyright © 2018 泽泰 舒. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class SZTClickableLabel;
@protocol SZTClickableLabelDelegate <NSObject>

- (void)clickableLabel:(SZTClickableLabel *)label didClickedAtWord:(NSString *)word;

@end

@interface SZTClickableLabel : UIView

@property (nonatomic, copy) NSArray <NSString *>*titles; // you can set 'titles' to show Chinese or English. The title property will be nil.

@property (nonatomic, copy) NSString *title; // now jush can shou English
@property (nonatomic, strong, readonly) NSString *clickedText;

@property (nonatomic, strong) UIFont *font;
@property (nonatomic, strong) UIColor *textColor;

@property (nonatomic, assign) CGFloat wordSpacing;
@property (nonatomic, assign) CGFloat lineSpacing;

@property (nonatomic, assign) CGFloat normalCornerRarius;
@property (nonatomic, assign) CGFloat clickedCornerRarius;

@property (nonatomic, readonly) CGSize contentSize;

@property (nonatomic, copy) NSDictionary <NSAttributedStringKey, id>*normalAttributes;
@property (nonatomic, copy) NSDictionary <NSAttributedStringKey, id>*clickedAttributes;

@property (nonatomic, assign) BOOL clickable; // default is YES
@property (nonatomic, weak) id<SZTClickableLabelDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
