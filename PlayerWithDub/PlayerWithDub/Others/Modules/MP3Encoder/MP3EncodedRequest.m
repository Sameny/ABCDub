//
//  MP3EncodedRequest.m
//  PlayerWithDub
//
//  Created by 泽泰 舒 on 2018/11/2.
//  Copyright © 2018年 泽泰 舒. All rights reserved.
//

#import "MP3EncodedRequest.h"

@implementation MP3EncodedRequest

- (instancetype)initWithPCMFilePath:(NSString *)pcmFilePath destionationFilePath:(NSString *)destionationPath {
    self = [super init];
    if (self) {
        _pcmFilePath = pcmFilePath;
        _mp3FilePath = destionationPath;
        
        _sampleRate = 22050;
        _channels = 2;
        _bitRate = 16;
    }
    return self;
}

- (BOOL)isValid {
    if (!_pcmFilePath || _pcmFilePath.length == 0) {
        return NO;
    }
    if (!_mp3FilePath || _mp3FilePath.length == 0) {
        return NO;
    }
    return [[NSFileManager defaultManager] fileExistsAtPath:_pcmFilePath];
}

@end
