//
//  SZTPlayerStatusView.m
//  PlayerWithDub
//
//  Created by 泽泰 舒 on 2018/11/13.
//  Copyright © 2018年 泽泰 舒. All rights reserved.
//

#import "SZTPlayerStatusView.h"

@interface SZTPlayerStatusView ()

@property (nonatomic, strong) UIButton *pauseBtn;
@property (nonatomic, strong) UILabel *descLabel;
@property (nonatomic, strong) UIActivityIndicatorView *indicatorView;

@end

@implementation SZTPlayerStatusView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self configUI];
    }
    return self;
}

- (void)setStatus:(SZTPlayerStatusViewStatus)status withDescription:(NSAttributedString *)desc {
    switch (status) {
        case SZTPlayerStatusViewStatusNone: {
            self.pauseBtn.hidden = YES;
            self.descLabel.hidden = YES;
            self.indicatorView.hidden = YES;
        }
            break;
        case SZTPlayerStatusViewStatusPlaying: {
            [self.pauseBtn setImage:[UIImage imageNamed:@"player_palying"] forState:(UIControlStateNormal)];
            self.pauseBtn.hidden = NO;
            self.descLabel.hidden = YES;
            self.indicatorView.hidden = YES;
        }
            break;
        case SZTPlayerStatusViewStatusPaused: {
            [self.pauseBtn setImage:[UIImage imageNamed:@"player_pause"] forState:(UIControlStateNormal)];
            self.pauseBtn.hidden = NO;
            self.descLabel.hidden = YES;
            self.indicatorView.hidden = YES;
        }
            break;
        case SZTPlayerStatusViewStatusSlide: {
            self.descLabel.attributedText = desc;
            self.pauseBtn.hidden = YES;
            self.descLabel.hidden = NO;
            self.indicatorView.hidden = YES;
        }
            break;
        case SZTPlayerStatusViewStatusLoading: {
            self.pauseBtn.hidden = YES;
            self.descLabel.hidden = YES;
            self.indicatorView.hidden = NO;
            [self.indicatorView startAnimating];
        }
            break;
        case SZTPlayerStatusViewStatusError: {
            self.descLabel.text = @"播放出错，请稍后重试";
            self.pauseBtn.hidden = YES;
            self.descLabel.hidden = NO;
            self.indicatorView.hidden = YES;
        }
            break;
    }
    if (!self.descLabel.hidden) {
        self.descLabel.frame = CGRectMake(0, 0, 250.f, 20.f);
        self.descLabel.center = self.center;
        [self layoutIfNeeded];
    }
}

- (void)changePauseStatus {
    if (_changePauseStatusBlock) {
        _changePauseStatusBlock();
    }
}

#pragma mark - UI
- (void)configUI {
    [self addSubview:self.pauseBtn];
    [self addSubview:self.descLabel];
    [self addSubview:self.indicatorView];
    
    self.pauseBtn.frame = CGRectMake(0, 0, 50, 50);
    self.pauseBtn.center = self.center;
    self.descLabel.center = self.center;
    self.indicatorView.center = self.center;
    
    self.pauseBtn.hidden = YES;
    self.descLabel.hidden = YES;
    self.indicatorView.hidden = YES;
    
    [self layoutIfNeeded];
}

- (UIButton *)pauseBtn {
    if (!_pauseBtn) {
        _pauseBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
        [_pauseBtn setImage:[UIImage imageNamed:@"player_palying"] forState:(UIControlStateNormal)];
        [_pauseBtn addTarget:self action:@selector(changePauseStatus) forControlEvents:(UIControlEventTouchUpInside)];
    }
    return _pauseBtn;
}

- (UILabel *)descLabel {
    if (!_descLabel) {
        _descLabel = [[UILabel alloc] init];
    }
    return _descLabel;
}

- (UIActivityIndicatorView *)indicatorView {
    if (!_indicatorView) {
        _indicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
    }
    return _indicatorView;
}

@end
