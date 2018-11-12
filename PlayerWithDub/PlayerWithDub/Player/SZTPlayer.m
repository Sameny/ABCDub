//
//  SZTPlayer.m
//  PlayerWithDub
//
//  Created by 泽泰 舒 on 2018/11/9.
//  Copyright © 2018年 泽泰 舒. All rights reserved.
//

#import "SZTPlayerFileHandle.h"
#import "SZTPlayerResourceManager.h"
#import <AVFoundation/AVFoundation.h>
#import "SZTPlayer.h"

@interface SZTPlayer () <SZTResourceLoaderDelegate>

@property (nonatomic, strong) AVPlayer *player;
@property (nonatomic, strong) NSURL *url;
@property (nonatomic, strong) AVPlayerLayer *playerLayer;
@property (nonatomic, strong) id timeObserver;

@property (nonatomic, assign) BOOL isLocalFile;

@end

@implementation SZTPlayer

- (void)dealloc {
    [self clear];
}

// in main queue
- (void)configUrl:(NSURL *)url {
    self.url = url;
    
    [self clear];
    _status = SZTPlayerStatusWaiting;
    
    self.isLocalFile = [url.scheme isEqualToString:@"file"];
    AVPlayerItem *item;
    if (self.isLocalFile || [SZTPlayerFileHandle cacheFileExistsWithURL:url]) {
        AVAsset *asset = [AVAsset assetWithURL:url];
        item = [[AVPlayerItem alloc] initWithAsset:asset];
    }
    else {
        SZTResourceLoader *resourceLoader = [[SZTPlayerResourceManager sharedInstance] resourceLoaderWithUrl:url.absoluteString];
        AVURLAsset *asset = [AVURLAsset URLAssetWithURL:url options:nil];
        [asset.resourceLoader setDelegate:resourceLoader queue:dispatch_get_main_queue()];
        resourceLoader.delegate = self;
        item = [AVPlayerItem playerItemWithAsset:asset];
    }
    self.player = [[AVPlayer alloc] initWithPlayerItem:item];
    
    if (self.playerLayer) {
        self.playerLayer.player = self.player;
    }
    else {
        self.playerLayer = [AVPlayerLayer playerLayerWithPlayer:_player];
        self.playerLayer.frame = [UIScreen mainScreen].bounds;
        // 设置播放窗口和当前视图之间的比例显示内容
        self.playerLayer.videoGravity = AVLayerVideoGravityResizeAspect;
    }
    self.player.volume = 1.0f;
    self.player.actionAtItemEnd = AVPlayerActionAtItemEndNone;
    
    [self addObserversForPlayer];
    [self addObserverForPlayerItem:item];
    [self playIfPossible];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playerInterrupted:) name:AVAudioSessionInterruptionNotification object:nil];
}

- (void)playIfPossible {
    if (self.isPlaying == NO){
        [self play];
    }
}

- (void)play {
    if (self.player.rate != 1.0) {
        self.player.rate = 1.0;
        // 手机静音时允许播放声音
        AVAudioSession *audioSession = [AVAudioSession sharedInstance];
        [audioSession setCategory:AVAudioSessionCategoryPlayAndRecord error:nil];
        [[AVAudioSession sharedInstance] overrideOutputAudioPort:AVAudioSessionPortOverrideSpeaker error:nil];
    }
}

- (void)pause {
    if (self.isPlaying) {
        [self.player pause];
    }
}

- (void)stop {
    [self.player pause];
}

- (void)clear {
    [self removeObserversForPlayer];
    [self removeObserverForPlayerItem:self.player.currentItem];
    
    SZTResourceLoader *resourceLoader = [[SZTPlayerResourceManager sharedInstance] existsResourceLoaderWithUrl:self.url.absoluteString];
    [resourceLoader cancelDownloadAndClear:YES];
    
    self.url = nil;
    self.player = nil;
    _status = SZTPlayerStatusNotConfigUrl;
}

- (void)seekToTimeWithSeconds:(double)seconds {
    if (self.player) {
        SZTResourceLoader *resourceLoader = [[SZTPlayerResourceManager sharedInstance] existsResourceLoaderWithUrl:self.url.absoluteString];
        resourceLoader.isSeek = YES;
        [self.player seekToTime:CMTimeMakeWithSeconds(seconds, 1000)];
    }
}

#pragma mark - observer handlers
- (void)playerItemDidReachEnd:(AVPlayerItem *)item {
    
}

- (void)playerInterrupted:(NSNotification *)notification {
    //通知类型
    NSDictionary * info = notification.userInfo;
    if ([[info objectForKey:AVAudioSessionInterruptionTypeKey] integerValue] == AVAudioSessionInterruptionTypeBegan) {
        [self.player pause];
    }else{
        [self.player play];
    }
}

#pragma mark - Key Value Observing
- (void)observeValueForKeyPath:(NSString*)path
                      ofObject:(id)object
                        change:(NSDictionary*)change
                       context:(void*)context{
    if(object == self.player) {
        if ([path isEqualToString:SZTKVOClassKeyPath(AVPlayer, rate)]){
            float newRate = [[change objectForKey:NSKeyValueChangeNewKey] floatValue];
            BOOL willPlay = (newRate != 0.f);
            if(willPlay){
                [self addPlayerTimeObservers];
            }
        }
        else if ([path isEqualToString:SZTKVOClassKeyPath(AVPlayer, status)]){
            AVPlayerStatus status = self.player.status;
            if (status == AVPlayerStatusReadyToPlay) {
                [self playIfPossible];
            } else if (status == AVPlayerStatusFailed) {
                [self stop];
                [self playerOccurError:self.player.error];
            }
        }
    }
    else if(object == self.player.currentItem) {
        if ([path isEqualToString:SZTKVOClassKeyPath(AVPlayerItem, status)]){
            AVPlayerItemStatus status = [[change objectForKey:NSKeyValueChangeNewKey] integerValue];
            if(status == AVPlayerItemStatusReadyToPlay){
                [self addPlayerTimeObservers];
                [self playIfPossible];
            }
            else if(status == AVPlayerItemStatusFailed){
                [self playerOccurError:self.player.currentItem.error];
            }
        }
        else if ([path isEqualToString:SZTKVOClassKeyPath(AVPlayerItem, loadedTimeRanges)]) {
            NSArray *timeRanges = (NSArray *)[change objectForKey:NSKeyValueChangeNewKey];
            if (timeRanges && [timeRanges count]) {
                // TODO: update progress
                CMTimeRange timeRange = [timeRanges.firstObject CMTimeRangeValue]; //本次缓冲的时间范围
                NSTimeInterval totalBuffer = CMTimeGetSeconds(timeRange.start) + CMTimeGetSeconds(timeRange.duration); //缓冲总长度
                NSLog(@"共缓冲%.2f",totalBuffer);
            }
        }
    }
}

- (void)playerOccurError:(NSError *)error {
    // TODO: error occur
    NSLog(@"self.player.error:%@", error);
    SZTResourceLoader *resourceLoader = [[SZTPlayerResourceManager sharedInstance] existsResourceLoaderWithUrl:self.url.absoluteString];
    [resourceLoader cancelDownloadAndClear:NO];
}

#pragma mark - get
- (BOOL)isPlaying {
    return self.player.rate > 0;
}

- (CMTime)playerItemDuration{
    AVPlayerItem *playerItem = [self.player currentItem];
    if (playerItem.status == AVPlayerItemStatusReadyToPlay){
        return([playerItem duration]);
    }
    return(kCMTimeInvalid);
}

#pragma mark - observer
- (void)addObserversForPlayer {
    if(self.player){
        [self.player addObserver:self
                      forKeyPath:SZTKVOClassKeyPath(AVPlayer, status)
                         options:NSKeyValueObservingOptionInitial | NSKeyValueObservingOptionNew
                         context:NULL];
        [self.player addObserver:self
                      forKeyPath:SZTKVOClassKeyPath(AVPlayer, rate)
                         options:NSKeyValueObservingOptionInitial | NSKeyValueObservingOptionNew
                         context:NULL];
    }
}

- (void)removeObserversForPlayer {
    if(self.player){
        [self.player removeObserver:self forKeyPath:SZTKVOClassKeyPath(AVPlayer, rate)];
        [self.player removeObserver:self forKeyPath:SZTKVOClassKeyPath(AVPlayer, status)];
        [self removePlayerTimeObservers];
    }
}

- (void)addPlayerTimeObservers {
    [self removePlayerTimeObservers];
    if (!self.timeObserver) {
        self.timeObserver = [self.player addPeriodicTimeObserverForInterval:CMTimeMake(1, 1) queue:dispatch_get_main_queue() usingBlock:^(CMTime time) {
            // TODO: handler the block
        }];
    }
}

- (void)removePlayerTimeObservers {
    if (self.timeObserver) {
        [self.player removeTimeObserver:self.timeObserver];
        self.timeObserver = nil;
    }
}

- (void)addObserverForPlayerItem:(AVPlayerItem *)item {
    if (item) {
        [item addObserver:self
               forKeyPath:SZTKVOKeyPath(item.status)
                  options:NSKeyValueObservingOptionNew
                  context:NULL];
        
        [item addObserver:self
               forKeyPath:SZTKVOKeyPath(item.loadedTimeRanges)
                  options:NSKeyValueObservingOptionNew
                  context:NULL];
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(playerItemDidReachEnd:)
                                                     name:AVPlayerItemDidPlayToEndTimeNotification
                                                   object:item];
    }
}

- (void)removeObserverForPlayerItem:(AVPlayerItem *)item {
    if(item){
        [item removeObserver:self forKeyPath:SZTKVOKeyPath(item.status)];
        [item removeObserver:self forKeyPath:SZTKVOKeyPath(item.loadedTimeRanges)];
        [[NSNotificationCenter defaultCenter] removeObserver:self
                                                        name:AVPlayerItemDidPlayToEndTimeNotification
                                                      object:item];
    }
}

#pragma mark - SZTResourceLoaderDelegate
- (void)resourceLoader:(SZTResourceLoader *)loader didBufferToProgress:(double)progress {
    NSLog(@"已经下载到了：%.3f", progress);
}

- (void)resourceLoader:(SZTResourceLoader *)loader didCompleteWithSuccess:(BOOL)success error:(NSError *)error {
    
}

@end
