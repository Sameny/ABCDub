//
//  APIDefines.h
//  PlayerWithDub
//
//  Created by 泽泰 舒 on 2018/11/20.
//  Copyright © 2018年 泽泰 舒. All rights reserved.
//

#ifndef APIDefines_h
#define APIDefines_h

typedef void(^APIClientCompletion)(NSURLSessionDataTask *task, id responseObject);
typedef void(^APIClientFaildHandler)(NSURLSessionDataTask *task, NSError *error);
typedef void(^APIClientProgressHandler)(NSProgress *progress);

#endif /* APIDefines_h */
