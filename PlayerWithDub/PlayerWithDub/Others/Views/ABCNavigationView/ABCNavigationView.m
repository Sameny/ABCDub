//
//  ABCNavigationView.m
//  PlayerWithDub
//
//  Created by 舒泽泰 on 2018/11/27.
//  Copyright © 2018 泽泰 舒. All rights reserved.
//

#import "ABCNavigationView.h"

@interface ABCNavigationView ()

@property (nonatomic, strong) UIImageView *backImageView;
@property (nonatomic, strong) UIButton *leftBtn;
@property (nonatomic, strong) UIButton *rightBtn;
@property (nonatomic, strong) UIView *titleView;
@property (nonatomic, strong) UILabel *titleLabel;

@end

@implementation ABCNavigationView

#define kABCNavigationViewFrame CGRectMake(0, 0, SCREEN_WIDTH, SZT_NAVIGATIONBAR_HEIGHT)
- (instancetype)initWithFrame:(CGRect)frame {
    if (CGRectEqualToRect(kABCNavigationViewFrame, frame)) {
        frame = kABCNavigationViewFrame;
    }
    self = [super initWithFrame:frame];
    if (self) {
        [self configUI];
    }
    return self;
}

- (void)leftNavigationButtonDidClicked {
    if (_delegate && [_delegate respondsToSelector:@selector(leftNavigationButtonDidClicked)]) {
        [_delegate leftNavigationButtonDidClicked];
    }
}

- (void)rightNavigationButtonDidClicked {
    if (_delegate && [_delegate respondsToSelector:@selector(rightNavigationButtonDidClicked)]) {
        [_delegate rightNavigationButtonDidClicked];
    }
}

#pragma mark - setter & getter
- (void)setTitle:(NSString *)title {
    if (!self.titleLabel) {
        [self addSubview:self.titleView];
    }
    self.titleLabel.text = title;
    [self.titleLabel sizeToFit];
    CGSize titleSize = self.titleLabel.frame.size;
    self.titleView.frame = CGRectMake(self.bounds.size.width/2 - titleSize.width/2, 26.f, titleSize.width, 25.f);
}

- (NSString *)title {
    return self.titleLabel.text;
}

- (void)setBackgroundImage:(UIImage *)backgroundImage {
    if (!_backImageView) {
        [self insertSubview:self.backImageView atIndex:0];
    }
    self.backImageView.image = backgroundImage;
}

- (UIImage *)backgroundImage {
    return self.backImageView.image;
}

- (void)setLeftItemHidden:(BOOL)hidden {
    self.leftBtn.hidden = hidden;
}

- (void)setCustomTitleView:(UIView *)customTitleView {
    if (_customTitleView && ![_customTitleView isEqual:customTitleView]) {
        [_customTitleView removeFromSuperview];
    }
    if (customTitleView) {
        [self insertSubview:customTitleView belowSubview:self.leftBtn];
        customTitleView.center = CGPointMake(self.bounds.size.width/2, self.leftBtn.center.y);
        _customTitleView = customTitleView;
    }
}

- (void)setRightTitle:(NSString *)title image:(UIImage *)image {
    if (_rightBtn) {
        [self addSubview:self.rightBtn];
    }
    if (title) {
        [self.rightBtn setTitle:title forState:(UIControlStateNormal)];
    }
    else if (image) {
        [self.rightBtn setImage:image forState:(UIControlStateNormal)];
    }
}

#pragma mark - UI
- (void)configUI {
    [self addSubview:self.leftBtn];
    [self addGradientLayerWithColors:@[ABCRGBA(95, 204, 78, 1.f), ABCRGBA(50, 199, 67, 1.f)] locations:nil startPoint:CGPointMake(0, 0.5) endPoint:CGPointMake(1, 0.5)];
}

- (UIImageView *)backImageView {
    if (!_backImageView) {
        _backImageView = [[UIImageView alloc] initWithFrame:self.bounds];
    }
    return _backImageView;
}

- (UIButton *)leftBtn {
    if (!_leftBtn) {
        _leftBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
        [_leftBtn addTarget:self action:@selector(leftNavigationButtonDidClicked) forControlEvents:(UIControlEventTouchUpInside)];
        _leftBtn.frame = CGRectMake(SZTBackItemLeftMargin, SZTBackItemTopMargin, SZTBackItemSize.width, SZTBackItemSize.height);
        [_leftBtn setTitleColor:ABCCommonTextColorWhite forState:(UIControlStateNormal)];
        [_leftBtn setImage:[UIImage imageNamed:@"nav_back_icon"] forState:(UIControlStateNormal)];
    }
    return _leftBtn;
}

- (UIButton *)rightBtn {
    if (!_rightBtn) {
        _rightBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
        [_rightBtn addTarget:self action:@selector(rightNavigationButtonDidClicked) forControlEvents:(UIControlEventTouchUpInside)];
        _rightBtn.frame = CGRectMake(self.bounds.size.width - SZTBackItemLeftMargin - SZTBackItemSize.height, SZTBackItemTopMargin, SZTBackItemSize.width, SZTBackItemSize.height);
        [_rightBtn setTitleColor:ABCCommonTextColorWhite forState:(UIControlStateNormal)];
    }
    return _rightBtn;
}

- (UIView *)titleView {
    if (!_titleView) {
        _titleView = [[UIView alloc] initWithFrame:CGRectMake(self.bounds.size.width/2 - 40.f, 26.f, 80.f, 25.f)];
        _titleView.backgroundColor = [UIColor clearColor];
        
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
        _titleLabel.font = [UIFont fontWithName:ABCFontNamePingFangSCMedium size:18.f];
        _titleLabel.textColor = ABCCommonTextColorWhite;
        [_titleView addSubview:_titleLabel];
    }
    return _titleView;
}

@end
