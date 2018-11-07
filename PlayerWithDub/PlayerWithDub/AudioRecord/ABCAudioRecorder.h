//
//  ABCAudioRecord.h
//  PlayerWithDub
//
//  Created by 泽泰 舒 on 2018/10/31.
//  Copyright © 2018年 泽泰 舒. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
typedef void(^ABCMediaRecordCompletion)(BOOL success, NSError * _Nullable err);
extern NSInteger const kABCDefaultSampleRate;

@interface ABCAudioRecorder : NSObject

+ (void)startRecordWithUrl:(NSString *)url duration:(NSTimeInterval)duration completion:(ABCMediaRecordCompletion)completion;
+ (void)stopRecordWithDeleteRecording:(BOOL)delete;

@end

NS_ASSUME_NONNULL_END
