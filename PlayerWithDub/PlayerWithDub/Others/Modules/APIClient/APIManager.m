//
//  APIManager.m
//  PlayerWithDub
//
//  Created by 泽泰 舒 on 2018/11/20.
//  Copyright © 2018年 泽泰 舒. All rights reserved.
//

#import "APIRequestObject.h"

#import "APIClient.h"
#import "APIManager.h"

@interface APIManager ()

@property (nonatomic, strong) NSMutableDictionary <NSString *,APIPutParamObject *>*requestObjects;

@end

@implementation APIManager


@end


@implementation APIPutParamObject

- (BOOL)isValid {
    return self.fileUrl.isFileURL;
}

- (NSString *)name {
    return self.fileUrl.path;
}

- (NSString *)fileName {
    NSString *lastPathComponent = [self.fileUrl.pathComponents lastObject];
    if (lastPathComponent.pathExtension.length > 0) {
        return lastPathComponent;
    }
    NSString *pathExtension = szt_pathExtensionWithMineType(self.mineType);
    return [lastPathComponent stringByAppendingPathExtension:pathExtension];
}

@end
