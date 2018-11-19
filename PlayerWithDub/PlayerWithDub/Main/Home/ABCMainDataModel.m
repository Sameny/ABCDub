//
//  ABCMainDataModel.m
//  PlayerWithDub
//
//  Created by 泽泰 舒 on 2018/11/16.
//  Copyright © 2018年 泽泰 舒. All rights reserved.
//

#import "ABCMainDataModel.h"

@implementation ABCMainDataModel

- (NSArray<NSString *> *)banner_urls {
    return @[@"http://pic17.nipic.com/20111111/6759425_144346625149_2.jpg",
             @"http://img03.tooopen.com/uploadfile/downs/images/20110714/sy_20110714135215645030.jpg",
             @"http://tupian.qqjay.com/u/2017/1118/1_162252_8.jpg",
             @"http://wx2.sinaimg.cn/large/94cea970ly1fn2gx5dx4aj20dw0dw0ub.jpg",
             @"http://tupian.qqjay.com/u/2017/1201/2_161641_2.jpg",
             @"http://gss0.baidu.com/-fo3dSag_xI4khGko9WTAnF6hhy/lvpics/w=600/sign=3da54689a11ea8d38a227704a70a30cf/ac6eddc451da81cb378472ff5566d016092431a5.jpg",
             @"http://img2.imgtn.bdimg.com/it/u=3699579472,3995360432&fm=26&gp=0.jpg"];
}

- (NSArray<ABCCommonCollectionViewItemData *> *)entry_data {
    if (!_entry_data) {
        NSArray *titles = @[@"签到", @"排行榜", @"竞技大厅", @"任务"];
        NSArray *imageUrls = @[@"home_signin", @"home_ranking", @"home_game", @"home_task"];
        NSMutableArray *itemDatas = [NSMutableArray array];
        for (NSInteger i = 0; i < 4; i++) {
            ABCCommonCollectionViewItemData *itemData = [[ABCCommonCollectionViewItemData alloc] init];
            itemData.imageUrl = imageUrls[i];
            itemData.title = titles[i];
            [itemDatas addObject:itemData];
        }
        _entry_data = [itemDatas copy];
    }
    return _entry_data;
}

- (NSArray<ABCCommonCollectionViewItemData *> *)today_update {
    if (!_today_update) {
        NSArray *titles = @[@"视频1", @"视频2", @"视频3", @"视频4"];
        NSArray *imageUrls = @[@"http://pic17.nipic.com/20111111/6759425_144346625149_2.jpg",
                               @"http://img03.tooopen.com/uploadfile/downs/images/20110714/sy_20110714135215645030.jpg",
                               @"http://tupian.qqjay.com/u/2017/1118/1_162252_8.jpg",
                               @"http://wx2.sinaimg.cn/large/94cea970ly1fn2gx5dx4aj20dw0dw0ub.jpg"];
        NSMutableArray *todayUpdates = [NSMutableArray array];
        for (NSInteger i = 0; i < 4; i++) {
            ABCCommonCollectionViewItemData *itemData = [[ABCCommonCollectionViewItemData alloc] init];
            itemData.imageUrl = imageUrls[i];
            itemData.title = titles[i];
            [todayUpdates addObject:itemData];
        }
        _today_update = [todayUpdates copy];
    }
    return _today_update;
}

@end
