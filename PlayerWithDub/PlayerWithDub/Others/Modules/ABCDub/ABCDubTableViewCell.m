//
//  ABCDubTableViewCell.m
//  PlayerWithDub
//
//  Created by 泽泰 舒 on 2018/11/5.
//  Copyright © 2018年 泽泰 舒. All rights reserved.
//

#import "UIButton+SZTAdd.h"
#import "ControlHelper.h"
#import "ABCDubTableViewCell.h"

@interface ABCDubTableViewCell ()

@property (nonatomic, strong) UIView *containerView;
@property (nonatomic, strong) UILabel *indexLabel;
@property (nonatomic, strong) UIImageView *roleImageView;
@property (nonatomic, strong) UILabel *roleNickLabel;
@property (nonatomic, strong) UILabel *enLabel;
@property (nonatomic, strong) UILabel *chLabel;
@property (nonatomic, strong) UIView *lineView;
@property (nonatomic, strong) UIView *progressView;
@property (nonatomic, strong) UIButton *recordBtn;

@property (nonatomic, strong) UILabel *timeLabel;

@end

@implementation ABCDubTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(nullable NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self configUI];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    self.recordBtn.enabled = selected;
}

- (void)recordBtnDidClicked {
    if (_recordHandler) {
        _recordHandler();
    }
}

- (void)setCellWithIndex:(NSInteger)index count:(NSInteger)count enContent:(NSString *)enContent chContent:(NSString *)chContent {
    self.indexLabel.text = [NSString stringWithFormat:@"%ld/%ld", index, count];
    self.enLabel.text = enContent;
    self.chLabel.text = chContent;
}

- (void)setStartMilliSeconds:(NSInteger)start endMilliSeconds:(NSInteger)end {
    NSInteger startSeconds = start/1000;
    NSInteger endSeconds = end/1000;
    NSString *startString = SZTTIMESTRING(startSeconds);
    NSString *endString = SZTTIMESTRING(endSeconds);
    NSString *timeString = [NSString stringWithFormat:@"%@,%ld ~ %@,%ld", startString, start - startSeconds*1000, endString, end - endSeconds*1000];
    self.timeLabel.text = timeString;
}

#pragma mark - subviews
- (void)configUI {
    self.backgroundColor = [UIColor clearColor];
    
    [self.contentView addSubview:self.containerView];
    [self.containerView addSubview:self.indexLabel];
    [self.containerView addSubview:self.roleImageView];
    [self.containerView addSubview:self.roleNickLabel];
    [self.containerView addSubview:self.enLabel];
    [self.containerView addSubview:self.chLabel];
    [self.containerView addSubview:self.lineView];
    [self.containerView addSubview:self.progressView];
    [self.containerView addSubview:self.recordBtn];
    [self.containerView addSubview:self.timeLabel];
    
    [self.containerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.mas_equalTo(15.f);
        make.right.bottom.mas_equalTo(-15.f);
    }];
    
    [self.indexLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15.f);
        make.top.mas_equalTo(20.f);
    }];
    [self.enLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15.f);
        make.top.mas_equalTo(50.f);
    }];
    [self.chLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15.f);
        make.top.mas_equalTo(80.f);
    }];
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15.f);
        make.right.mas_equalTo(-15.f);
        make.height.mas_equalTo(ABCCOMMON_SPLIT_LINE_THICKNESS);
        make.bottom.mas_equalTo(-40.f);
    }];
    
    [self.recordBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-15.f);
        make.height.mas_equalTo(30.f);
        make.width.mas_equalTo(50.f);
        make.top.equalTo(self.lineView.mas_bottom).with.offset(5.f);
    }];
    self.recordBtn.enabled = NO;
    [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(130.f);
        make.left.mas_equalTo(15.f);
    }];
}

- (UIView *)containerView {
    if (!_containerView) {
        _containerView = [[UIView alloc] init];
        _containerView.backgroundColor = [UIColor whiteColor];
        _containerView.layer.cornerRadius = 10.f;
    }
    return _containerView;
}

- (UILabel *)timeLabel {
    if (!_timeLabel) {
        _timeLabel = [ControlHelper getLabelWithTextColor:ABCRGBA(208, 208, 208, 1.f) TextFont:15.f Isbold:NO];
    }
    return _timeLabel;
}

- (UILabel *)indexLabel {
    if (!_indexLabel) {
        _indexLabel = [ControlHelper getLabelWithTextColor:ABCRGBA(128, 128, 128, 1.f) TextFont:13.f Isbold:NO];
        _indexLabel.text = @"0/0";
    }
    return _indexLabel;
}

- (UIImageView *)roleImageView {
    if (!_roleImageView) {
        _roleImageView = [[UIImageView alloc] init];
    }
    return _roleImageView;
}

- (UILabel *)roleNickLabel {
    if (!_roleNickLabel) {
        _roleNickLabel = [ControlHelper getLabelWithTextColor:ABCRGBA(128, 128, 128, 1.f) TextFont:13.f Isbold:NO];
    }
    return _roleNickLabel;
}

- (UILabel *)enLabel {
    if (!_enLabel) {
        _enLabel = [ControlHelper getLabelWithTextColor:ABCRGBA(51, 51, 51, 1.f) TextFont:12.f Isbold:NO];
        _enLabel.text = @"This is a sententce of English caption.";
    }
    return _enLabel;
}

- (UILabel *)chLabel {
    if (!_chLabel) {
        _chLabel = [ControlHelper getLabelWithTextColor:ABCRGBA(208, 208, 208, 1.f) TextFont:11.f Isbold:NO];
        _chLabel.text = @"这是一句中文字幕。";
    }
    return _chLabel;
}

- (UIView *)lineView {
    if (!_lineView) {
        _lineView = [[UIView alloc] init];
        _lineView.backgroundColor = ABCCOMMON_SPLIT_LINE_COLOR;
    }
    return _lineView;
}

- (UIView *)progressView {
    if (!_progressView) {
        _progressView = [[UIView alloc] init];
    }
    return _progressView;
}

- (UIButton *)recordBtn {
    if (!_recordBtn) {
        _recordBtn = [ControlHelper baseButtonAddtarget:self selector:@selector(recordBtnDidClicked) image:nil imagePressed:nil title:@"录音" font:16.f textColor:ABCRGBA(208, 208, 208, 1.f) textBold:NO];
    }
    return _recordBtn;
}

@end
