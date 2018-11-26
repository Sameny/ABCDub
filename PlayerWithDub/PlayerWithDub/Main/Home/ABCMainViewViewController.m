//
//  ABCMainViewViewController.m
//  PlayerWithDub
//
//  Created by 泽泰 舒 on 2018/11/14.
//  Copyright © 2018年 泽泰 舒. All rights reserved.
//

#import "ABCSearchView.h"
#import "ABCSearchVideoProgressView.h"

#import "SZTBannerView.h"
#import "ABCCommonEntryCell.h"
#import "ABCCommonVideoSnapCell.h"
#import "ABCSectionTitleView.h"

#import "ABCDubViewController.h"

#import "ABCMainViewModel.h"
#import "ABCMainViewViewController.h"

@interface ABCMainViewViewController () <UITableViewDelegate, UITableViewDataSource, ABCSearchViewDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) SZTBannerView *bannerView;
@property (nonatomic, strong) ABCCommonEntryCell *entryCell;
@property (nonatomic, strong) ABCCommonVideoSnapCell *todayUpdateCell;
@property (nonatomic, strong) UIView *blankSectionHeaderView;
@property (nonatomic, strong) ABCSectionTitleView *todayUpdateSectionHeaderView;

@property (nonatomic, strong) ABCMainViewModel *viewModel;

@property (nonatomic, strong) ABCSearchView *searchView;
@property (nonatomic, strong) ABCSearchVideoProgressView *searchProgressView;

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
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
    SZT_AdjustsScrollViewContentInsetNever(self, self.tableView);
#pragma clang diagnostic pop
    
    self.bannerView.urls = self.viewModel.bannerUrls;
    [self.bannerView startScroll];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
}

- (void)moreTodayUpdate {
    // TODO: more today update
    
}

- (void)didSelectedTodayUpdateIndex:(NSInteger)index {
    ABCDubViewController *dubViewController = [[ABCDubViewController alloc] init];
    [self presentViewController:dubViewController animated:YES completion:nil];
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
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HomeUITableViewCell" forIndexPath:indexPath];
    return cell;
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [self.viewModel heightForSection:indexPath.section];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 1) {
        return 48.f;
    }
    return 8.f;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (section == 1) {
        SZTWeakself(self);
        [self.todayUpdateSectionHeaderView shwoMoreButtonWithEvent:^{
            [weakself moreTodayUpdate];
        }];
        [self.todayUpdateSectionHeaderView setTitle:@"今日更新"];
        return self.todayUpdateSectionHeaderView;
    }
    return self.blankSectionHeaderView;
}

#pragma mark - ABCSearchViewDelegate
- (void)fetchResultWithSearchKey:(NSString *)key {
    [self.searchProgressView addNewHistory:key];
    [self.searchProgressView hide];
    [self searchResultWithKeyWord:key];
}

- (void)userDidBeginEditingSearchKey {
    [self.searchProgressView show];
}

- (void)userDidCancelEditingSearchKey {
    [self.searchProgressView hide];
}

- (void)searchResultWithKeyWord:(NSString *)keyWord {
    // TODO : search result
}

- (void)searchProgressViewDidSelectedKeyWord:(NSString *)keyWord {
    self.searchView.keyWord = keyWord;
    [self searchResultWithKeyWord:keyWord];
}

- (ABCSearchVideoProgressView *)searchProgressView {
    if (!_searchProgressView) {
        _searchProgressView = [[ABCSearchVideoProgressView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
        [_searchProgressView layoutIfNeeded];
        [self.view insertSubview:_searchProgressView belowSubview:self.searchView];
        SZTWeakself(self);
        _searchProgressView.didSelectedKeyWord = ^(NSString * _Nonnull key) {
            [weakself searchProgressViewDidSelectedKeyWord:key];
        };
    }
    return _searchProgressView;
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
        _todayUpdateCell.backgroundColor = [UIColor clearColor];
        SZTWeakself(self);
        _todayUpdateCell.selectedHandler = ^(NSInteger index) {
            [weakself didSelectedTodayUpdateIndex:index];
        };
    }
    return _todayUpdateCell;
}

- (UIView *)blankSectionHeaderView {
    if (!_blankSectionHeaderView) {
        _blankSectionHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 8.f)];
    }
    return _blankSectionHeaderView;
}

- (ABCSectionTitleView *)todayUpdateSectionHeaderView {
    if (!_todayUpdateSectionHeaderView) {
        _todayUpdateSectionHeaderView = [[ABCSectionTitleView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 48.f)];
    }
    return _todayUpdateSectionHeaderView;
}

#pragma mark - UI
- (void)configUI {
    [self.view addSubview:self.tableView];
    [self.view addSubview:self.searchView];
}

- (ABCSearchView *)searchView {
    if (!_searchView) {
        _searchView = [[ABCSearchView alloc] initWithFrame:CGRectMake(0, 26, SCREEN_WIDTH, 30.f)];
        _searchView.delegate = self;
    }
    return _searchView;
}

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT) style:(UITableViewStyleGrouped)];
        _tableView.backgroundColor = ABCCommonBackColor;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        
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
