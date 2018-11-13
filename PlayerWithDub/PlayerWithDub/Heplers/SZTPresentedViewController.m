//
//  SZTPresentedViewController.m
//  PlayerWithDub
//
//  Created by 泽泰 舒 on 2018/11/13.
//  Copyright © 2018年 泽泰 舒. All rights reserved.
//

#import "SZTFontDefine.h"
#import "SZTPresentedViewController.h"

@interface SZTPresentedViewController ()

@property (nonatomic, strong) UIButton *backBtn;

@end

@implementation SZTPresentedViewController

- (void)addBackBtn {
    [self.view addSubview:self.backBtn];
    self.backBtn.frame = CGRectMake(SZTBackItemLeftMargin, SZTBackItemTopMargin, SZTBackItemSize.width, SZTBackItemSize.height);
}

- (void)backBtnDidClicked {
    if (self.navigationController) {
        [self.navigationController popViewControllerAnimated:YES];
    }
    else {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

- (UIButton *)backBtn {
    if (!_backBtn) {
        _backBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
        [_backBtn setTitle:@"返回" forState:(UIControlStateNormal)];
        [_backBtn addTarget:self action:@selector(backBtnDidClicked) forControlEvents:(UIControlEventTouchUpInside)];
        _backBtn.titleLabel.font = [UIFont fontWithName:SZTFontNamePingFangSC size:18.f];
        [_backBtn setTitleColor:[UIColor whiteColor] forState:(UIControlStateNormal)];
    }
    return _backBtn;
}


@end
