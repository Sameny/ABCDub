//
//  ABCMainViewViewController.m
//  PlayerWithDub
//
//  Created by 泽泰 舒 on 2018/11/14.
//  Copyright © 2018年 泽泰 舒. All rights reserved.
//

#import "SZTBannerView.h"
#import "ABCMainViewViewController.h"

@interface ABCMainViewViewController ()

@property (nonatomic, strong) SZTBannerView *bannerView;
@property (nonatomic, strong) UIScrollView *scrollView;

@end

@implementation ABCMainViewViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self configUI];
    SZT_AdjustsScrollViewContentInsetNever(self, self.scrollView);
    
    NSArray <NSString *>*urls = @[@"http://img03.tooopen.com/uploadfile/downs/images/20110714/sy_20110714135215645030.jpg", @"http://tupian.qqjay.com/u/2017/1118/1_162252_8.jpg", @"http://wx2.sinaimg.cn/large/94cea970ly1fn2gx5dx4aj20dw0dw0ub.jpg", @"http://tupian.qqjay.com/u/2017/1201/2_161641_2.jpg", @"http://gss0.baidu.com/-fo3dSag_xI4khGko9WTAnF6hhy/lvpics/w=600/sign=3da54689a11ea8d38a227704a70a30cf/ac6eddc451da81cb378472ff5566d016092431a5.jpg"];
    self.bannerView.urls = urls;
    
    [self.bannerView startScroll];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
}

#pragma mark - UI
- (void)configUI {
    [self.view addSubview:self.bannerView];
}

- (UIScrollView *)scrollView {
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    }
    return _scrollView;
}

- (SZTBannerView *)bannerView {
    if (!_bannerView) {
        _bannerView = [[SZTBannerView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 210.f)];
    }
    return _bannerView;
}

#pragma mark - orientation
- (BOOL)shouldAutorotate {
    return YES;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskPortrait;
}

@end
