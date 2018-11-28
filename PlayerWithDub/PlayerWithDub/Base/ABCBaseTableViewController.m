//
//  ABCBaseTableViewController.m
//  PlayerWithDub
//
//  Created by 舒泽泰 on 2018/11/27.
//  Copyright © 2018 泽泰 舒. All rights reserved.
//

#import "MJRefresh.h"
#import "ABCBaseTableViewController.h"

@interface ABCBaseTableViewController () 
@property (nonatomic, strong) UITableView *tableView;
@end

@implementation ABCBaseTableViewController

- (void)configData {
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.tableView];
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
    SZT_AdjustsScrollViewContentInsetNever(self, self.tableView);
#pragma clang diagnostic pop
}

#pragma mark - refresh
- (void)addPullUpRefresh:(BOOL)pullUp dropDownRefresh:(BOOL)dropDown {
    if (pullUp) { // 上拉加载更多
        MJRefreshFooter *footer = [MJRefreshFooter footerWithRefreshingBlock:^{
        }];
        self.tableView.mj_footer = footer;
    }
    if (dropDown) {
        MJRefreshHeader *header = [MJRefreshHeader headerWithRefreshingBlock:^{
            
        }];
        self.tableView.mj_header = header;
    }
}

#pragma mark - UITableViewDataSource & UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    return nil;
}

#pragma mark - tableView
- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT) style:(UITableViewStyleGrouped)];
        _tableView.backgroundColor = ABCCommonBackColor;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    return _tableView;
}

@end
