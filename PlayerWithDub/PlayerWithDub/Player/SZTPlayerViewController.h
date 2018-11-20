//
//  SZTPlayerViewController.h
//  PlayerWithDub
//
//  Created by 泽泰 舒 on 2018/11/7.
//  Copyright © 2018年 泽泰 舒. All rights reserved.
//

#import "SZTPlayerView.h"
#import "SZTPresentedViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface SZTPlayerViewController : SZTPresentedViewController

@property (nonatomic, strong, readonly) SZTPlayerView *playerView;

- (void)setVideoUrl:(NSURL *)url;

@end


NS_ASSUME_NONNULL_END
