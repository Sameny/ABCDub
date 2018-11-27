//
//  ABCColorDefines.h
//  PlayerWithDub
//
//  Created by 泽泰 舒 on 2018/11/14.
//  Copyright © 2018年 泽泰 舒. All rights reserved.
//

#ifndef ABCColorDefines_h
#define ABCColorDefines_h

#define ABCRGBA(r, g, b, a) ([UIColor colorWithRed:r/255.f green:g/255.f blue:b/255.f alpha:a])
#define ABCHEXCOLOR(hexString) ([UIColor colorWithHexString:hexString])

#define ABCMainColor ABCRGBA(49, 196, 16, 1)  // #32C410
#define ABCMainColorNormal ABCRGBA(102, 102, 102, 1)
#define ABCCommonBackColor ABCRGBA(248, 248, 248, 1.f)

// 重要文字 （正文、标题、按钮）
#define ABCCommonTextColorBlack ABCRGBA(58, 58, 58, 1.f)
#define ABCCommonTextColorGray ABCRGBA(102, 102, 102, 1.f)
// 提示性文字 （正文、标题、按钮）
#define ABCCommonTextColorGreen ABCHEXCOLOR(@"#48B232")
// 重要文字 （正文、标题、按钮、tab）
#define ABCCommonTextColorWhite ABCHEXCOLOR(@"#FFFFFF")
// 辅助性文字 （按钮）
#define ABCCommonTextColorLightGray ABCHEXCOLOR(@"#999999")

#define ABCImageViewPlaceHolderImage [UIImage imageWithColor:ABCRGBA(179, 179, 179, 1)] 

#endif /* ABCColorDefines_h */
