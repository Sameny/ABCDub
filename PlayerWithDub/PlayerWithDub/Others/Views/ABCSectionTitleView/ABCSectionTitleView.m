//
//  ABCSectionTitleView.m
//  PlayerWithDub
//
//  Created by 泽泰 舒 on 2018/11/19.
//  Copyright © 2018年 泽泰 舒. All rights reserved.
//

#import "ABCSectionTitleView.h"

static CGFloat kABCSectionTitleLeftMargin = 14.f;
static CGFloat kABCSectionTitleRightMargin = 22.f;

@interface ABCSectionTitleView ()

@property (nonatomic, strong) UIImageView *backImageView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIImageView *moreImageView;

@property (nonatomic, strong) UITapGestureRecognizer *tap;
@property (nonatomic, copy) ABCHandler event;

@end

@implementation ABCSectionTitleView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.style = ABCSectionTitleViewStyleGreen;
        [self configUI];
    }
    return self;
}

- (void)setTitle:(NSString *)title {
    self.titleLabel.text = title;
    CGRect titleRect = [title boundingRectWithSize:CGSizeMake(self.bounds.size.width - kABCSectionTitleLeftMargin - kABCSectionTitleRightMargin, self.bounds.size.height) options:(NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading|NSStringDrawingTruncatesLastVisibleLine) attributes:@{NSFontAttributeName:self.titleLabel.font} context:nil];
    [self updateLayoutWithTitleRect:titleRect];
}

- (void)setAttributeTitle:(NSAttributedString *)title {
    self.titleLabel.attributedText = title;
    CGRect titleRect = [title boundingRectWithSize:CGSizeMake(self.bounds.size.width - kABCSectionTitleLeftMargin - kABCSectionTitleRightMargin, self.bounds.size.height) options:(NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading|NSStringDrawingTruncatesLastVisibleLine) context:nil];
    [self updateLayoutWithTitleRect:titleRect];
}

- (void)updateLayoutWithTitleRect:(CGRect)titleRect {
    self.titleLabel.frame = CGRectMake(14.f, (self.height - titleRect.size.height)/2, titleRect.size.width, titleRect.size.height);
    CGFloat imageWidth = MAX(100.f, titleRect.size.width + kABCSectionTitleLeftMargin + kABCSectionTitleRightMargin);
    self.backImageView.frame = CGRectMake(0, 0, imageWidth, self.height);
    UIImage *backImage = ImageWithName(_style == ABCSectionTitleViewStyleBlue?@"section_title_back_blue":@"section_title_back_green");
    self.backImageView.image = [backImage resizableImageWithCapInsets:UIEdgeInsetsMake(20, 10, 20, 80) resizingMode:UIImageResizingModeStretch];
}

- (void)shwoMoreButtonWithEvent:(ABCHandler)event {
    _event = event;
    if (!_moreImageView) {
        [self addSubview:self.moreImageView];
        [self layoutIfNeeded];
        
        SZTWeakself(self);
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithActionBlock:^(id  _Nonnull sender) {
            if (weakself.event) {
                weakself.event();
            }
        }];
        [self addGestureRecognizer:tap];
        self.tap = tap;
    }
    self.moreImageView.image = ImageWithName(_style == ABCSectionTitleViewStyleBlue?@"section_more_blue":@"section_more_green");
}

#pragma mark - UI
- (void)configUI {
    [self addSubview:self.backImageView];
    [self addSubview:self.titleLabel];
}

- (UIImageView *)backImageView {
    if (!_backImageView) {
        _backImageView = [[UIImageView alloc] initWithFrame:self.bounds];
    }
    return _backImageView;
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.font = [UIFont fontWithName:ABCFontNamePingFangSCMedium size:16.f];
        _titleLabel.textColor = [UIColor whiteColor];
    }
    return _titleLabel;
}

- (UIImageView *)moreImageView {
    if (!_moreImageView) {
        _moreImageView = [[UIImageView alloc] initWithFrame:CGRectMake(self.width - 48.f, (self.height - 48)/2, 48.f, 48.f)];
    }
    return _moreImageView;
}

@end
