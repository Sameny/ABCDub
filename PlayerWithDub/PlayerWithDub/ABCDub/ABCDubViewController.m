//
//  ABCDubViewController.m
//  PlayerWithDub
//
//  Created by 泽泰 舒 on 2018/11/5.
//  Copyright © 2018年 泽泰 舒. All rights reserved.
//

#import <AVFoundation/AVFoundation.h>

#import "SZTSimpleDefines.h"
#import "ABCDubHelper.h"
#import "ControlHelper.h"

#import "ABCDubViewModel.h"
#import "ABCDubTableViewCell.h"

#import "ABCDubViewController.h"

@interface ABCDubViewController () <UITableViewDataSource, UITableViewDelegate, AVAudioPlayerDelegate, SZTPlayerViewDelegate>

@property (nonatomic, strong) AVAudioPlayer *musicPlayer;

@property (nonatomic, strong) UITableView *captionTableView;
@property (nonatomic, strong) UIButton *backBtn;
@property (nonatomic, strong) UITableViewCell *previewCell;
@property (nonatomic, assign) NSInteger numOfRows;

@property (nonatomic, strong) ABCDubViewModel *viewModel;

@property (nonatomic, strong) NSIndexPath *selectedIndexPath;
@property (nonatomic, strong) ABCCaptionSegment *selectedSegment;

@end

@implementation ABCDubViewController

- (void)configData {
    _mp4FilePath = [[NSBundle mainBundle] pathForResource:TestSourceName ofType:@"mp4"];
    _mp3FilePath = [[NSBundle mainBundle] pathForResource:TestSourceName ofType:@"mp3"];
    _srtFilePath = [[NSBundle mainBundle] pathForResource:TestSourceName ofType:@"srt"];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.captionTableView];
    [self.view addSubview:self.backBtn];
    [self configUI];
    [self configData];
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
    SZT_AdjustsScrollViewContentInsetNever(self, self.captionTableView);
#pragma clang diagnostic pop
    
    self.viewModel = [[ABCDubViewModel alloc] init];
    [self.viewModel configSrtFile:_srtFilePath completion:^(BOOL success) {
        if (success) {
            self.numOfRows = self.viewModel.captions.count + 1;
            [self.captionTableView reloadData];
            [self startPlay];
        }
    }];
}

- (void)dealloc {
    self.musicPlayer.delegate = nil;
}

- (void)startPlay {
    [self.playerView configUrl:[NSURL fileURLWithPath:_mp4FilePath]];
    [self updateSelectedIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
}

- (void)configUI {
    self.view.backgroundColor = [UIColor blueColor];
    self.captionTableView.frame = CGRectMake(0, self.playerView.height, PORTRAIT_SCREEN_WIDTH, PORTRAIT_SCREEN_HEIGHT - self.playerView.height);

    self.playerView.delegate = self;
}

#pragma mark - events
- (void)record {
    NSLog(@"开始录音");
    self.captionTableView.scrollEnabled = NO;
    NSString *fileName = [NSString stringWithFormat:@"%ld.mp3", self.selectedIndexPath.row];
    
    __weak typeof(self) weakself = self;
    [[ABCDubHelper sharedInstance] recordAudioWithResourceId:TestSourceId mp3FileName:fileName duration:self.selectedSegment.duration completion:^(NSURL *url, NSError *error) {
        if (url) {
            [weakself playAudioWithUrl:url];
        }
        else {
            NSLog(@"录制mp3出错:%@", error);
        }
        weakself.captionTableView.scrollEnabled = YES;
    }];
    self.playerView.volume = 0;
    [self.playerView seekToTimeWithSeconds:self.selectedSegment.startTime/1000.f completion:^(BOOL finish) {
    }];
}

- (void)playAudioWithUrl:(NSURL *)url {
    // 手机静音时播放声音
    AVAudioSession *audioSession = [AVAudioSession sharedInstance];
    [audioSession setCategory:AVAudioSessionCategoryPlayAndRecord error:nil];
    [audioSession overrideOutputAudioPort:AVAudioSessionPortOverrideSpeaker error:nil];
    
    NSError *error;
    self.musicPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:&error];
    [self.musicPlayer prepareToPlay];
    [self.musicPlayer play];
    self.musicPlayer.delegate = self;
    NSLog(@"音频长度:%.3f second", self.musicPlayer.duration);
    
    self.playerView.volume = 0;
    [self.playerView seekToTimeWithSeconds:self.selectedSegment.startTime/1000.f completion:^(BOOL finish) {
    }];
}

- (void)previewDub {
    [MBProgressHUD showHUDAddedTo:self.view.window animated:YES];
    __weak typeof(self) weakself = self;
    [[ABCDubHelper sharedInstance] composeWithResourceId:TestSourceId subAudioInfos:self.viewModel.captions completion:^(NSURL *url, NSError *error) {
        [MBProgressHUD hideHUDForView:weakself.view.window animated:YES];
        if (url) {
            [weakself playComposedVideoWithUrl:url];
        }
        else if (error.code == ABCMediaComposeErrorCodeEmptyMedia) {
            NSLog(@"合成视频和音频进行预览出错:%@", error);
        }
        else {
            NSLog(@"合成视频和音频进行预览出错");
        }
    }];
}

- (void)playComposedVideoWithUrl:(NSURL *)url {
    [self.playerView pause];
    SZTPlayerViewController *playerViewController = [[SZTPlayerViewController alloc] init];
    [playerViewController setVideoUrl:url];
    [self presentViewController:playerViewController animated:YES completion:nil];
}

- (void)backBtnDidClicked {
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - SZTPlayerViewDelegate
- (void)playerDidPlayAtSeconds:(NSTimeInterval)seconds {
    NSTimeInterval milliSeconds = seconds * 1000.f;
    if (self.selectedSegment.endTime <= milliSeconds) {
        [self.playerView seekToTimeWithSeconds:self.selectedSegment.startTime/1000.f completion:nil];
    }
}

#pragma mark - AVAudioPlayerDelegate
- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag {
    self.playerView.volume = 1.f;
    self.musicPlayer.delegate = nil;
}

- (void)audioPlayerDecodeErrorDidOccur:(AVAudioPlayer *)player error:(NSError *)error {
    self.playerView.volume = 1.f;
    self.musicPlayer.delegate = nil;
}

#pragma mark - UITableViewDataSource & UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.numOfRows;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row < self.numOfRows - 1) {
        ABCDubTableViewCell *cell = (ABCDubTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"ABCDubTableViewCell" forIndexPath:indexPath];
        ABCCaptionSegment *segment = [self.viewModel captionSegmentWithIndexPath:indexPath];
        [cell setCellWithIndex:indexPath.row + 1 count:self.viewModel.captions.count enContent:segment.en_content chContent:segment.ch_content];
        [cell setStartMilliSeconds:segment.startTime endMilliSeconds:segment.endTime];
        __weak typeof(self) weakself = self;
        cell.recordHandler = ^{
            [weakself record];
        };
        return cell;
    }
    else {
        return self.previewCell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self updateSelectedIndexPath:indexPath];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    [self adjustContentOffset];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    if (!decelerate) {
        [self adjustContentOffset];
    }
}

- (void)adjustContentOffset {
    CGFloat contentOffsetY = self.captionTableView.contentOffset.y;
    CGFloat position = contentOffsetY/self.captionTableView.rowHeight;
    NSInteger positionInt = (NSInteger)position;
    NSInteger cellIndex = positionInt + ((position - positionInt) > 0.4? 1:0);
    
    [self updateSelectedIndexPath:[NSIndexPath indexPathForRow:cellIndex inSection:0]];
}

- (void)updateSelectedIndexPath:(NSIndexPath *)selectedIndexPath {
    if (selectedIndexPath.row < self.numOfRows - 1) {
        UITableViewCell *cell = [self.captionTableView cellForRowAtIndexPath:_selectedIndexPath];
        [cell setSelected:NO animated:YES];
        
        _selectedIndexPath = selectedIndexPath;
        [self.captionTableView scrollToRowAtIndexPath:selectedIndexPath atScrollPosition:(UITableViewScrollPositionTop) animated:YES];
        
        self.selectedSegment = [self.viewModel captionSegmentWithIndexPath:_selectedIndexPath];
        [self.playerView seekToTimeWithSeconds:self.selectedSegment.startTime/1000.f completion:nil];
        
        cell = [self.captionTableView cellForRowAtIndexPath:_selectedIndexPath];
        [cell setSelected:YES animated:YES];
    }
}

#pragma mark - table view
- (UITableView *)captionTableView {
    if (!_captionTableView) {
        _captionTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 0, 0) style:(UITableViewStyleGrouped)];
        [_captionTableView registerClass:[ABCDubTableViewCell class] forCellReuseIdentifier:@"ABCDubTableViewCell"];
        _captionTableView.rowHeight = 200.f;
        _captionTableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 0.01)];
        _captionTableView.dataSource = self;
        _captionTableView.delegate = self;
        _captionTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    return _captionTableView;
}

- (UIButton *)backBtn {
    if (!_backBtn) {
        _backBtn = [ControlHelper baseButtonAddtarget:self selector:@selector(backBtnDidClicked) image:nil imagePressed:nil title:@"返回" font:18.f textColor:[UIColor whiteColor] textBold:NO];
    }
    return _backBtn;
}

- (UITableViewCell *)previewCell {
    if (!_previewCell) {
        _previewCell = [[UITableViewCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:@"PreviewCell"];
        UIButton *previewBtn = [ControlHelper baseButtonAddtarget:self selector:@selector(previewDub) image:nil imagePressed:nil title:@"预览配音" font:18.f textColor:[UIColor greenColor] textBold:YES];
        [_previewCell.contentView addSubview:previewBtn];
        [previewBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(0);
            make.top.mas_equalTo(20.f);
            make.size.mas_equalTo(CGSizeMake(100.f, 40.f));
        }];
        previewBtn.layer.cornerRadius = 10.f;
    }
    return _previewCell;
}

#pragma mark - orentation
- (BOOL)shouldAutorotate {
    return YES;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskPortrait;
}

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation {
    return UIInterfaceOrientationPortrait;
}

@end
