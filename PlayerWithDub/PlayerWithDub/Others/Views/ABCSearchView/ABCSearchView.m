//
//  ABCSearchView.m
//  PlayerWithDub
//
//  Created by 泽泰 舒 on 2018/11/19.
//  Copyright © 2018年 泽泰 舒. All rights reserved.
//

#import "ABCSearchView.h"

@interface ABCSearchView ()

@property (nonatomic, strong) UITextField *searchTextField;
@property (nonatomic, strong) UIButton *cancelBtn;

@end

@implementation ABCSearchView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self configUI];
    }
    return self;
}

- (void)textFieldDidBeginEditing:(UITextField *)sender {
    [self setEditingState];
}

- (void)textFieldDidChanged:(UITextField *)sender {
    DebugLog(@"sender.text : %@", sender.text);
}

- (void)cancelSearch {
    [self.searchTextField resignFirstResponder];
    [self setNormalState];
}

#pragma mark - UI
- (void)configUI {
    [self addSubview:self.searchTextField];
    [self addSubview:self.cancelBtn];
    [self setNormalState];
}

- (void)setNormalState {
    self.searchTextField.backgroundColor = [ABCRGBA(0, 0, 0, 1.f) colorWithAlphaComponent:0.2];
    self.searchTextField.frame = CGRectMake(16.f, 7.f, SCREEN_WIDTH - 32.f, 30.f);
    self.cancelBtn.hidden = YES;
}

- (void)setEditingState {
    self.searchTextField.backgroundColor = [ABCRGBA(255, 255, 255, 1.f) colorWithAlphaComponent:0.2];
    self.searchTextField.frame = CGRectMake(8, 7.f, SCREEN_WIDTH - 55.f, 30.f);
    self.cancelBtn.hidden = NO;
}

- (UITextField *)searchTextField {
    if (!_searchTextField) {
        _searchTextField = [[UITextField alloc] initWithFrame:CGRectMake(16.f, 7.f, SCREEN_WIDTH - 32.f, 30.f)];
        _searchTextField.layer.cornerRadius = 15.f;
        
        [_searchTextField addTarget:self action:@selector(textFieldDidBeginEditing:) forControlEvents:(UIControlEventEditingDidBegin)];
        [_searchTextField addTarget:self action:@selector(textFieldDidChanged:) forControlEvents:(UIControlEventEditingChanged)];
    }
    return _searchTextField;
}

- (UIButton *)cancelBtn {
    if (!_cancelBtn) {
        _cancelBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
        [_cancelBtn setTitle:@"取消" forState:(UIControlStateNormal)];
        [_cancelBtn setTitleColor:[UIColor whiteColor] forState:(UIControlStateNormal)];
        _cancelBtn.frame = CGRectMake(SCREEN_WIDTH - 3 - 44, 7, 44, 30);
        _cancelBtn.titleLabel.font = [UIFont fontWithName:ABCFontNamePingFangSC size:14.f];
        
        [_cancelBtn addTarget:self action:@selector(cancelSearch) forControlEvents:(UIControlEventTouchUpInside)];
    }
    return _cancelBtn;
}

@end
