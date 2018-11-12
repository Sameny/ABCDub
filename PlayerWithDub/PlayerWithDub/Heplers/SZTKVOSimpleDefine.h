//
//  SZTKVOSimpleDefine.h
//  PlayerWithDub
//
//  Created by 泽泰 舒 on 2018/11/12.
//  Copyright © 2018年 泽泰 舒. All rights reserved.
//

#ifndef SZTKVOSimpleDefine_h
#define SZTKVOSimpleDefine_h

// **** copy code from FBKVOController which link to "http//:www.github.com/FBKVOController"
/*
 This macro ensures that key path exists at compile time.
 Given a real receiver with a key path as you would call it, it verifies at compile time that the key path exists, without calling it.
 For example:
 
 SZTKVOKeyPath(string.length) => @"length"
 Or even the complex case:
 SZTKVOKeyPath(string.lowercaseString.length) => @"lowercaseString.length".
 */
#define SZTKVOKeyPath(KEYPATH) \
@(((void)(NO && ((void)KEYPATH, NO)), \
({ const char *fbkvokeypath = strchr(#KEYPATH, '.'); NSCAssert(fbkvokeypath, @"Provided key path is invalid."); fbkvokeypath + 1; })))

/**
 This macro ensures that key path exists at compile time.
 Given a receiver type and a key path, it verifies at compile time that the key path exists, without calling it.
 
 For example:
 SZTKVOClassKeyPath(NSString, length) => @"length"
 SZTKVOClassKeyPath(NSString, lowercaseString.length) => @"lowercaseString.length"
 */
#define SZTKVOClassKeyPath(CLASS, KEYPATH) \
@(((void)(NO && ((void)((CLASS *)(nil)).KEYPATH, NO)), #KEYPATH))


#endif /* SZTKVOSimpleDefine_h */
