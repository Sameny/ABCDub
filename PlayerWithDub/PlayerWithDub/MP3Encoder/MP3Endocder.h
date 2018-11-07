//
//  MP3Endocder.h
//  PlayerWithDub
//
//  Created by 泽泰 舒 on 2018/11/2.
//  Copyright © 2018年 泽泰 舒. All rights reserved.
//

#import "MP3EncodedRequest.h"

NS_ASSUME_NONNULL_BEGIN

typedef void(^MP3EncoderCompletion)(BOOL success, NSError * _Nullable error);

@interface MP3Endocder : NSObject

- (void)encodeMP3FileWithPCMFilePath:(MP3EncodedRequest *)request completion:(MP3EncoderCompletion)completion;

@end

NS_ASSUME_NONNULL_END
