//
//  SZTPlayerViewController.h
//  PlayerWithDub
//
//  Created by 泽泰 舒 on 2018/11/7.
//  Copyright © 2018年 泽泰 舒. All rights reserved.
//

#import "AWVideoPlayerViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface SZTPlayerViewController : UIViewController

@property (nonatomic, strong, readonly) AWVideoPlayerViewController *player;

- (void)setVideoUrl:(NSURL *)url needLoading:(BOOL)needLoading;
// can be overrided
- (void)backBtnDidClicked;

@end


NS_ASSUME_NONNULL_END
