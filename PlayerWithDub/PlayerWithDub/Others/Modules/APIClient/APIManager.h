//
//  APIManager.h
//  PlayerWithDub
//
//  Created by 泽泰 舒 on 2018/11/20.
//  Copyright © 2018年 泽泰 舒. All rights reserved.
//

#import <Foundation/Foundation.h>


NS_ASSUME_NONNULL_BEGIN

@interface APIManager : NSObject



@end


extern NSString * const kSZTImageMineType;
extern NSString * const kSZTMP3MineType;
extern NSString * const kSZTMP4MineType;

@interface APIPutParamObject : NSObject

@property (nonatomic, strong) NSURL *fileUrl;
@property (nonatomic, copy) NSString *mineType;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *fileName;

- (BOOL)isValid;

@end

NS_ASSUME_NONNULL_END
