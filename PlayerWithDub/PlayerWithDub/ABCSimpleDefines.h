//
//  ABCSimpleDefines.h
//  PlayerWithDub
//
//  Created by 泽泰 舒 on 2018/11/5.
//  Copyright © 2018年 泽泰 舒. All rights reserved.
//

#ifndef ABCSimpleDefines_h
#define ABCSimpleDefines_h

// iOS 11 scrollView适配
/// 第一个参数是当下的控制器适配iOS11 一下的，第二个参数表示scrollview或子类
#define SZT_AdjustsScrollViewInsetNever(controller,view) if(@available(iOS 11.0, *)) {view.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;} else if([controller isKindOfClass:[UIViewController class]]) {controller.automaticallyAdjustsScrollViewInsets = NO;}

#define APP_VERSION [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"]
#define IPHONE_VERSION [[UIDevice currentDevice] systemVersion]

#define SZTTIMESTRING(seconds) [NSString stringWithFormat:@"%02ld:%02ld:%02ld", seconds/3600, (seconds%3600)/60, seconds%60]

//屏幕与视图的高度
#define SCREEN_WIDTH [UIScreen mainScreen].bounds.size.width
#define SCREEN_HEIGHT [UIScreen mainScreen].bounds.size.height
#define PORTRAIT_SCREEN_WIDTH MIN(SCREEN_WIDTH, SCREEN_HEIGHT)
#define PORTRAIT_SCREEN_HEIGHT MAX(SCREEN_WIDTH, SCREEN_HEIGHT)
#define LANDSCAPE_SCREEN_WIDTH MAX(SCREEN_WIDTH, SCREEN_HEIGHT)
#define LANDSCAPE_SCREEN_HEIGHT MIN(SCREEN_WIDTH, SCREEN_HEIGHT)
#define SCREEN_SCALE [UIScreen mainScreen].scale

#define ISIPAD (MAX(SCREEN_HEIGHT, SCREEN_WIDTH) > 1000)
#define SZT_NAVIGATIONBAR_HEIGHT (iPhoneX ? 88.f : 64.f)
#define SZT_STATUSBAR_HEIGHT (iPhoneX ? 44.f : 20.f)
#define SZT_STATUSBAR_HEIGHT_DIFF (iPhoneX ? 24.f : 0.f)
#define SZT_TABBAR_HEIGHT 49.f
#define SZT_TABBAR_BOTTOM_HEIGHT (iPhoneX?34.f:0.f)

#define SystemBackItemLeftMargin 16.f
#define SZTBackItemLeftMargin 5.f
#define SZTBackItemTopMargin 20.f
#define SZTBackItemSize CGSizeMake(44.f, 44.f)

//常用代码定义
typedef void(^ABCHandler)(void);
typedef void(^ABCSuccessHandler)(BOOL success);
typedef void(^ABCResultHandler)(BOOL success, NSError *error);

// * 常用代码简化
#define ImageWithName(imageName)  [UIImage imageNamed: imageName]
#define ABCRGBA(r, g, b, a) ([UIColor colorWithRed:r/255.f green:g/255.f blue:b/255.f alpha:a])

// * 常用字体类型
#define AWFONT_COMMON_NAME  @"ArialMT"
#define AWITALIC_FONT_COMMON_NAME  @"Arial-ItalicMT"
#define AWBOLD_FONT_COMMON_NAME  @"Arial-BoldMT"
#define AWBOLD_ITALIC_FONT_COMMON_NAME  @"Arial-BoldItalicMT"
#define AWFONT_HELVETICA_NAME  @"Helvetica"
#define AWFONT_HELVETICA_BOLD_NAME  @"Helvetica-Bold"
#define RezonFont  @"ReznorDownwardSpiral"
#define DINCondensed_Bold @"DINCondensed-Bold"

/*  ********* 颜色 ********* */
#define ABCDEEPBLACK ABCRGBA(51, 51, 51, 1.f)
#define ABCBLACK ABCRGBA(72, 72, 72, 1.f)
#define ABCBRIGHTBLACK ABCRGBA(128, 128, 128, 1.f)
#define ABCLIGHTBLACK ABCRGBA(208, 208, 208, 1.f)

// * 分割线粗度和颜色
#define ABCCOMMON_SPLIT_LINE_THICKNESS 0.5
#define ABCCOMMON_SPLIT_LINE_COLOR [UIColor colorWithRed:230.0/255 green:230.0/255 blue:230.0/255 alpha:1.0]

/**
 *  默认灰色图片
 */
#define TRPLACEHOLDER_IMAGE [UIImage imageWithColor:AWCOMMON_TEXT_COLOR_LIGHT_GRAY]

#endif /* ABCSimpleDefines_h */
