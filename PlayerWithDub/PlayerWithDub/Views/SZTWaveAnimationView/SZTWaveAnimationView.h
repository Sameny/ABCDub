//
//  SZTWaveAnimationView.h
//  PlayerWithDub
//
//  Created by 舒泽泰 on 2018/11/23.
//  Copyright © 2018 泽泰 舒. All rights reserved.
//
/**
 使用三角函数绘制波纹。
 三角函数公式： y = Asin（ωx+φ）+ C
 A：振幅，波纹在Y轴的高度，成正比，越大Y轴峰值越大。
 ω：和周期有关，越大周期越短。
 φ：横向偏移量，控制波纹的移动。
 C：整个波纹的Y轴偏移量。
 */

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface SZTWaveAnimationView : UIView

@property (nonatomic, assign) CGFloat amplitude; // 0.0~1.0 default is 0.5
@property (nonatomic, assign) CGFloat cycle; // 1/ω  1.0表示只展示一个周期, default is 1.0
@property (nonatomic, assign) CGPoint offset; // (-1.0, -1.0) ~ (1.0, 1.0), default is (0, 0)

@end

NS_ASSUME_NONNULL_END
