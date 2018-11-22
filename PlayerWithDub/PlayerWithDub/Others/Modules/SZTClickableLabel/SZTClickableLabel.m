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
@property (nonatomic, strong) NSMutableDictionary <NSAttributedStringKey, id>*internelClickedAttributes;

@end

@implementation SZTClickableLabel

#define kSZTClickableLabelContentInsets UIEdgeInsetsMake(5.f, 10, 5.f, 10)
#define kSZTClickableTextContentInsets UIEdgeInsetsMake(1, 3, 1, 3)
static NSInteger kSZTClickableUnSelectedIndex = -1;
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        _clickedIndex = kSZTClickableUnSelectedIndex;
        _lastClickedIndex = kSZTClickableUnSelectedIndex;
        _font = [UIFont systemFontOfSize:[UIFont labelFontSize]];
        _textColor = [UIColor blackColor];
        _wordSpacing = 4.f;
        _lineSpacing = 4.f;
        
        _internelClickedAttributes = @{NSForegroundColorAttributeName:[UIColor whiteColor],
                                       NSBackgroundColorAttributeName:[UIColor greenColor],
                                       NSFontAttributeName:[UIFont systemFontOfSize:[UIFont labelFontSize]]
                                       }.mutableCopy;
    }
    return self;
}

- (void)setTitle:(NSString *)title {
    if (![_title isEqualToString:title]) {
        _title = title;
        self.seperateTitles = [SZTClickableLabel seperateText:title];
        [self updateTextLayers];
    }
}

- (void)setFont:(UIFont *)font {
    if ([_font isEqual:font]) {
        _font = font;
        [self updateTextLayers];
    }
}

- (void)setTextColor:(UIColor *)textColor {
    if (![_textColor isEqual:textColor]) {
        _textColor = textColor;
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

- (void)setClickedAttributes:(NSDictionary<NSAttributedStringKey,id> *)clickedAttributes {
    if ([_internelClickedAttributes isEqualToDictionary:clickedAttributes]) {
        [_internelClickedAttributes addEntriesFromDictionary:clickedAttributes];
        [self updateTextLayers];
    }
}

- (NSDictionary<NSAttributedStringKey,id> *)clickedAttributes {
    return [_internelClickedAttributes copy];
}

- (void)updateTextLayers {
    if (self.seperateTitles.count > 0 && !CGRectEqualToRect(self.frame, CGRectZero)) {
        [self setNeedsDisplay];
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
    self.textFrames = [textFrames copy];
}

- (CGRect)drawTextWithString:(NSString *)string index:(NSUInteger)index location:(CGPoint)location {
    UIFont *font = self.font;
    if ([_internelClickedAttributes containsObjectForKey:NSFontAttributeName] && _clickedIndex == index) {
        font = _internelClickedAttributes[NSFontAttributeName];
    }
    CGRect containerFrame = [self containerFrameWithString:string index:index font:font location:location];
    
    CGRect textFrame = [self textRectWithContainerRect:containerFrame];
    
    if (_clickedIndex == index) {
        // 可以设置圆角
        NSMutableDictionary <NSAttributedStringKey,id>*clickedAttributes = _internelClickedAttributes.mutableCopy;
        if ([clickedAttributes containsObjectForKey:NSBackgroundColorAttributeName]) {
            UIColor *backColor = clickedAttributes[NSBackgroundColorAttributeName];
            [[[UIImage imageWithColor:backColor size:containerFrame.size] imageByRoundCornerRadius:5.f] drawInRect:containerFrame];
            [clickedAttributes removeObjectForKey:NSBackgroundColorAttributeName];
        }
        [string drawInRect:textFrame withAttributes:clickedAttributes];
    }
    else {
        [string drawInRect:textFrame withAttributes:[self defaultAttributes]];
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
        layerY += layerHeight + _wordSpacing;
    }
    return CGRectMake(layerX, layerY, layerWidth, layerHeight);
}

- (CGRect)textRectWithContainerRect:(CGRect)containerRect {
    return CGRectMake(containerRect.origin.x + kSZTClickableTextContentInsets.left, containerRect.origin.y + kSZTClickableTextContentInsets.top, containerRect.size.width - kSZTClickableTextContentInsets.left - kSZTClickableTextContentInsets.right, _font.lineHeight);
}

- (NSDictionary <NSAttributedStringKey, id>*)defaultAttributes {
    return @{NSFontAttributeName:self.font, NSForegroundColorAttributeName:self.textColor};
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
