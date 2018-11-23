//
//  ABCSearchHistoryView.m
//  PlayerWithDub
//
//  Created by 泽泰 舒 on 2018/11/19.
//  Copyright © 2018年 泽泰 舒. All rights reserved.
//

#import "ABCSearchHistoryViewModel.h"
#import "SZTClickableLabel.h"
#import "ABCSearchHistoryView.h"

@interface ABCSearchHistoryView ()

@property (nonatomic, strong) UIView *headerView;
@property (nonatomic, strong) UIScrollView *scrollView;

@property (nonatomic, strong) ABCSearchHistoryViewModel *viewModel;

@end

@implementation ABCSearchHistoryView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.viewModel = [[ABCSearchHistoryViewModel alloc] init];
        [self configUI];
    }
    return self;
}

- (void)addNewHistory:(NSString *)history {
    [self.viewModel appendHistory:history];
}

#pragma mark - UI
- (void)configUI {
    [self addSubview:self.headerView];
    [self addSubview:self.scrollView];
}

- (UIView *)headerView {
    if (!_headerView) {
        _headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.bounds.size.width, SZT_NAVIGATIONBAR_HEIGHT)];
        [_headerView addGradientLayerWithColors:@[ABCRGBA(50, 199, 67, 1.f), ABCRGBA(95, 204, 78, 1.f)] locations:nil startPoint:CGPointMake(0, SZT_NAVIGATIONBAR_HEIGHT/2) endPoint:CGPointMake(self.bounds.size.width, SZT_NAVIGATIONBAR_HEIGHT/2)];
    }
    return _headerView;
}

- (UIScrollView *)scrollView {
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc] init];
        _scrollView.backgroundColor = [UIColor clearColor];
    }
    return _scrollView;
}

@end

@interface ABCSearchHistoryViewCell : UIView

@property (nonatomic, strong) SZTClickableLabel *clickableLabel;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIButton *cancelBtn;

@end

@implementation ABCSearchHistoryViewCell

-(instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self configUI];
    }
    return self;
}

- (void)setTitles:(NSArray <NSString *>*)titles {
    self.clickableLabel.titles = titles;
    CGSize contentSize = self.clickableLabel.contentSize;
    self.clickableLabel.frame = CGRectMake(0, 50.f, contentSize.width, contentSize.height);
    self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width, CGRectGetMaxY(self.clickableLabel.frame) + 16.f);
}

#pragma mark - UI
- (void)configUI {
    [self addSubview:self.titleLabel];
    [self addSubview:self.cancelBtn];
    [self addSubview:self.clickableLabel];
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(8, 16, 80, 20)];
        _titleLabel.text = @"历史搜索";
        _titleLabel.textColor = ABCCommonTextColorBlack;
        _titleLabel.font = [UIFont fontWithName:ABCFontNamePingFangSC size:14.f];
    }
    return _titleLabel;
}

- (UIButton *)cancelBtn {
    if (!_cancelBtn) {
        _cancelBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
//        [_cancelBtn setImage:[UIImage imageNamed:@""] forState:(UIControlStateNormal)];
        [_cancelBtn setTitle:@"清除历史" forState:(UIControlStateNormal)];
    }
    return _cancelBtn;
}

- (SZTClickableLabel *)clickableLabel {
    if (!_clickableLabel) {
        _clickableLabel = [[SZTClickableLabel alloc] initWithFrame:CGRectMake(0, 50.f, self.bounds.size.width, 32.f)]; // 默认一行的高度
        _clickableLabel.textColor = ABCCommonTextColorGray;
        _clickableLabel.font = [UIFont fontWithName:ABCFontNamePingFangSC size:12.f];
        _clickableLabel.lineSpacing = 8.f;
        _clickableLabel.wordSpacing = 8.f;
        _clickableLabel.normalAttributes = @{NSBackgroundColorAttributeName:ABCRGBA(248, 248, 248, 1.f)};
        _clickableLabel.clickedAttributes = _clickableLabel.normalAttributes;
    }
    return _clickableLabel;
}

@end
