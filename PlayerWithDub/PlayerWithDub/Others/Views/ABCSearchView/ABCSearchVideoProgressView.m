//
//  ABCSearchHistoryView.m
//  PlayerWithDub
//
//  Created by 泽泰 舒 on 2018/11/19.
//  Copyright © 2018年 泽泰 舒. All rights reserved.
//

#import "ABCSearchHistoryViewModel.h"
#import "SZTClickableLabel.h"
#import "ABCSearchVideoProgressView.h"

@interface ABCSearchHistoryViewCell : UIView

@property (nonatomic, strong) SZTClickableLabel *clickableLabel;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIButton *cancelBtn;

- (void)setTitles:(NSArray <NSString *>*)titles;
@end

@interface ABCSearchVideoProgressView () <SZTClickableLabelDelegate>

@property (nonatomic, strong) UIView *headerView;
@property (nonatomic, strong) UIScrollView *scrollView;

@property (nonatomic, strong) ABCSearchHistoryViewCell *historyViewCell;

@property (nonatomic, strong) ABCSearchHistoryViewModel *viewModel;

@end

@implementation ABCSearchVideoProgressView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        self.viewModel = [[ABCSearchHistoryViewModel alloc] init];
        [self configUI];
    }
    return self;
}

- (void)addNewHistory:(NSString *)history {
    [self.viewModel appendHistory:history];
    [self updateHistoryCell];
}

- (void)clearHistory {
    [self.viewModel clearSearchHistoryData];
    [self updateHistoryCell];
}

- (void)updateHistoryCell {
    NSArray *titles = [self.viewModel.searchHistoryData allObjects];
    [self.historyViewCell setTitles:titles];
}

- (void)show {
    self.scrollView.alpha = 0;
    self.headerView.transform = CGAffineTransformMakeTranslation(0, -self.headerView.height);
    self.hidden = NO;
    [UIView animateWithDuration:0.3 animations:^{
        self.scrollView.alpha = 1.0;
        self.headerView.transform = CGAffineTransformIdentity;
    }];
}

- (void)hide {
    [UIView animateWithDuration:0.3 animations:^{
        self.scrollView.alpha = 0;
        self.headerView.transform = CGAffineTransformMakeTranslation(0, -self.headerView.height);
    } completion:^(BOOL finished) {
        if (finished) {
            self.hidden = YES;
            self.scrollView.alpha = 1.0;
            self.headerView.transform = CGAffineTransformIdentity;
        }
    }];
}

#pragma mark - SZTClickableLabelDelegate
- (void)clickableLabel:(SZTClickableLabel *)label didClickedAtWord:(NSString *)word {
    if (self.didSelectedKeyWord) {
        self.didSelectedKeyWord(word);
    }
}

#pragma mark - UI
- (void)configUI {
    [self addSubview:self.scrollView];
    [self addSubview:self.headerView];
    
    [self.scrollView addSubview:self.historyViewCell];
    [self updateHistoryCell];
}

- (UIView *)headerView {
    if (!_headerView) {
        _headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.bounds.size.width, SZT_NAVIGATIONBAR_HEIGHT)];
        [_headerView addGradientLayerWithColors:@[ABCRGBA(95, 204, 78, 1.f), ABCRGBA(50, 199, 67, 1.f)] locations:nil startPoint:CGPointMake(0, 0.5) endPoint:CGPointMake(1, 0.5)];
    }
    return _headerView;
}

- (UIScrollView *)scrollView {
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, SZT_NAVIGATIONBAR_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT - SZT_NAVIGATIONBAR_HEIGHT)];
        _scrollView.backgroundColor = ABCCommonBackColor;
        _scrollView.alwaysBounceVertical = YES;
    }
    return _scrollView;
}

- (ABCSearchHistoryViewCell *)historyViewCell {
    if (!_historyViewCell) {
        _historyViewCell = [[ABCSearchHistoryViewCell alloc] initWithFrame:CGRectMake(8, 8, SCREEN_WIDTH - 16.f, 0)];
        [_historyViewCell.cancelBtn addTarget:self action:@selector(clearHistory) forControlEvents:(UIControlEventTouchUpInside)];
        _historyViewCell.clickableLabel.delegate = self;
        _historyViewCell.backgroundColor = [UIColor whiteColor];
        _historyViewCell.layer.cornerRadius = 8.f;
    }
    return _historyViewCell;
}

@end


@implementation ABCSearchHistoryViewCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self configUI];
    }
    return self;
}

- (void)setTitles:(NSArray <NSString *>*)titles {
    [self updateFrameWithTitles:titles];
    self.clickableLabel.titles = titles;
//    [UIView animateWithDuration:0.3 animations:^{
//        [self updateFrameWithTitles:titles];
//    } completion:^(BOOL finished) {
//        self.clickableLabel.titles = titles;
//    }];
}

- (void)updateFrameWithTitles:(NSArray <NSString *>*)titles {
    CGFloat height = [self clickableLabelHeightWithTitles:titles];
    self.clickableLabel.frame = CGRectMake(0, 50.f, self.bounds.size.width, height);
    if (titles.count == 0) {
        self.clickableLabel.hidden = YES;
        self.titleLabel.hidden = YES;
        self.cancelBtn.hidden = YES;
        self.frame = CGRectMake(8, 8, self.frame.size.width, 0);
    }
    else {
        self.clickableLabel.hidden = NO;
        self.titleLabel.hidden = NO;
        self.cancelBtn.hidden = NO;
        self.frame = CGRectMake(8, 8, self.frame.size.width, CGRectGetMaxY(self.clickableLabel.frame) + 16.f);
    }
}

- (CGFloat)clickableLabelHeightWithTitles:(NSArray <NSString *>*)titles {
    CGFloat height = self.bounds.size.height;
    CGSize contentSize = [self.clickableLabel adjustContentSizeWithTitles:titles];
    if (contentSize.height > 168.f) {
        height = 168.f;
    }
    else if (titles.count == 0) {
        height = 32.f; // 如果高度为0，则clickableLabel的drawRect方法就不会走
    }
    else {
        height = contentSize.height;
    }
    return height;
}

#pragma mark - UI
- (void)configUI {
    [self addSubview:self.titleLabel];
    [self addSubview:self.cancelBtn];
    [self addSubview:self.clickableLabel];
    
    self.cancelBtn.size = CGSizeMake(80, 40);
    self.cancelBtn.centerY = self.titleLabel.centerY;
    self.cancelBtn.left = self.bounds.size.width - 22.f - 80.f;
    self.cancelBtn.contentMode = UIViewContentModeRight;
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
        [_cancelBtn setTitleColor:[UIColor blueColor] forState:(UIControlStateNormal)];
    }
    return _cancelBtn;
}

- (SZTClickableLabel *)clickableLabel {
    if (!_clickableLabel) {
        _clickableLabel = [[SZTClickableLabel alloc] initWithFrame:CGRectMake(0, 50.f, self.bounds.size.width, 32.f)];
        _clickableLabel.contentMode = UIViewContentModeTop;
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
