//
//  SZTPlayerView.h
//  PlayerWithDub
//
//  Created by 泽泰 舒 on 2018/11/12.
//  Copyright © 2018年 泽泰 舒. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class AVPlayerLayer;
@interface SZTPlayerView : UIView

- (void)addPlayerLayer:(AVPlayerLayer *)playerLayer;

@end

NS_ASSUME_NONNULL_END
