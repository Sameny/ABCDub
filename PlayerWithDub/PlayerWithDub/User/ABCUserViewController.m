//
//  ABCUserViewController.m
//  PlayerWithDub
//
//  Created by 泽泰 舒 on 2018/11/14.
//  Copyright © 2018年 泽泰 舒. All rights reserved.
//

#import "ABCPickerView.h"
#import "SZTClickableLabel.h"
#import "ABCUserViewController.h"

@interface ABCUserViewController ()
@property (nonatomic, strong) ABCPickerView *pickerView;
@property (nonatomic, strong) SZTClickableLabel *titleLabel;
@end

@implementation ABCUserViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self testClickableLabel];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.pickerView = [ABCPickerView showPickerViewOnView:self.view.window];
    self.pickerView.dataSource = @[@[@"男", @"女", @"未知"], @[@"男", @"女", @"未知"], @[@"男", @"女", @"未知"]];
}

- (void)testClickableLabel {
    self.titleLabel = [[SZTClickableLabel alloc] initWithFrame:CGRectMake(0, 100, [UIScreen mainScreen].bounds.size.width, 100)];
    self.titleLabel.font = [UIFont systemFontOfSize:16.f];
    self.titleLabel.textColor = [UIColor blackColor];
    
    self.titleLabel.normalCornerRarius = 5.f;
    self.titleLabel.normalAttributes = @{NSBackgroundColorAttributeName:[UIColor redColor]};
    
    //    self.titleLabel.title = @"every thing will get better! Today is a day, but it is a new day. new as it coming that every change. Nobody can't make wrong, don't  miss yourself, keep confident and stand up, you will win, you will win, you will win.";
    self.titleLabel.titles = @[@"ahhaha", @"啦啦啦啦"];
    
    [self.view addSubview:self.titleLabel];
}

@end
