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
@property (nonatomic, assign) BOOL canResponseToTime;

@property (nonatomic, strong) dispatch_queue_t loaderQueue;

@end

@implementation SZTPlayer

- (void)dealloc {
    [self clear];
}

// in main queue
- (void)configUrl:(NSURL *)url {
    [self clear];
    self.url = url;
    
    [self updateStatus:SZTPlayerStatusWaiting];
    
    self.isLocalFile = [url.scheme isEqualToString:@"file"];
    AVPlayerItem *item;
    NSString *cachedFilePath = [SZTPlayerFileHandle cacheFileExistsWithURL:url];
    if (self.isLocalFile || cachedFilePath) {
        AVAsset *asset = [AVAsset assetWithURL:url];
        item = [[AVPlayerItem alloc] initWithAsset:asset];
        
        if (_delegate && [_delegate respondsToSelector:@selector(player:didCompletedCacheToUrl:)]) {
            [_delegate player:self didCompletedCacheToUrl:cachedFilePath];
        }
    }
    else {
        SZTResourceLoader *resourceLoader = [[SZTPlayerResourceManager sharedInstance] resourceLoaderWithUrl:url.absoluteString];
        AVURLAsset *asset = [AVURLAsset URLAssetWithURL:url options:nil];
        [asset.resourceLoader setDelegate:resourceLoader queue:self.loaderQueue];
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
    if (self.player.status == AVPlayerStatusReadyToPlay) {
        [self.player play];
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
    [resourceLoader cancelDownloadAndClearTemp];
    
    self.url = nil;
    self.player = nil;
    [self updateStatus:SZTPlayerStatusNotConfigUrl];
}

- (void)seekToTimeWithSeconds:(NSTimeInterval)seconds completion:(void(^)(BOOL finish))completion {
    if (self.player) {
        SZTResourceLoader *resourceLoader = [[SZTPlayerResourceManager sharedInstance] existsResourceLoaderWithUrl:self.url.absoluteString];
        resourceLoader.isSeek = YES;
        if (!resourceLoader) {
            return;
        }
        __weak typeof(self) weakself = self;
        [self.player.currentItem cancelPendingSeeks];
        [self.player seekToTime:CMTimeMakeWithSeconds(seconds, NSEC_PER_SEC) completionHandler:^(BOOL finished) {
            NSLog(@"seekComplete!!");
            if (finished) {
                if (weakself.status != SZTPlayerStatusPaused) {
                    [weakself.player play];
                }
            }
            if (completion) {
                completion(finished);
            }
        }];
    }
}

- (void)setDelegate:(id<SZTPlayerDelegate>)delegate {
    _delegate = delegate;
    _canResponseToTime = [delegate respondsToSelector:@selector(player:didPlayAtSeconds:)];
}

- (void)updatePlayerProgressWithTime:(CMTime)time {
    if (self.canResponseToTime) {
        NSTimeInterval seconds = (NSTimeInterval)CMTimeGetSeconds(time);
        [self.delegate player:self didPlayAtSeconds:seconds];
    }
}

- (void)updateStatus:(SZTPlayerStatus)status {
    _status = status;
    if (_delegate && [_delegate respondsToSelector:@selector(player:playerStatusDidChanged:)]) {
        [_delegate player:self playerStatusDidChanged:status];
    }
}

- (NSTimeInterval)totalSeconds {
    CMTime totalTime = [self playerItemDuration];
    return CMTimeGetSeconds(totalTime);
}

- (dispatch_queue_t)loaderQueue {
    if (!_loaderQueue) {
        _loaderQueue = dispatch_queue_create("player loader queue", DISPATCH_QUEUE_CONCURRENT);
    }
    return _loaderQueue;
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
                if (_status == SZTPlayerStatusBuffering) { // 完成缓冲
                    if (_delegate && [_delegate respondsToSelector:@selector(playerDidCompletedBuffer)]) {
                        [_delegate playerDidCompletedBuffer];
                    }
                }
                [self updateStatus:SZTPlayerStatusPlaying];
                [self addPlayerTimeObservers];
            }
            else {
                if (_status != SZTPlayerStatusPaused) { // 开始缓冲
                    if (_delegate && [_delegate respondsToSelector:@selector(playerWillPauseForStartBuffer)]) {
                        [_delegate playerWillPauseForStartBuffer];
                    }
                }
                [self updateStatus:SZTPlayerStatusBuffering];
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
                [self stop];
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
                if (totalBuffer > CMTimeGetSeconds(self.player.currentTime)) {
                    if (_status == SZTPlayerStatusBuffering) { // 完成缓冲
                        if (_delegate && [_delegate respondsToSelector:@selector(playerDidCompletedBuffer)]) {
                            [_delegate playerDidCompletedBuffer];
                        }
                    }
                    [self updateStatus:SZTPlayerStatusPlaying];
                    [self play];
                }
                if (_delegate && [_delegate respondsToSelector:@selector(player:didUpdateCachedProgress:)]) {
                    CGFloat progress = self.totalSeconds > 0?totalBuffer/self.totalSeconds:0;
                    [_delegate player:self didUpdateCachedProgress:progress];
                }
            }
        }
    }
}

- (void)playerOccurError:(NSError *)error {
    // TODO: error occur
    NSLog(@"self.player.error:%@", error);
    SZTResourceLoader *resourceLoader = [[SZTPlayerResourceManager sharedInstance] existsResourceLoaderWithUrl:self.url.absoluteString];
    [resourceLoader cancelDownloadAndClearTemp];
    [self updateStatus:SZTPlayerStatusError];
    if (_delegate && [_delegate respondsToSelector:@selector(player:didOccurError:)]) {
        [_delegate player:self didOccurError:error];
    }
}

#pragma mark - get
- (BOOL)isPlaying {
    return self.player.rate > 0;
}

- (CMTime)playerItemDuration {
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
        __weak typeof(self) weakself = self;
        self.timeObserver = [self.player addPeriodicTimeObserverForInterval:CMTimeMake(1, 1) queue:dispatch_get_main_queue() usingBlock:^(CMTime time) {
            [weakself updatePlayerProgressWithTime:time];
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
    if (_delegate && [_delegate respondsToSelector:@selector(player:didCompletedCacheToUrl:)]) {
        [_delegate player:self didCompletedCacheToUrl:[loader getCachedFileUrl]];
    }
}

@end
