//
//  ABCBaseTableViewController.h
//  PlayerWithDub
//
//  Created by 舒泽泰 on 2018/11/27.
//  Copyright © 2018 泽泰 舒. All rights reserved.
//

#import "ABCBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface ABCBaseTableViewController : ABCBaseViewController <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, readonly) UITableView *tableView;

@end

NS_ASSUME_NONNULL_END
