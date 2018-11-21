//
//  MP3Endocder.m
//  PlayerWithDub
//
//  Created by 泽泰 舒 on 2018/11/2.
//  Copyright © 2018年 泽泰 舒. All rights reserved.
//

#import "ABCError.h"
#import "lame.h"
#import "MP3Endocder.h"


@interface MP3Endocder ()

@property (nonatomic, strong) dispatch_queue_t encoderQueue;
@property (nonatomic, assign) BOOL stopRecord;

@end

@implementation MP3Endocder

- (void)encodeMP3FileWithPCMFilePath:(MP3EncodedRequest *)request completion:(MP3EncoderCompletion)completion {
    if (!request || ![request isValid]) {
        if (completion) {
            completion(NO, [NSError errorWithDomain:MP3EncoderErrorDomain code:MP3EncoderErrorCodeFilePathInvalid userInfo:@{NSLocalizedDescriptionKey:MP3EncoderErrorFilePathInvalid}]);
        }
        return;
    }
    FILE *pcmFile;
    FILE *mp3File;
    lame_t lameClient;
    pcmFile = fopen(request.pcmFilePath.UTF8String, "rb");
    if (pcmFile) {
        fseek(pcmFile, 4*1024,  SEEK_CUR); //skip file header 跳过 PCM header 能保证录音的开头没有噪音
        if ([[NSFileManager defaultManager] fileExistsAtPath:request.mp3FilePath]) {
            [[NSFileManager defaultManager] createFileAtPath:request.mp3FilePath contents:nil attributes:nil];
        }
        mp3File = fopen(request.mp3FilePath.UTF8String, "wb+");
    }
    else {
        if (completion) {
            completion(NO, [NSError errorWithDomain:MP3EncoderErrorDomain code:MP3EncoderErrorCodeFilePathInvalid userInfo:@{NSLocalizedDescriptionKey:MP3EncoderErrorFilePathInvalid, NSLocalizedFailureReasonErrorKey:@"MP3Encoder : PCM文件路径有误!"}]);
        }
        return;
    }
    if (mp3File) {
        lameClient = lame_init();
        lame_set_in_samplerate(lameClient, request.sampleRate);
        lame_set_out_samplerate(lameClient, request.sampleRate);
        lame_set_num_channels(lameClient, request.channels);
        lame_set_brate(lameClient, request.bitRate);
        lame_set_VBR(lameClient, vbr_default);
        lame_init_params(lameClient);
    }
    else {
        fclose(pcmFile);
        if (completion) {
            completion(NO, [NSError errorWithDomain:MP3EncoderErrorDomain code:MP3EncoderErrorCodeFilePathInvalid userInfo:@{NSLocalizedDescriptionKey:MP3EncoderErrorFilePathInvalid, NSLocalizedFailureReasonErrorKey:@"MP3Encoder : MP3文件路径有误!"}]);
        }
        return;
    }
    
    dispatch_async(self.encoderQueue, ^{
        // 以下为编码部分
        @try {
            const int pcm_size = 8192; // 3kb
            const int mp3_size = 8192;
            short int pcm_buffer[pcm_size*2];
            unsigned char mp3_buffer[mp3_size];
            int read, write;
            
            do {
                read = (int)fread(pcm_buffer, 2*sizeof(short int), pcm_size, pcmFile);
                if (read == 0) {
                    write = lame_encode_flush(lameClient, mp3_buffer, mp3_size);
                }
                else {
                    write = lame_encode_buffer_interleaved(lameClient, pcm_buffer, read, mp3_buffer, mp3_size);
                }
                fwrite(mp3_buffer, write, 1, mp3File);
            } while (read != 0);
            
            //写入Mp3 VBR Tag，不是必须的步骤,不写的话，播放器读取时长可能会出现错误
            lame_mp3_tags_fid(lameClient, mp3File);
            
            // 关闭文件，释放资源
            lame_close(lameClient);
            fclose(pcmFile);
            fclose(mp3File);
        } @catch (NSException *exception) {
            if (completion) {
                completion(NO, [NSError errorWithDomain:MP3EncoderErrorDomain code:MP3EncoderErrorCodeOccurException userInfo:@{NSLocalizedDescriptionKey:MP3EncoderErrorOccurException, NSLocalizedFailureReasonErrorKey:[exception description]}]);
            }
        } @finally {
            if (completion) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    completion(YES, nil);
                });
            }
        }
    });
}

- (dispatch_queue_t)encoderQueue {
    if (!_encoderQueue) {
        _encoderQueue = dispatch_queue_create([@"com.abc.mp3_encoder.queue" UTF8String], DISPATCH_QUEUE_SERIAL);
    }
    return _encoderQueue;
}

@end
