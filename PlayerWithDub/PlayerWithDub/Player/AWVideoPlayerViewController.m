//
//  AWVideoPlayerViewController.m
//  Treadmill
//
//  Created by 泽泰 舒 on 16/8/3.
//  Copyright © 2016年 杭州匠物科技. All rights reserved.
//

#import <AVFoundation/AVFoundation.h>

#import "AWVideoPlayerViewController.h"

@interface AWVideoPlayerViewController ()

@property (nonatomic, weak) IBOutlet UIView *playerContainer;
/**
 *  控制视频播放的控件
 */
@property (weak, nonatomic) IBOutlet UISlider *progressSlider;

@property (nonatomic, weak) IBOutlet UIView *playerToolsView;

@property (nonatomic, weak) IBOutlet UIButton *centerBtn;
@property (nonatomic, weak) IBOutlet UILabel *playedTimeLabel;
@property (nonatomic, weak) IBOutlet UILabel *playerRestLabal;
@property (nonatomic, weak) IBOutlet UIActivityIndicatorView *indicatorView;

@property (nonatomic, weak) IBOutlet UIView *bottomToolsView;
@property (nonatomic, weak) IBOutlet UIButton *leftBottomBtn;
@property (nonatomic, strong) UIImageView *placeHolderImageView;

@property (nonatomic) CGPoint startTouchPoint;
@property (nonatomic, strong) UITapGestureRecognizer *pauseTap;

/**
 *  声明播放视频的控件属性[既可以播放视频也可以播放音频]
 */
@property (nonatomic, strong) AVPlayer *player;
@property (nonatomic, strong) AVPlayerLayer *playerLayer;
@property (nonatomic, assign)id<NSObject> timeObserver;

@property (nonatomic) BOOL isPlaying;
@property (nonatomic) NSInteger waitingForHiddenBottomToolsViewSeconds;

@end

@implementation AWVideoPlayerViewController

+ (instancetype)playerViewControllerWithFrame:(CGRect)frame {
    AWVideoPlayerViewController *playerViewController = [[AWVideoPlayerViewController alloc] initWithNibName:@"AWVideoPlayerViewController" bundle:[NSBundle mainBundle]];
    if (playerViewController) {
        playerViewController.view.frame = frame; // 会触发viewDidLoad方法
        return playerViewController;
    }
    return nil;
}

+ (instancetype)playerViewControllerWithFrame:(CGRect)frame playerControl:(AWVideoPlayerControl)control {
    AWVideoPlayerViewController *playerViewController = [[AWVideoPlayerViewController alloc] initWithNibName:@"AWVideoPlayerViewController" bundle:[NSBundle mainBundle]];
    if (playerViewController) {
        playerViewController.view.frame = frame; // 会触发viewDidLoad方法
        playerViewController.playerControl = control;
        return playerViewController;
    }
    return nil;
}

- (void)loadView {
    [super loadView];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.progressSlider.value = 0;
    [self.progressSlider setThumbImage:[UIImage imageNamed:@"player_slideThumb.png"] forState:UIControlStateNormal];
    
    self.waitingForHiddenBottomToolsViewSeconds = -1; // 循环调用
    [self autoHiddenBottomToolsView];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playerPlayingAtEnd) name:AVPlayerItemDidPlayToEndTimeNotification object:nil];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    // 释放
    [self pause];
    [self releaseMySelf];
}

#pragma mark - property
- (void)setPlayerControl:(AWVideoPlayerControl)playerControl {
    _playerControl = playerControl;
    self.pauseTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(playerBtnClicked:)];
    self.pauseTap.numberOfTapsRequired = 2;
    [self.view addGestureRecognizer:self.pauseTap];
    [self setPlayerControlViews];
}

- (void)setEnableTouch:(BOOL)enableTouch {
    self.pauseTap.enabled = enableTouch;
}

- (CGFloat)volume {
    return self.player.volume;
}

- (void)setVolume:(CGFloat)volume {
    self.player.volume = volume;
}

- (NSTimeInterval)totalDuration {
    if (self.player.currentItem.duration.timescale == 0) {
        return 0;
    }
    return self.player.currentItem.duration.value*1.f/self.player.currentItem.duration.timescale;
}

- (void)setPlayerControlViews {
    switch (self.playerControl) {
        case AWVideoPlayerControlNone:
            self.playerToolsView.hidden = YES;
            break;
        case AWVideoPlayerControlCenterPlay:
            self.playerToolsView.hidden = NO;
            self.bottomToolsView.hidden = YES;
            break;
        case AWVideoPlayerControlAll:
            self.playerToolsView.hidden = NO;
            self.bottomToolsView.hidden = NO;
            break;
            
        default:
            break;
    }
}

- (void)readyForPlayVideoWithURLString:(NSString *)urlString {
    if (urlString.length == 0) {
        return;
    }
    NSURL *url = [NSURL fileURLWithPath:urlString];
    [self readyForPlayingVideoWithURL:url];
}

- (void)playVideoWithURLString:(NSString *)urlString {
    if (urlString.length == 0) {
        return;
    }
    // 设置播放的url
    NSURL *url = [NSURL fileURLWithPath:urlString];
    [self readyForPlayingVideoWithURL:url];
    if (url) {
        [self play];
    }
}

- (void)readyForPlayingVideoWithURL:(NSURL *)url {
    if (url) {
        AVAsset *asset = [AVAsset assetWithURL:url];
        AVPlayerItem *item = [[AVPlayerItem alloc] initWithAsset:asset];
//        AVPlayerItem *item = [[AVPlayerItem alloc] initWithURL:url];
        // 设置播放的项目
//        if (self.player) {
//            [self.player replaceCurrentItemWithPlayerItem:item];
//            self.playerLayer.player = self.player;
//        }
//        else {
        if (self.timeObserver) {
            [self.player removeTimeObserver:self.timeObserver];
            self.timeObserver = nil;
        }
        self.player = [[AVPlayer alloc] initWithPlayerItem:item];
        if (self.playerLayer) {
            self.playerLayer.player = self.player;
        }
        else {
            self.playerLayer = [AVPlayerLayer playerLayerWithPlayer:_player];
            self.playerLayer.frame = self.view.bounds;
            // 设置播放窗口和当前视图之间的比例显示内容
            self.playerLayer.videoGravity = AVLayerVideoGravityResizeAspect;
            [self.playerContainer.layer insertSublayer:self.playerLayer below:self.placeHolderImageView.layer];
        }
        self.player.volume = 1.0f;
        self.player.actionAtItemEnd = AVPlayerActionAtItemEndNone;
//        }
        
        [self setPlayerControlViewDisplayValues];
        [self setPlayerObserver];
    }
}

- (void)setPlayerControlViewDisplayValues {
    self.progressSlider.value = _playedDuration/self.totalDuration;
    NSInteger playedDuration_int = _playedDuration;
    NSInteger restDuration = self.totalDuration - _playedDuration;
    if (_playedDuration > 3600) {
        self.playedTimeLabel.text = [NSString stringWithFormat:@"%02ld:%02ld:%02ld", playedDuration_int/3600, (playedDuration_int%3600)/60, playedDuration_int%60];
    } else {
        self.playedTimeLabel.text = [NSString stringWithFormat:@"%02ld:%02ld", playedDuration_int/60, playedDuration_int%60];
    }
    if (restDuration > 3600) {
        self.playerRestLabal.text = [NSString stringWithFormat:@"%02ld:%02ld:%02ld", restDuration/3600, (restDuration%3600)/60, restDuration%60];
    } else {
        self.playerRestLabal.text = [NSString stringWithFormat:@"%02ld:%02ld", restDuration/60, restDuration%60];
    }
}

- (void)setPlayerObserver {
    if (self.timeObserver) {
        [self.player removeTimeObserver:self.timeObserver];
        self.timeObserver = nil;
    }
    __weak typeof(self) weakSelf = self;
    self.timeObserver = [self.player addPeriodicTimeObserverForInterval:CMTimeMake(1, 1) queue:dispatch_get_main_queue() usingBlock:^(CMTime time) {
        [weakSelf periodicTimeHandler:time];
    }];
}

- (void)setPlayerFrame:(CGRect)frame {
    self.view.frame = frame;
    self.playerLayer.frame = self.view.bounds;
    [self.view layoutIfNeeded];
}

- (void)periodicTimeHandler:(CMTime)time {
    if (_player.currentItem.status != AVPlayerItemStatusReadyToPlay) {
        return;
    }
    dispatch_async(dispatch_get_main_queue(), ^{
        NSTimeInterval playedTime = CMTimeGetSeconds(time);
        self->_playedDuration = playedTime;
        [self setPlayerControlViewDisplayValues];
        if ([self.delegate respondsToSelector:@selector(player:playingAtTime:)]) {
            [self.delegate player:self playingAtTime:playedTime*1000];
        }
    });
}

- (void)playerPlayingAtEnd {
    if ([self.delegate respondsToSelector:@selector(playerPlayingAtEnd:)]) {
        [self.delegate playerPlayingAtEnd:self];
    }
    else {
        [self pause];
    }
}

- (void)removePlayerObserver {
    if (self.timeObserver) {
        [self.player removeTimeObserver:self.timeObserver];
        self.timeObserver = nil;
    }
}

- (void)releaseMySelf {
    [self.player.currentItem.asset cancelLoading];
    [self.player.currentItem cancelPendingSeeks];
    [self removePlayerObserver];
    for (NSUInteger i = 0; i < self.playerContainer.layer.sublayers.count; i++) {
        CALayer *layer = self.playerContainer.layer.sublayers[i];
        if ([layer isKindOfClass:[AVPlayerLayer class]]) {
            [layer removeFromSuperlayer];
        }
    }
    self.player = nil;
}

#pragma mark - 按钮响应方法
- (IBAction)playerBtnClicked:(id)sender {
    if (self.player) {
        if (self.isPlaying) {
            [self pause];
        } else {
            [self play];
        }
    }
    
    if ([self.delegate respondsToSelector:@selector(playerCenterPlayButtonDidClicked:)]) {
        [self.delegate playerCenterPlayButtonDidClicked:self];
    }
    if ([self.delegate respondsToSelector:@selector(playerLeftBottomButtonDidClicked:)]) {
        [self.delegate playerLeftBottomButtonDidClicked:self];
    }
}

- (void)playWithBeginMilliSeconds:(NSTimeInterval)begin {
    NSTimeInterval totalDuration = self.totalDuration;
    if (self.player.status != AVPlayerStatusReadyToPlay || totalDuration == 0) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self playWithBeginMilliSeconds:begin];
        });
        return;
    }
    
    NSTimeInterval seconds = begin/1000.f;
    CMTime beginTime = CMTimeMakeWithSeconds(seconds, self.player.currentItem.duration.timescale);
    if (seconds >= totalDuration) {
        beginTime = kCMTimeZero;
    }
    [self.player seekToTime:beginTime completionHandler:^(BOOL finished) {
        if (finished) {
            [self play];
        }
    }];
    [self periodicTimeHandler:beginTime];
}

- (void)play {
    if (!self.player) {
        return;
    }
    if (self.placeHolderImageView && !self.placeHolderImageView.hidden) {
        self.placeHolderImageView.hidden = YES;
    }
    NSTimeInterval totalDuration = self.totalDuration;
    if (self.player.status == AVPlayerStatusReadyToPlay) {
        if (_playedDuration >= totalDuration) { // 从头开始播放
            [self.player seekToTime:kCMTimeZero completionHandler:^(BOOL finished) {
            }];
        }
        // 手机静音时允许播放声音
        AVAudioSession *audioSession = [AVAudioSession sharedInstance];
        [audioSession setCategory:AVAudioSessionCategoryPlayAndRecord error:nil];
        [audioSession overrideOutputAudioPort:AVAudioSessionPortOverrideSpeaker error:nil]; 
        
        [self.player play];
        self.isPlaying = YES;
        if (self.playerControl > AWVideoPlayerControlNone) {
            self.centerBtn.hidden = YES;
            if (!self.bottomToolsView.hidden) {
                self.waitingForHiddenBottomToolsViewSeconds = 3;
            }
        }
        [self.leftBottomBtn setImage:[UIImage imageNamed:@"player_pause.png"] forState:UIControlStateNormal];
    } else {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self play];
        });
    }
}

- (void)pause {
    if (self.player) {
        [self.player pause];
        self.isPlaying = NO;
        if (self.playerControl > AWVideoPlayerControlNone) {
            self.centerBtn.hidden = NO;
        }
        if (self.playerControl > AWVideoPlayerControlCenterPlay) {
            [self.leftBottomBtn setImage:[UIImage imageNamed:@"player_play.png"] forState:UIControlStateNormal];
        }
    }
}

- (void)showLoadingView {
    self.indicatorView.hidden = NO;
    if (self.playerControl > AWVideoPlayerControlNone) {
        self.centerBtn.hidden = YES;
    }
}

- (void)hiddenLoadingView {
    self.indicatorView.hidden = YES;
    if (self.playerControl > AWVideoPlayerControlNone) {
        self.centerBtn.hidden = NO;
    }
}

- (void)setPlaceHolderImage:(UIImage *)image {
    if (!self.placeHolderImageView) {
        self.placeHolderImageView = [[UIImageView alloc] initWithFrame:self.playerContainer.bounds];
        self.placeHolderImageView.contentMode = UIViewContentModeScaleToFill;
        self.placeHolderImageView.autoresizingMask = UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth;
        [self.playerContainer addSubview:self.placeHolderImageView];
    }
    
    self.placeHolderImageView.image = image;
}

#pragma mark - 改变进度
- (IBAction)changeProgress:(id)sender {
    if (self.totalDuration > 0) {
        //CMTimeMake(a,b) a表示当前时间，b表示每秒钟有多少帧
        [self.player seekToTime:CMTimeMakeWithSeconds(self.progressSlider.value*self.totalDuration, self.player.currentItem.duration.timescale) completionHandler:^(BOOL finished) {
            if (finished) {
                [self play];
            }
        }];
    }
}

#pragma mark - 滑动操作
static const CGFloat maxRateInDirection = 0.9; // 方向的最大偏差
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [super touchesBegan:touches withEvent:event];
    
    UITouch *touch = [touches anyObject];
    self.startTouchPoint = [touch locationInView:self.playerContainer];
    if (self.playerControl > AWVideoPlayerControlCenterPlay) {
        if (self.bottomToolsView.hidden) {
            [self showBottomToolsView];
        }
    }
}

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [super touchesMoved:touches withEvent:event];
    
    self.waitingForHiddenBottomToolsViewSeconds = 3;
    if (self.playerControl > AWVideoPlayerControlCenterPlay) {
        UITouch *touch = [touches anyObject];
        CGPoint newPoint = [touch locationInView:self.playerContainer];
        
        CGFloat deltaX = newPoint.x - self.startTouchPoint.x;
        CGFloat deltaY = newPoint.y - self.startTouchPoint.y;
        
        if (deltaY/deltaX < maxRateInDirection) { // 滑动控制进度
            self.progressSlider.value += deltaX /20.0 / self.totalDuration; // 每20个像素是一秒
            [self.player seekToTime:CMTimeMakeWithSeconds(self.progressSlider.value*self.totalDuration, self.player.currentItem.duration.timescale) completionHandler:^(BOOL finished) {
                if (finished) {
                    [self play];
                }
            }];
        }
    }
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [super touchesEnded:touches withEvent:event];
//    if (self.playerControl > AWVideoPlayerControlCenterPlay) {
//        if (self.bottomToolsView.hidden) {
//            [self showBottomToolsView];
//        } else {
//            [self hiddenBottomToolsView];
//        }
//    }
}

- (void)autoHiddenBottomToolsView {
    if (self.waitingForHiddenBottomToolsViewSeconds == -1) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self autoHiddenBottomToolsView];
        });
    } else if (self.waitingForHiddenBottomToolsViewSeconds == 0) { // 隐藏进度条
        [self hiddenBottomToolsView];
    } else {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            if (self.waitingForHiddenBottomToolsViewSeconds >= 0) {
                self.waitingForHiddenBottomToolsViewSeconds--;
                [self autoHiddenBottomToolsView];
            }
        });
    }
}

- (void)hiddenBottomToolsView {
    if (self.bottomToolsView.hidden) {
        return;
    }
    self.waitingForHiddenBottomToolsViewSeconds = 0;
    CGPoint center = self.bottomToolsView.center;
    CGSize size = self.bottomToolsView.bounds.size;
    [UIView animateWithDuration:0.5 animations:^{
        self.bottomToolsView.center = CGPointMake(center.x, center.y + size.height);
    } completion:^(BOOL finished) {
        if (finished) {
            self.bottomToolsView.hidden = YES;
        }
    }];
}

- (void)showBottomToolsView {
    if (!self.bottomToolsView.hidden) {
        return;
    }
    self.waitingForHiddenBottomToolsViewSeconds = 3;
    CGPoint center = self.bottomToolsView.center;
    CGSize size = self.bottomToolsView.bounds.size;
    self.bottomToolsView.hidden = NO;
    
    [UIView animateWithDuration:0.5 animations:^{
        self.bottomToolsView.center = CGPointMake(center.x, center.y - size.height);
    }];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:AVPlayerItemDidPlayToEndTimeNotification object:nil];
}

@end
