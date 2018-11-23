//
//  ABCUserViewController.m
//  PlayerWithDub
//
//  Created by 泽泰 舒 on 2018/11/14.
//  Copyright © 2018年 泽泰 舒. All rights reserved.
//

#import "SZTClickableLabel.h"
#import "ABCUserViewController.h"

@interface ABCUserViewController ()
@property (nonatomic, strong) SZTClickableLabel *titleLabel;
@end

@implementation ABCUserViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.titleLabel = [[SZTClickableLabel alloc] initWithFrame:CGRectMake(0, 64, [UIScreen mainScreen].bounds.size.width, 100)];
    self.titleLabel.font = [UIFont systemFontOfSize:16.f];
    self.titleLabel.textColor = [UIColor blackColor];
    
    self.titleLabel.normalCornerRarius = 5.f;
    self.titleLabel.normalAttributes = @{NSBackgroundColorAttributeName:[UIColor redColor]};
    
    self.titleLabel.title = @"every thing will get better! Today is a day, but it is a new day. new as it coming that every change. Nobody can't make wrong, don't  miss yourself, keep confident and stand up, you will win, you will win, you will win.";
//    self.titleLabel.titles = @[@"ahhaha", @"啦啦啦啦", @"xixi", @"子子子子中", @"时尚哈哈哈哈说", @"维护法律不过好久好久", @"晒个 i 不回家吧", @"萨巴赫结果"];
    
    [self.view addSubview:self.titleLabel];
}

@end
