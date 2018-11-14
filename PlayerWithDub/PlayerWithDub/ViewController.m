//
//  ViewController.m
//  PlayerWithDub
//
//  Created by 泽泰 舒 on 2018/10/30.
//  Copyright © 2018年 泽泰 舒. All rights reserved.
//

#import <VideoToolbox/VideoToolbox.h>
#import <AVFoundation/AVFoundation.h>
#import "SZTPlayer.h"
#import "SZTPlayerView.h"

#import "ABCSRTParser.h"
#import "MP3Endocder.h"
#import "LocalFileManager.h"
#import "ABCMediaComposeUtil.h"

#import "ABCAudioRecorder.h"

#import "ABCDubViewController.h"

#import "AWVideoPlayerViewController.h"
#import "ViewController.h"

@interface ViewController () <SZTPlayerViewDelegate>

@property (nonatomic, strong) UIButton *composeBtn;
@property (nonatomic, strong) UIButton *recordBtn;
@property (nonatomic, strong) UIButton *playRecordBtn;
@property (nonatomic, strong) UIButton *mp3EncodeBtn;

@property (nonatomic, strong) AWVideoPlayerViewController *playerViewController;
@property (nonatomic, strong) AVAudioPlayer *musicPlayer;

@property (nonatomic, strong) SZTPlayer *player;
@property (nonatomic, strong) SZTPlayerView *playerView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [[UIApplication sharedApplication] setStatusBarStyle:(UIStatusBarStyleLightContent)];
    
    self.view.backgroundColor = [UIColor whiteColor];
//    [self.view addSubview:self.playerViewController.view];
    [self.view addSubview:self.playerView];
    self.navigationController.navigationBar.hidden = YES;
    
    [self addSubviews];
    
//    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"幻想中的无敌神鹰" ofType:@"srt"];
//    NSLog(@"开始解析srt文件");
//    [ABCSRTParser parserWithFilePath:filePath completion:^(NSArray<ABCCaptionSegment *> * _Nonnull captions, NSError * _Nullable error) {
//        if (error) {
//            NSLog(@"解析srt文件出错:%@", error);
//        }
//        else {
//            NSLog(@"完成解析srt文件");
//        }
//    }];
}

- (void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator {
    self.view.window.frame = CGRectMake(0, 0, size.width, size.height);
    self.navigationController.view.frame = CGRectMake(0, 0, size.width, size.height);
    self.view.frame = CGRectMake(0, 0, size.width, size.height);
//    [self.playerViewController setPlayerFrame:CGRectMake(0, 0, size.width, size.width*9.f/16.f)];
    self.playerView.frame = CGRectMake(0, 0, size.width, size.width*9.f/16.f);
}

- (void)recordTest {
    NSString *desPath = [[LocalFileManager libraryCacheDirectory] stringByAppendingPathComponent:@"recorder_mp3.caf"];
    NSLog(@"****** 开始录制");
    [ABCAudioRecorder startRecordWithUrl:desPath duration:20.f completion:^(BOOL success, NSError * _Nullable err) {
        NSLog(@"****** 结束录制");
        if (success) {
            [self mp3EncodeAndPlay];
        }
        else {
            NSLog(@"录制音频失败!");
        }
    }];
}

- (void)mp3EncodeAndPlay {
    NSString *pcmPath = [[LocalFileManager libraryCacheDirectory] stringByAppendingPathComponent:@"recorder_mp3.caf"];
    [self printSizeOfPath:pcmPath];
    [self printSizeOfPath:[LocalFileManager libraryCacheDirectory]];
    NSString *mp3Path = [[LocalFileManager libraryCacheDirectory] stringByAppendingPathComponent:@"recorder_mp3.mp3"];
    if ([LocalFileManager fileSizeAtPath:mp3Path] > 0) {
        [LocalFileManager removeLocalFileAtPath:mp3Path];
    }
    
    MP3EncodedRequest *encodeRequest = [[MP3EncodedRequest alloc] initWithPCMFilePath:pcmPath destionationFilePath:mp3Path];
    encodeRequest.sampleRate = (int)kABCDefaultSampleRate;
    MP3Endocder *mp3Encoder = [[MP3Endocder alloc] init];
    
    NSLog(@"****** 开始转码MP3");
    [mp3Encoder encodeMP3FileWithPCMFilePath:encodeRequest completion:^(BOOL success, NSError * _Nullable error) {
        NSLog(@"****** 结束转码MP3");
        if (success) {
            NSURL *audioUrl = [NSURL fileURLWithPath:mp3Path];
            NSURL *videoUrl = [[NSBundle mainBundle] URLForResource:@"幻想中的无敌神鹰" withExtension:@"mp4"];
            [self printSizeOfPath:mp3Path];
            [self composeVideo:audioUrl audio:videoUrl];
        }
        else {
            NSLog(@"PCM转MP3 失败了。");
        }
    }];
}

- (void)printSizeOfPath:(NSString *)path {
    NSUInteger fileSize = [LocalFileManager fileSizeAtPath:path];
    NSLog(@"path : %@, \n file size : %lu kb", path, fileSize/1024);
}

- (void)playNetworkVideo {
//    NSURL *url = [[NSBundle mainBundle] URLForResource:@"幻想中的无敌神鹰" withExtension:@"mp4"];
    NSURL *url = [NSURL URLWithString:TestVideoUrl];
    [self.playerView configUrl:url];
//    [self.playerView addPlayerLayer:self.player.playerLayer];
}

- (void)addPlayerView:(SZTPlayerView *)playerView {
    [self.view addSubview:playerView];
    playerView.frame = CGRectMake(0, 0, PORTRAIT_SCREEN_WIDTH, PORTRAIT_SCREEN_WIDTH*9.f/16.f);
}

- (SZTPlayer *)player {
    if (!_player) {
        _player = [[SZTPlayer alloc] init];
    }
    return _player;
}

- (SZTPlayerView *)playerView {
    if (!_playerView) {
        _playerView = [[SZTPlayerView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_WIDTH*9.f/16.f)];
        _playerView.backgroundColor = [UIColor redColor];
        _playerView.presentingViewController = self;
    }
    return _playerView;
}

- (void)playRecordTest {
    NSString *desPath = [[LocalFileManager libraryCacheDirectory] stringByAppendingPathComponent:@"recorder_mp3.caf"];
    [self playMusicWithUrl:[NSURL fileURLWithPath:desPath]];
}

- (void)playTest {
//    [self playComposedMP4];
    ABCDubViewController *dubViewController = [[ABCDubViewController alloc] init];
    [self presentViewController:dubViewController animated:YES completion:nil];
}

- (void)playComposedMP4 {
    NSURL *audioUrl = [[NSBundle mainBundle] URLForResource:@"丁满照看鸟宝宝" withExtension:@"mp3"];
    NSURL *videoUrl = [[NSBundle mainBundle] URLForResource:@"幻想中的无敌神鹰" withExtension:@"mp4"];
    [self composeVideo:audioUrl audio:videoUrl];
}

- (void)composeVideo:(NSURL *)audioUrl audio:(NSURL *)videoUrl {
    NSString *desPath = [[LocalFileManager libraryCacheDirectory] stringByAppendingPathComponent:@"compose_mp4.mp4"];
    NSURL *desUrl = [NSURL fileURLWithPath:desPath];
    
    [ABCMediaComposeUtil video:videoUrl composeWithAudio:audioUrl toUrl:desUrl completion:^(BOOL success, NSError * _Nullable err) {
        if (success) {
            [self.playerViewController readyForPlayingVideoWithURL:desUrl];
            [self.playerViewController play];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                NSLog(@"合成后的视频长度:%.3f second", self.playerViewController.totalDuration);
            });
        }
        else {
            NSLog(@"%@", err);
        }
    }];
}

- (void)playComposedMP3 {
    NSURL *url1 = [[NSBundle mainBundle] URLForResource:@"丁满照看鸟宝宝" withExtension:@"mp3"];
    NSURL *url2 = [[NSBundle mainBundle] URLForResource:@"幻想中的无敌神鹰" withExtension:@"mp3"];
    ABCMediaComposeUnit *unit1 = [[ABCMediaComposeUnit alloc] initWithUrl:url1 mediaType:AVMediaTypeAudio beginTime:CMTimeMake(15, 1) timeRange:CMTimeRangeMake(CMTimeMake(0, 1), kABCAssetTime)];
    ABCMediaComposeUnit *unit2 = [[ABCMediaComposeUnit alloc] initWithUrl:url2 mediaType:AVMediaTypeAudio beginTime:CMTimeMake(0, 1) timeRange:CMTimeRangeMake(CMTimeMake(0, 1), kABCAssetTime)];
    
    NSString *desPath = [[LocalFileManager libraryCacheDirectory] stringByAppendingPathComponent:@"compose_mp3.m4a"];
    NSURL *desUrl = [NSURL fileURLWithPath:desPath];
    
    [ABCMediaComposeUtil mixComposeAudiosWithUnits:@[unit1, unit2] toUrl:desUrl completion:^(BOOL success, NSError *err) {
        if (success) {
            [self playMusicWithUrl:desUrl];
        }
        else {
            NSLog(@"%@", err);
        }
    }];
}

- (void)playMusicWithUrl:(NSURL *)url {
    // 手机静音时播放声音
    AVAudioSession *audioSession = [AVAudioSession sharedInstance];
    [audioSession setCategory:AVAudioSessionCategoryPlayback error:nil];
    
    NSError *error;
    self.musicPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:&error];
    [self.musicPlayer prepareToPlay];
    [self.musicPlayer play];
    NSLog(@"合成后的视频长度:%.3f second", self.musicPlayer.duration);
}

- (void)play {
    NSURL *url = [[NSBundle mainBundle] URLForResource:@"帮我和我妈妈打个招呼" withExtension:@"mp4"];
    [self.playerViewController readyForPlayingVideoWithURL:url];
    self.playerViewController.volume = 0;
    [self.playerViewController play];
    [self.musicPlayer play];
}

- (void)addSubviews {
    [self.view addSubview:self.composeBtn];
    self.composeBtn.frame = CGRectMake(100, 400, 100, 50);
    [self.view addSubview:self.recordBtn];
    self.recordBtn.frame = CGRectMake(100, 460, 140, 50);
//
//    [self.view addSubview:self.mp3EncodeBtn];
//    self.mp3EncodeBtn.frame = CGRectMake(100, 520, 100, 50);
}

#pragma mark - lazy init
- (AWVideoPlayerViewController *)playerViewController {
    if (!_playerViewController) {
        CGSize screenSize = [UIScreen mainScreen].bounds.size;
        _playerViewController = [AWVideoPlayerViewController playerViewControllerWithFrame:CGRectMake(0, 0, screenSize.width, screenSize.width*9.f/16.f) playerControl:(AWVideoPlayerControlAll)];
    }
    return _playerViewController;
}

- (AVAudioPlayer *)musicPlayer {
    if (!_musicPlayer) {
        NSString *urlString = [[NSBundle mainBundle] pathForResource:@"帮我和我妈妈打个招呼" ofType:@"mp3"];
        NSError *error;
        _musicPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:[NSURL fileURLWithPath:urlString] error:&error];
        [_musicPlayer prepareToPlay];
    }
    return _musicPlayer;
}

- (UIButton *)composeBtn {
    if (!_composeBtn) {
        _composeBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
        
        [_composeBtn setTitle:@"开始合成" forState:(UIControlStateNormal)];
        [_composeBtn setTitleColor:[UIColor redColor] forState:(UIControlStateNormal)];
        [_composeBtn addTarget:self action:@selector(playTest) forControlEvents:(UIControlEventTouchUpInside)];
    }
    return _composeBtn;
}

- (UIButton *)recordBtn {
    if (!_recordBtn) {
        _recordBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
        
        [_recordBtn setTitle:@"播放网络视频" forState:(UIControlStateNormal)];
        [_recordBtn setTitleColor:[UIColor redColor] forState:(UIControlStateNormal)];
        [_recordBtn addTarget:self action:@selector(playNetworkVideo) forControlEvents:(UIControlEventTouchUpInside)];
    }
    return _recordBtn;
}

- (UIButton *)playRecordBtn {
    if (!_playRecordBtn) {
        _playRecordBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
        
        [_playRecordBtn setTitle:@"播放录制的音频" forState:(UIControlStateNormal)];
        [_playRecordBtn setTitleColor:[UIColor redColor] forState:(UIControlStateNormal)];
        [_playRecordBtn addTarget:self action:@selector(playRecordTest) forControlEvents:(UIControlEventTouchUpInside)];
    }
    return _playRecordBtn;
}

- (UIButton *)mp3EncodeBtn {
    if (!_mp3EncodeBtn) {
        _mp3EncodeBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
        
        [_mp3EncodeBtn setTitle:@"转码音频" forState:(UIControlStateNormal)];
        [_mp3EncodeBtn setTitleColor:[UIColor redColor] forState:(UIControlStateNormal)];
        [_mp3EncodeBtn addTarget:self action:@selector(mp3EncodeAndPlay) forControlEvents:(UIControlEventTouchUpInside)];
    }
    return _mp3EncodeBtn;
}

@end
