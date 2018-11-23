//
//  SZTSimpleDefines.h
//  PlayerWithDub
//
//  Created by 泽泰 舒 on 2018/11/15.
//  Copyright © 2018年 泽泰 舒. All rights reserved.
//

#ifndef SZTSimpleDefines_h
#define SZTSimpleDefines_h

// * 常用代码简化
#define ImageWithName(imageName)  [UIImage imageNamed: imageName]
#define SZTWeakself(self) __weak typeof(self) weak##self = self

#pragma mark - define - log
#ifdef DEBUG
#define DebugLog(...) NSLog(@"%s 第%d行 \n %@\n\n", __func__, __LINE__, [NSString stringWithFormat:__VA_ARGS__])
#define DebugFunctionLog() NSLog(@"\n==============================================================================\nclassName : %s\nclassFunction : %s\nclassFunctionLine : %d\n==============================================================================", object_getClassName(self),__PRETTY_FUNCTION__,__LINE__)
#else
#define DebugLog(...) /* */
#define DebugFunctionLog(...) /* */
#endif

// iOS 11 scrollView适配
/// 第一个参数是当下的控制器适配iOS11 一下的，第二个参数表示scrollview或子类
#define SZT_AdjustsScrollViewContentInsetNever(controller,view) if(@available(iOS 11.0, *) && view) {view.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;} else if([controller isKindOfClass:[UIViewController class]]) {controller.automaticallyAdjustsScrollViewInsets = NO;}

#define SZT_APP_VERSION [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"]
#define SZT_IPHONE_VERSION [[UIDevice currentDevice] systemVersion]

//屏幕与视图的高度
#define SCREEN_WIDTH [UIScreen mainScreen].bounds.size.width
#define SCREEN_HEIGHT [UIScreen mainScreen].bounds.size.height
#define PORTRAIT_SCREEN_WIDTH MIN(SCREEN_WIDTH, SCREEN_HEIGHT)
#define PORTRAIT_SCREEN_HEIGHT MAX(SCREEN_WIDTH, SCREEN_HEIGHT)
#define LANDSCAPE_SCREEN_WIDTH MAX(SCREEN_WIDTH, SCREEN_HEIGHT)
#define LANDSCAPE_SCREEN_HEIGHT MIN(SCREEN_WIDTH, SCREEN_HEIGHT)
#define SCREEN_SCALE [UIScreen mainScreen].scale

#define iPhoneX (PORTRAIT_SCREEN_WIDTH == 375 || PORTRAIT_SCREEN_WIDTH == 414)
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
typedef void(^SZTHandler)(void);
typedef void(^SZTSuccessHandler)(BOOL success);
typedef void(^SZTResultHandler)(BOOL success, NSError *error);

#endif /* SZTSimpleDefines_h */
