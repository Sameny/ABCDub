//
//  ABCSimpleDefines.h
//  PlayerWithDub
//
//  Created by 泽泰 舒 on 2018/11/5.
//  Copyright © 2018年 泽泰 舒. All rights reserved.
//

#ifndef ABCSimpleDefines_h
#define ABCSimpleDefines_h

#import "ABCColorDefines.h"
#import "ABCFontDefines.h"

//常用代码定义
typedef void(^ABCHandler)(void);
typedef void(^ABCSuccessHandler)(BOOL success);
typedef void(^ABCResultHandler)(BOOL success, NSError *error);

// * 分割线粗度和颜色
#define ABCCOMMON_SPLIT_LINE_THICKNESS 0.5
#define ABCCOMMON_SPLIT_LINE_COLOR [UIColor colorWithRed:230.0/255 green:230.0/255 blue:230.0/255 alpha:1.0]

/**
 *  默认灰色图片
 */
#define TRPLACEHOLDER_IMAGE [UIImage imageWithColor:ABCRGBA(179, 179, 179, 1)]

#endif /* ABCSimpleDefines_h */
