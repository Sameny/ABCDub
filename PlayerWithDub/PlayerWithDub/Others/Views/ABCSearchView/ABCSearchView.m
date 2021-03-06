//
//  ABCSearchView.m
//  PlayerWithDub
//
//  Created by 泽泰 舒 on 2018/11/19.
//  Copyright © 2018年 泽泰 舒. All rights reserved.
//

#import "UIButton+SZTAdd.h"
#import "ABCSearchView.h"

@interface ABCSearchView ()

@property (nonatomic, strong) UITextField *searchTextField;
@property (nonatomic, strong) UIButton *cancelBtn;
@property (nonatomic, strong) UIButton *placeHolderView;

@end

@implementation ABCSearchView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self configUI];
    }
    return self;
}

- (NSString *)keyWord {
    return self.searchTextField.text;
}

- (void)setKeyWord:(NSString *)keyWord {
    self.searchTextField.text = keyWord;
}

- (void)startSearch {
    if ([self.searchTextField canBecomeFirstResponder]) {
        [self.searchTextField becomeFirstResponder];
    }
}

- (void)textFieldDidBeginEditing:(UITextField *)sender {
    [self setEditingState];
    if (_delegate && [_delegate respondsToSelector:@selector(userDidBeginEditingSearchKey)]) {
        [_delegate userDidBeginEditingSearchKey];
    }
}

- (void)textFieldDidChanged:(UITextField *)sender {
    DebugLog(@"sender.text : %@", sender.text);
    if (_delegate && [_delegate respondsToSelector:@selector(userInputKeyDidChange:)]) {
        [_delegate userInputKeyDidChange:sender.text];
    }
}

- (void)endSearchAndOnExit {
    DebugLog(@"End search");
    if (_delegate && [_delegate respondsToSelector:@selector(fetchResultWithSearchKey:)]) {
        [_delegate fetchResultWithSearchKey:self.searchTextField.text];
    }
}

- (void)cancelSearch {
    [self.searchTextField resignFirstResponder];
    [self setNormalState];
    if (_delegate && [_delegate respondsToSelector:@selector(userDidCancelEditingSearchKey)]) {
        [_delegate userDidCancelEditingSearchKey];
    }
}

- (void)reset {
    [self cancelSearch];
}

#pragma mark - UI
- (void)configUI {
    [self addSubview:self.searchTextField];
    [self addSubview:self.cancelBtn];
    [self addSubview:self.placeHolderView];
    [self setNormalState];
}

- (void)setNormalState {
    self.searchTextField.text = @"";
    self.searchTextField.backgroundColor = [ABCRGBA(0, 0, 0, 1.f) colorWithAlphaComponent:0.2];
    self.searchTextField.frame = CGRectMake(16.f, 0, SCREEN_WIDTH - 32.f, 30.f);
    self.placeHolderView.frame = self.searchTextField.frame;
    [self.placeHolderView horizontalAlignmentWithSpace:10.f imageAtLeft:YES];
    self.placeHolderView.hidden = NO;
    self.cancelBtn.hidden = YES;
}

- (void)setEditingState {
    self.searchTextField.backgroundColor = [ABCRGBA(255, 255, 255, 1.f) colorWithAlphaComponent:0.2];
    self.searchTextField.frame = CGRectMake(8, 0, SCREEN_WIDTH - 55.f, 30.f);
    self.cancelBtn.hidden = NO;
    self.placeHolderView.hidden = YES;
}

- (UITextField *)searchTextField {
    if (!_searchTextField) {
        _searchTextField = [[UITextField alloc] initWithFrame:CGRectMake(16.f, 0, SCREEN_WIDTH - 32.f, 30.f)];
        _searchTextField.layer.cornerRadius = 15.f;
        _searchTextField.returnKeyType = UIReturnKeySearch;
        _searchTextField.inputAccessoryView = nil;
        
        UIView *leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 15.f, 30.f)];
        _searchTextField.leftView = leftView;
        _searchTextField.leftViewMode = UITextFieldViewModeAlways;
        
        [_searchTextField addTarget:self action:@selector(textFieldDidBeginEditing:) forControlEvents:(UIControlEventEditingDidBegin)];
        [_searchTextField addTarget:self action:@selector(textFieldDidChanged:) forControlEvents:(UIControlEventEditingChanged)];
        [_searchTextField addTarget:self action:@selector(endSearchAndOnExit) forControlEvents:(UIControlEventEditingDidEndOnExit)];
    }
    return _searchTextField;
}

- (UIButton *)cancelBtn {
    if (!_cancelBtn) {
        _cancelBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
        [_cancelBtn setTitle:@"取消" forState:(UIControlStateNormal)];
        [_cancelBtn setTitleColor:[UIColor whiteColor] forState:(UIControlStateNormal)];
        _cancelBtn.frame = CGRectMake(SCREEN_WIDTH - 3 - 44, 0, 44, 30);
        _cancelBtn.titleLabel.font = [UIFont fontWithName:ABCFontNamePingFangSC size:14.f];
        
        [_cancelBtn addTarget:self action:@selector(cancelSearch) forControlEvents:(UIControlEventTouchUpInside)];
    }
    return _cancelBtn;
}

- (UIButton *)placeHolderView {
    if (!_placeHolderView) {
        _placeHolderView = [UIButton buttonWithType:(UIButtonTypeCustom)];
        [_placeHolderView setImage:[UIImage imageNamed:@"search_magnifying_glass"] forState:(UIControlStateNormal)];
        [_placeHolderView setTitle:@"搜一下你想搜的" forState:(UIControlStateNormal)];
        [_placeHolderView setTitleColor:[[UIColor whiteColor] colorWithAlphaComponent:0.7] forState:(UIControlStateNormal)];
    
        _placeHolderView.titleLabel.font = [UIFont fontWithName:ABCFontNamePingFangSC size:14.f];
        [_placeHolderView addTarget:self action:@selector(startSearch) forControlEvents:(UIControlEventTouchUpInside)];
    }
    return _placeHolderView;
}

@end
