//
//  ABCDubViewController.h
//  PlayerWithDub
//
//  Created by 泽泰 舒 on 2018/11/5.
//  Copyright © 2018年 泽泰 舒. All rights reserved.
//

#import "SZTPlayerViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface ABCDubViewController : SZTPlayerViewController

@property (nonatomic, copy) NSString *mp3FilePath;
@property (nonatomic, copy) NSString *mp4FilePath;
@property (nonatomic, copy) NSString *srtFilePath;

@end

NS_ASSUME_NONNULL_END
