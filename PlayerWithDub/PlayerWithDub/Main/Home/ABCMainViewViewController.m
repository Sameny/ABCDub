//
//  ABCMainViewViewController.m
//  PlayerWithDub
//
//  Created by 泽泰 舒 on 2018/11/14.
//  Copyright © 2018年 泽泰 舒. All rights reserved.
//

#import "SZTBannerView.h"
#import "ABCCommonEntryCell.h"
#import "ABCCommonVideoSnapCell.h"

#import "ABCMainViewModel.h"
#import "ABCMainViewViewController.h"

@interface ABCMainViewViewController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) SZTBannerView *bannerView;
@property (nonatomic, strong) ABCCommonEntryCell *entryCell;
@property (nonatomic, strong) ABCCommonVideoSnapCell *todayUpdateCell;
@property (nonatomic, strong) UIView *blankSectionHeaderView;

@property (nonatomic, strong) ABCMainViewModel *viewModel;

@end

@implementation ABCMainViewViewController

- (void)configData {
    [self.viewModel configDataWithCompletion:^(BOOL success) {
        self.entryCell.data = self.viewModel.itemData;
        self.todayUpdateCell.data = self.viewModel.todayUpdateData;
        [self.tableView reloadData];
    }];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self configUI];
    [self configData];
    SZT_AdjustsScrollViewContentInsetNever(self, self.tableView);
    
    self.bannerView.urls = self.viewModel.bannerUrls;
    [self.bannerView startScroll];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.viewModel.numberOfSections;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return self.entryCell;
    }
    else if (indexPath.section == 1) {
        return self.todayUpdateCell;
    }
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell" forIndexPath:indexPath];
    return cell;
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [self.viewModel heightForSection:indexPath.section];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (section == 1) {
        
    }
    return self.blankSectionHeaderView;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
}

#pragma mark - lazy init
- (ABCMainViewModel *)viewModel {
    if (!_viewModel) {
        _viewModel = [[ABCMainViewModel alloc] init];
    }
    return _viewModel;
}

- (ABCCommonEntryCell *)entryCell {
    if (!_entryCell) {
        _entryCell = [[ABCCommonEntryCell alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 65.f)];
        _entryCell.backgroundColor = [UIColor clearColor];
    }
    return _entryCell;
}

- (ABCCommonVideoSnapCell *)todayUpdateCell {
    if (!_todayUpdateCell) {
        _todayUpdateCell = [[ABCCommonVideoSnapCell alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 272.f)];
        _todayUpdateCell.backgroundColor = [UIColor whiteColor];
    }
    return _todayUpdateCell;
}

- (UIView *)blankSectionHeaderView {
    if (!_blankSectionHeaderView) {
        _blankSectionHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 8.f)];
    }
    return _blankSectionHeaderView;
}

#pragma mark - UI
- (void)configUI {
    [self.view addSubview:self.tableView];
}

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT) style:(UITableViewStyleGrouped)];
        _tableView.backgroundColor = ABCCommonBackColor;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        
        _tableView.sectionHeaderHeight = 8.f;
        
        _tableView.tableHeaderView = self.bannerView;
    }
    return _tableView;
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
