//
//  ABCSimpleDefines.h
//  PlayerWithDub
//
//  Created by 泽泰 舒 on 2018/11/5.
//  Copyright © 2018年 泽泰 舒. All rights reserved.
//

#ifndef ABCSimpleDefines_h
#define ABCSimpleDefines_h

#define SZTTIMESTRING(seconds) [NSString stringWithFormat:@"%02ld:%02ld:%02ld", seconds/3600, (seconds%3600)/60, seconds%60]

//常用代码定义
typedef void(^ABCHandler)(void);
typedef void(^ABCSuccessHandler)(BOOL success);
typedef void(^ABCResultHandler)(BOOL success, NSError *error);


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
#define TRPLACEHOLDER_IMAGE [UIImage imageWithColor:ABCRGBA(179, 179, 179, 1)]

#endif /* ABCSimpleDefines_h */
