//
//  NSObject+APIAdd.h
//  PlayerWithDub
//
//  Created by 舒泽泰 on 2018/11/21.
//  Copyright © 2018 泽泰 舒. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSObject (APIAdd)

// Subclass override this class to handle api response data
- (void)handleApiResponseData:(id)responseObject forTask:(NSURLSessionDataTask *)task;

- (void)handleApiFailureWithError:(NSError *)error forTask:(NSURLSessionDataTask *)task;

- (void)handleApiProgress:(NSProgress *)progress;

@end

NS_ASSUME_NONNULL_END
