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

@property (nonatomic, copy) NSString *title;
@property (nonatomic, strong, readonly) NSString *clickedText;

@property (nonatomic, strong) UIFont *font;
@property (nonatomic, strong) UIColor *textColor;

@property (nonatomic, assign) CGFloat wordSpacing;
@property (nonatomic, assign) CGFloat lineSpacing;

@property (nonatomic, copy) NSDictionary <NSAttributedStringKey, id>*clickedAttributes;

@property (nonatomic, weak) id<SZTClickableLabelDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
