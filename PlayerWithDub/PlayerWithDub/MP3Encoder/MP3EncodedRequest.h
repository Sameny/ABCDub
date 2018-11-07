//
//  MP3EncodedRequest.h
//  PlayerWithDub
//
//  Created by 泽泰 舒 on 2018/11/2.
//  Copyright © 2018年 泽泰 舒. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MP3EncodedRequest : NSObject

@property (nonatomic, strong) NSString *pcmFilePath;
@property (nonatomic, strong) NSString *mp3FilePath; // destination path

@property (nonatomic, assign) int sampleRate;
@property (nonatomic, assign) int channels;
@property (nonatomic, assign) int bitRate;

- (instancetype)initWithPCMFilePath:(NSString *)pcmFilePath destionationFilePath:(NSString *)destionationPath;
- (BOOL)isValid;

@end

NS_ASSUME_NONNULL_END
