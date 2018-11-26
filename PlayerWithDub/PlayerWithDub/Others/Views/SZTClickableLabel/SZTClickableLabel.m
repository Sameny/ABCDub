//
//  SZTClickableLabel.m
//  PlayerWithDub
//
//  Created by 舒泽泰 on 2018/11/21.
//  Copyright © 2018 泽泰 舒. All rights reserved.
//

#import "SZTClickableLabel.h"

BOOL canTouchWithCharacter(char c) {
    if ('a' <= c && c <= 'z') {
        return YES;
    }
    else if ('A' <= c && c <= 'Z') {
        return YES;
    }
    return c == '-' || c == '\'';
}

BOOL canTouchWithText(NSString *text) {
    if (text.length == 1) {
        const char *c = text.UTF8String;
        return canTouchWithCharacter(c[0]);
    }
    return text.length > 1;
}

@interface SZTClickableLabel ()

@property (nonatomic, strong) NSArray <NSString *>*seperateTitles;
@property (nonatomic, strong) NSArray <NSValue *>*textFrames;

@property (nonatomic, assign) NSInteger clickedIndex;
@property (nonatomic, assign) NSInteger lastClickedIndex;
@property (nonatomic, copy) NSMutableDictionary <NSAttributedStringKey, id>*internalNormalAttributes;
@property (nonatomic, strong) NSMutableDictionary <NSAttributedStringKey, id>*internelClickedAttributes;

@end

@implementation SZTClickableLabel

#define kSZTClickableLabelContentInsets UIEdgeInsetsMake(5.f, 8, 5.f, 8)
#define kSZTClickableTextContentInsets UIEdgeInsetsMake(1, 3, 1, 3)
static NSInteger kSZTClickableUnSelectedIndex = -1;
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor]; // 设置为其他颜色时，上方某些情况下会出现一条黑线，原因暂未知
        _clickedIndex = kSZTClickableUnSelectedIndex;
        _lastClickedIndex = kSZTClickableUnSelectedIndex;
        _font = [UIFont systemFontOfSize:[UIFont labelFontSize]];
        _textColor = [UIColor blackColor];
        _wordSpacing = 4.f;
        _lineSpacing = 4.f;
        _normalCornerRarius = 0.f;
        _clickedCornerRarius = 0.f;
        _clickable = YES;
        
        _internalNormalAttributes = @{NSFontAttributeName:_font, NSForegroundColorAttributeName:_textColor}.mutableCopy;
        _internelClickedAttributes = @{NSForegroundColorAttributeName:[UIColor whiteColor],
                                       NSBackgroundColorAttributeName:[UIColor greenColor],
                                       NSFontAttributeName:[UIFont systemFontOfSize:[UIFont labelFontSize]]
                                       }.mutableCopy;
    }
    return self;
}

- (void)setTitles:(NSArray<NSString *> *)titles {
    if (![_seperateTitles isEqualToArray:titles]) {
        _seperateTitles = [titles mutableCopy];
        [self setNeedsDisplay];
    }
}

- (NSArray<NSString *> *)titles {
    return [_seperateTitles mutableCopy];
}

- (void)setTitle:(NSString *)title {
    if (![_title isEqualToString:title]) {
        _title = title;
        self.seperateTitles = [SZTClickableLabel seperateText:title];
        [self setNeedsDisplay];
    }
}

- (void)setFont:(UIFont *)font {
    if ([_font isEqual:font]) {
        _font = font;
        [_internalNormalAttributes setObject:font forKey:NSFontAttributeName];
        [self updateTextLayers];
    }
}

- (void)setTextColor:(UIColor *)textColor {
    if (![_textColor isEqual:textColor]) {
        _textColor = textColor;
        
        [_internalNormalAttributes setObject:textColor forKey:NSForegroundColorAttributeName];
        [self updateTextLayers];
    }
}

- (void)setWordSpacing:(CGFloat)wordSpacing {
    if (_wordSpacing != wordSpacing) {
        _wordSpacing = wordSpacing;
        [self updateTextLayers];
    }
}

- (void)setLineSpacing:(CGFloat)lineSpacing {
    if (_lineSpacing != lineSpacing) {
        _lineSpacing = lineSpacing;
        [self updateTextLayers];
    }
}

- (void)setNormalCornerRarius:(CGFloat)normalCornerRarius {
    if (_normalCornerRarius != normalCornerRarius) {
        _normalCornerRarius = normalCornerRarius;
        [self updateTextLayers];
    }
}

- (void)setClickedCornerRarius:(CGFloat)clickedCornerRarius {
    if (_clickedCornerRarius != clickedCornerRarius) {
        _clickedCornerRarius = clickedCornerRarius;
        [self updateClickedText];
    }
}

- (void)setNormalAttributes:(NSDictionary<NSAttributedStringKey,id> *)normalAttributes {
    if (![_internalNormalAttributes isEqualToDictionary:normalAttributes]) {
        [_internalNormalAttributes addEntriesFromDictionary:normalAttributes];
        [self updateTextLayers];
    }
}

- (void)setClickedAttributes:(NSDictionary<NSAttributedStringKey,id> *)clickedAttributes {
    if (![_internelClickedAttributes isEqualToDictionary:clickedAttributes]) {
        [_internelClickedAttributes addEntriesFromDictionary:clickedAttributes];
        [self updateClickedText];
    }
}

- (NSDictionary<NSAttributedStringKey,id> *)clickedAttributes {
    return [_internelClickedAttributes copy];
}

- (NSDictionary<NSAttributedStringKey,id> *)normalAttributes {
    return [_internalNormalAttributes copy];
}

- (void)updateTextLayers {
    if (self.seperateTitles.count > 0 && !CGRectEqualToRect(self.frame, CGRectZero)) {
        [self setNeedsDisplay];
    }
}

- (void)updateClickedText {
    if (self.seperateTitles.count > 0 && self.clickedIndex < self.textFrames.count) {
        if (self.clickedIndex > kSZTClickableUnSelectedIndex) {
            CGRect clickedFrame = [self.textFrames[self.clickedIndex] CGRectValue];
            [self setNeedsDisplayInRect:clickedFrame];
        }
    }
}

#pragma mark - draw
- (void)drawRect:(CGRect)rect {
    NSMutableArray <NSValue *>*textFrames = [[NSMutableArray alloc] init];
    CGPoint location = CGPointMake(kSZTClickableLabelContentInsets.left, kSZTClickableLabelContentInsets.top);
    for (NSInteger i = 0; i < self.seperateTitles.count; i++) {
        NSString *string = self.seperateTitles[i];
        
        CGRect frame = [self drawTextWithString:string index:i location:location];
        location = CGPointMake(frame.origin.x + frame.size.width, frame.origin.y);
        [textFrames addObject:[NSValue valueWithCGRect:frame]];
    }
    CGFloat layerHeight = _font.lineHeight + kSZTClickableTextContentInsets.top + kSZTClickableTextContentInsets.bottom;
    _contentSize = CGSizeMake(self.bounds.size.width, location.y + kSZTClickableLabelContentInsets.bottom + layerHeight);
    self.textFrames = [textFrames copy];
}

- (CGSize)adjustContentSizeWithTitles:(NSArray <NSString *>*)titles {
    CGPoint location = CGPointMake(kSZTClickableLabelContentInsets.left, kSZTClickableLabelContentInsets.top);
    for (NSInteger i = 0; i < titles.count; i++) {
        NSString *string = titles[i];
        
        CGRect frame = [self containerFrameWithString:string index:i location:location];
        location = CGPointMake(frame.origin.x + frame.size.width, frame.origin.y);
    }
    CGFloat layerHeight = _font.lineHeight + kSZTClickableTextContentInsets.top + kSZTClickableTextContentInsets.bottom;
    CGSize contentSize = CGSizeMake(self.bounds.size.width, location.y + kSZTClickableLabelContentInsets.bottom + layerHeight);
    return contentSize;
}

- (void)szt_sizeToFit {
    CGSize contentSize = [self adjustContentSizeWithTitles:self.seperateTitles];
    self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, contentSize.width, contentSize.height);
}

- (CGRect)containerFrameWithString:(NSString *)string index:(NSUInteger)index location:(CGPoint)location {
    UIFont *font = self.font;
    if ([_internelClickedAttributes containsObjectForKey:NSFontAttributeName] && _clickedIndex == index) {
        font = _internelClickedAttributes[NSFontAttributeName];
    }
    CGRect containerFrame = [self containerFrameWithString:string index:index font:font location:location];
    return containerFrame;
}

- (CGRect)drawTextWithString:(NSString *)string index:(NSUInteger)index location:(CGPoint)location {
    CGRect containerFrame = [self containerFrameWithString:string index:index location:location];
    
    CGRect textFrame = [self textRectWithContainerRect:containerFrame];
    
    if (_clickedIndex == index) {
        NSMutableDictionary <NSAttributedStringKey,id>*clickedAttributes = _internelClickedAttributes.mutableCopy;
        // 画背景 可以设置圆角
        if ([clickedAttributes containsObjectForKey:NSBackgroundColorAttributeName]) {
            UIColor *backColor = clickedAttributes[NSBackgroundColorAttributeName];
            [[[UIImage imageWithColor:backColor size:containerFrame.size] imageByRoundCornerRadius:_clickedCornerRarius] drawInRect:containerFrame];
            [clickedAttributes removeObjectForKey:NSBackgroundColorAttributeName];
        }
        [string drawInRect:textFrame withAttributes:clickedAttributes];
    }
    else {
        NSMutableDictionary <NSAttributedStringKey,id>*normalAttributes = _internalNormalAttributes.mutableCopy;
        // 画背景 可以设置圆角
        if ([normalAttributes containsObjectForKey:NSBackgroundColorAttributeName]) {
            UIColor *backColor = normalAttributes[NSBackgroundColorAttributeName];
            [[[UIImage imageWithColor:backColor size:containerFrame.size] imageByRoundCornerRadius:_normalCornerRarius] drawInRect:containerFrame];
            [normalAttributes removeObjectForKey:NSBackgroundColorAttributeName];
        }
        [string drawInRect:textFrame withAttributes:_internalNormalAttributes];
    }
    return containerFrame;
}

- (CGRect)containerFrameWithString:(NSString *)string index:(NSUInteger)index font:(UIFont *)font location:(CGPoint)location {
    CGFloat layerHeight = _font.lineHeight + kSZTClickableTextContentInsets.top + kSZTClickableTextContentInsets.bottom;
    CGFloat layerWidth = [string boundingRectWithSize:CGSizeMake(self.bounds.size.width, layerHeight) options:(NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading|NSStringDrawingTruncatesLastVisibleLine) attributes:@{NSFontAttributeName:font} context:nil].size.width + kSZTClickableTextContentInsets.left + kSZTClickableTextContentInsets.right;
    CGFloat wordSpace = (canTouchWithText(string)?_wordSpacing:0);
    if (index == 0) {
        wordSpace = 0;
    }
    CGFloat layerX = location.x + wordSpace;
    CGFloat layerY = location.y;
    if (layerX + layerWidth + kSZTClickableLabelContentInsets.right > self.bounds.size.width) { // 超出当前行
        layerX = kSZTClickableLabelContentInsets.left;
        layerY += layerHeight + _lineSpacing;
    }
    return CGRectMake(layerX, layerY, layerWidth, layerHeight);
}

- (CGRect)textRectWithContainerRect:(CGRect)containerRect {
    return CGRectMake(containerRect.origin.x + kSZTClickableTextContentInsets.left, containerRect.origin.y + kSZTClickableTextContentInsets.top, containerRect.size.width - kSZTClickableTextContentInsets.left - kSZTClickableTextContentInsets.right, _font.lineHeight);
}

#pragma mark - lazy init
- (NSArray<NSValue *> *)textFrames {
    if (!_textFrames) {
        _textFrames = [[NSMutableArray alloc] init];
    }
    return _textFrames;
}

#pragma mark - touch
- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    if (_clickable) {
        UITouch *touch = [touches anyObject];
        CGPoint point = [touch locationInView:self];
        __block NSInteger index = kSZTClickableUnSelectedIndex;
        __block CGRect clickedFrame = CGRectZero;
        [self.textFrames enumerateObjectsUsingBlock:^(NSValue * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            CGRect frame = [obj CGRectValue];
            if (CGRectContainsPoint(frame, point)) {
                clickedFrame = frame;
                index = idx;
                *stop = YES;
            }
        }];
        if (index > kSZTClickableUnSelectedIndex) {
            NSString *string = self.seperateTitles[index];
            if (!canTouchWithText(string)) {
                return;
            }
            if (self.clickedIndex > kSZTClickableUnSelectedIndex) {
                self.lastClickedIndex = self.clickedIndex;
                // 这种方式清除会有残留，目前选择setNeedsDisplay全部清除重绘
                CGRect lastClickedFrame = [self.textFrames[self.lastClickedIndex] CGRectValue];
                [self setNeedsDisplayInRect:lastClickedFrame];
            }
            self.clickedIndex = index;
            [self setNeedsDisplayInRect:clickedFrame];
            //        [self setNeedsDisplay];
            if (_delegate && [_delegate respondsToSelector:@selector(clickableLabel:didClickedAtWord:)]) {
                [_delegate clickableLabel:self didClickedAtWord:string];
            }
        }
    }
    else {
        [super touchesEnded:touches withEvent:event];
    }
}

+ (NSArray <NSString *>*)seperateText:(NSString *)text {
    NSMutableArray <NSString *>*result = [[NSMutableArray alloc] init];
    if (text.length > 0) {
        const char *utf8 = text.UTF8String;
        char word[30];
        for (NSInteger i = 0; i < strlen(utf8); i++) {
            char c = utf8[i];
            if (canTouchWithCharacter(c)) {
                word[strlen(word)] = c;
            }
            else {
                if (strlen(word) > 0) {
                    NSString *wordString = [NSString stringWithUTF8String:word];
                    if (wordString) {
                        [result addObject:wordString];
                    }
                    memset(word, 0, 30);
                }
                if (c == ' ') {
                    continue;
                }
                char syms[1];
                syms[0] = c;
                NSString *symbol = [NSString stringWithUTF8String:syms];
                if (symbol && ![symbol isEqualToString:@""]) {
                    [result addObject:symbol];
                }
            }
        }
    }
    return [result copy];
}

@end
