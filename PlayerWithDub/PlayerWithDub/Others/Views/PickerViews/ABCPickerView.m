//
//  SZTPickerView.m
//  PlayerWithDub
//
//  Created by 舒泽泰 on 2018/11/26.
//  Copyright © 2018 泽泰 舒. All rights reserved.
//

#import "UIPickerView+SZTAdd.h"
#import "ABCPickerView.h"

@interface ABCPickerView () <UIPickerViewDataSource, UIPickerViewDelegate>

@property (nonatomic, strong) UIView *containerView;
@property (nonatomic, strong) UIPickerView *pickerView;
@property (nonatomic, strong) UIButton *cancelBtn;
@property (nonatomic, strong) UIButton *confirmBtn;
@property (nonatomic, strong) UIView *lineView;

@property (nonatomic, strong) NSIndexPath *selectedIndexPath;

@end

@implementation ABCPickerView

static CGFloat kABCPickerViewContainerHeight = 264.f;

+ (instancetype)showPickerViewOnView:(UIView *)onView {
    ABCPickerView *pickerView = [[ABCPickerView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    [pickerView showOnView:onView];
    return pickerView;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self configUI];
        _selectedIndexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    }
    return self;
}

- (void)cancel {
    [self hide];
}

- (void)confirm {
    [self hide];
}

- (void)showOnView:(UIView *)onView {
    if (!onView) {
        onView = [UIApplication sharedApplication].keyWindow;
    }
    [self layoutIfNeeded];
    [onView addSubview:self];
    [self show];
}

- (void)show {
    self.containerView.transform = CGAffineTransformMakeTranslation(0, self.containerView.bounds.size.height);
    self.backgroundColor = [self.backgroundColor colorWithAlphaComponent:0];
    [UIView animateWithDuration:0.3 animations:^{
        self.containerView.transform = CGAffineTransformIdentity;
        self.backgroundColor = [self.backgroundColor colorWithAlphaComponent:0.3];
    } completion:^(BOOL finished) {
        if (finished) {
            [self.pickerView selectRow:self.selectedIndexPath.row inComponent:self.selectedIndexPath.section animated:YES];
        }
    }];
}

- (void)hide {
    [UIView animateWithDuration:0.3 animations:^{
        self.containerView.transform = CGAffineTransformMakeTranslation(0, self.containerView.bounds.size.height);
        self.backgroundColor = [self.backgroundColor colorWithAlphaComponent:0];
    } completion:^(BOOL finished) {
        if (finished) {
            [self removeFromSuperview];
        }
    }];
}

- (void)setDataSource:(NSArray *)dataSource {
    if (![_dataSource isEqualToArray:dataSource]) {
        _dataSource = dataSource;
        [self.pickerView reloadAllComponents];
    }
}

- (NSInteger)numberOfComponents {
    if ([self.dataSource.firstObject isKindOfClass:[NSArray class]]) {
        return self.dataSource.count;
    }
    else if ([self.dataSource.firstObject isKindOfClass:[NSString class]]) {
        return 1;
    }
    return 0;
}

#pragma mark - UIPickerViewDataSource & UIPickerViewDelegate
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return [self numberOfComponents];
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    if ([self.dataSource.firstObject isKindOfClass:[NSArray class]]) {
        NSArray *rowTitles = (NSArray *)self.dataSource[component];
        return rowTitles.count;
    }
    else if ([self.dataSource.firstObject isKindOfClass:[NSString class]]) {
        return self.dataSource.count;
    }
    return 0;
}

- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component {
    if (self.itemSize) {
        return self.itemSize(component).height;
    }
    return 40;
}

- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component {
    if (self.itemSize) {
        return self.itemSize(component).width;
    }
    NSInteger numberOfComponents = [self numberOfComponents];
    if (numberOfComponents > 0) {
        return pickerView.bounds.size.width/numberOfComponents;
    }
    return pickerView.bounds.size.width;
}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view {
    NSString *title = [self titleForRow:row forComponent:component];
    if (self.itemView) {
        return self.itemView(row, component, title, view);
    }
    UILabel *label = [[UILabel alloc] init];
    label.text = title;
    label.textAlignment = NSTextAlignmentCenter;
    return label;
}

- (NSString *)titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    if ([self.dataSource.firstObject isKindOfClass:[NSArray class]]) {
        NSArray *rowTitles = (NSArray *)self.dataSource[component];
        return rowTitles[row];
    }
    else if ([self.dataSource.firstObject isKindOfClass:[NSString class]]) {
        return self.dataSource[row];
    }
    return @"";
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    self.selectedIndexPath = [NSIndexPath indexPathForRow:row inSection:component];
    if (_delegate && [_delegate respondsToSelector:@selector(didSelectedAtRow:component:title:)]) {
        NSString *title = [self titleForRow:row forComponent:component];
        [_delegate didSelectedAtRow:row component:component title:title];
    }
}

- (void)setSelectedIndexPath:(NSIndexPath *)selectedIndexPath {
    if (_selectedIndexPath.row == selectedIndexPath.row && _selectedIndexPath.section == selectedIndexPath.section) {
        return;
    }
    if (_delegate && [_delegate respondsToSelector:@selector(didSelectedAtView:fromView:)]) {
        UIView *lastSelectedView = [self.pickerView viewForRow:self.selectedIndexPath.row forComponent:self.selectedIndexPath.section];
        UIView *selectedView = [self.pickerView viewForRow:selectedIndexPath.row forComponent:selectedIndexPath.section];
        [_delegate didSelectedAtView:selectedView fromView:lastSelectedView];
    }
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [self.pickerView szt_setSeperateLineColor:ABCRGBA(247, 249, 246, 0.7) lineHeight:1.f];
}

#pragma mark - UI
- (void)configUI {
    [self addSubview:self.containerView];
    [self.containerView addSubview:self.cancelBtn];
    [self.containerView addSubview:self.confirmBtn];
    [self.containerView addSubview:self.pickerView];
    
    self.cancelBtn.frame = CGRectMake(0, 0, 44, 44);
    self.confirmBtn.frame = CGRectMake(self.containerView.bounds.size.width - 44, 0, 44, 44);
    self.pickerView.frame = CGRectMake(8, 44, self.containerView.bounds.size.width - 16.f, 220.f);
    [self.containerView setLineWithColor:ABCRGBA(247, 249, 246, 0.7) lineHeight:1.f top:43.f left:8.f right:8.f];
}

- (UIView *)containerView {
    if (!_containerView) {
        _containerView = [[UIView alloc] initWithFrame:CGRectMake(0, self.bounds.size.height - kABCPickerViewContainerHeight, self.bounds.size.width, kABCPickerViewContainerHeight)];
        _containerView.backgroundColor = [UIColor whiteColor];
    }
    return _containerView;
}

- (UIButton *)cancelBtn {
    if (!_cancelBtn) {
        _cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_cancelBtn setTitleColor:ABCCommonTextColorLightGray forState:(UIControlStateNormal)];
        [_cancelBtn setTitle:@"取消" forState:(UIControlStateNormal)];
        [_cancelBtn addTarget:self action:@selector(cancel) forControlEvents:(UIControlEventTouchUpInside)];
        _cancelBtn.titleLabel.font = [UIFont fontWithName:ABCFontNamePingFangSC size:14.f];
    }
    return _cancelBtn;
}

- (UIButton *)confirmBtn {
    if (!_confirmBtn) {
        _confirmBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
        [_confirmBtn setTitleColor:ABCMainColor forState:(UIControlStateNormal)];
        [_confirmBtn setTitle:@"确定" forState:(UIControlStateNormal)];
        [_confirmBtn addTarget:self action:@selector(confirm) forControlEvents:(UIControlEventTouchUpInside)];
        _confirmBtn.titleLabel.font = [UIFont fontWithName:ABCFontNamePingFangSC size:14.f];
    }
    return _confirmBtn;
}

- (UIPickerView *)pickerView {
    if (!_pickerView) {
        _pickerView = [[UIPickerView alloc] init];
        _pickerView.delegate = self;
        _pickerView.dataSource = self;
    }
    return _pickerView;
}

@end
