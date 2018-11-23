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

#define ABCMainColor ABCRGBA(49, 196, 16, 1)
#define ABCMainColorNormal ABCRGBA(102, 102, 102, 1)
#define ABCCommonBackColor ABCRGBA(248, 248, 248, 1.f)

#define ABCCommonTextColorBlack ABCRGBA(58, 58, 58, 1.f)
#define ABCCommonTextColorGray ABCRGBA(102, 102, 102, 1.f)

#define ABCImageViewPlaceHolderImage [UIImage imageWithColor:ABCRGBA(179, 179, 179, 1)] 

#endif /* ABCColorDefines_h */
