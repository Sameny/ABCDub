//
//  SZTBannerView.m
//  PlayerWithDub
//
//  Created by 泽泰 舒 on 2018/11/14.
//  Copyright © 2018年 泽泰 舒. All rights reserved.
//

@interface SZTBannerPieceView : UIView
@property (nonatomic, strong) UIImageView *imageView;
- (void)setBannerWithImageUrl:(NSString *)url;
@end

#import "SZTPageControl.h"
#import "SZTBannerView.h"
@interface SZTBannerView () <UIScrollViewDelegate>

@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) SZTPageControl *pageControl;
@property (nonatomic, strong) NSMutableArray *pieceViews;

@property (nonatomic, strong) UITapGestureRecognizer *tap;

@property (nonatomic, strong) NSTimer *autoScrollTimer;
@property (nonatomic, assign) BOOL enableAutoScroll;
@property (nonatomic, assign) NSInteger index;

@end

@implementation SZTBannerView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _index = 0;
        [self configUI];
    }
    return self;
}

- (void)setUrls:(NSArray <NSString *>*)urls {
    _urls = [urls mutableCopy];
    CGFloat width = self.scrollView.bounds.size.width;
    CGFloat height = self.scrollView.bounds.size.height;
    if (urls.count > 1) {
        self.scrollView.contentSize = CGSizeMake(width * (_urls.count + 2), height);
    }
    for (SZTBannerPieceView *piece in self.pieceViews) {
        [piece removeFromSuperview];
    }
    [self.pieceViews removeAllObjects];
    
    for (NSInteger i = 0; i < _urls.count; i++) {
        if (_urls.count > 1 && i == 0) { // 第一帧为最后一张图
            NSString *last_url = [_urls lastObject];
            [self addOneBannerWithUrl:last_url frame:CGRectMake(0, 0, width, height)];
        }
        
        // 设置中间的帧
        NSString *url = _urls[i];
        [self addOneBannerWithUrl:url frame:CGRectMake((i+1)*width, 0, width, height)];
        
        // 最后一帧为第一张图
        if (_urls.count > 1 && i == _urls.count - 1) {
            NSString *first_url = [_urls firstObject];
            [self addOneBannerWithUrl:first_url frame:CGRectMake((_urls.count + 1)*width, 0, width, height)];
        }
    }
    
    self.pageControl.numberOfPages = _urls.count;
    self.scrollView.bounds = CGRectMake(width, 0, width, height);
    if (!_autoScrollTimer && _enableAutoScroll) {
        [self startScroll];
    }
}

- (void)startScroll {
    _enableAutoScroll = YES;
    if (self.pieceViews.count < 2) {
        return;
    }
    if (!_autoScrollTimer) {
        [[NSRunLoop mainRunLoop] addTimer:self.autoScrollTimer forMode:NSDefaultRunLoopMode];
    }
}

- (void)stopScroll {
    _enableAutoScroll = NO;
    if (_autoScrollTimer) {
        [self.autoScrollTimer invalidate];
        self.autoScrollTimer = nil;
    }
}

- (void)addOneBannerWithUrl:(NSString *)url frame:(CGRect)frame {
    SZTBannerPieceView *pieceView = [[SZTBannerPieceView alloc] initWithFrame:frame];
    [pieceView setBannerWithImageUrl:url];
    [self.scrollView addSubview:pieceView];
    [self.pieceViews addObject:pieceView];
}

static NSTimeInterval kBannerAutoScrollInterval = 3.5f;
- (NSTimer *)autoScrollTimer {
    if (!_autoScrollTimer) {
        __weak typeof(self) weakself = self;
        _autoScrollTimer = [NSTimer timerWithTimeInterval:kBannerAutoScrollInterval block:^(NSTimer * _Nonnull timer) {
            [weakself autoScroll];
        } repeats:YES];
    }
    return _autoScrollTimer;
}

- (void)autoScroll {
    if (self.pieceViews.count < 2) {
        return;
    }
    self.index++;
    CGFloat animationDuration = 0.5;
    CGSize scrollViewSize = self.scrollView.bounds.size;
    if (self.index >= self.pieceViews.count - 1) { // 到最后一帧
        CGRect desBounds = CGRectMake(self.index * scrollViewSize.width, 0, scrollViewSize.width, scrollViewSize.height);
        [UIView animateWithDuration:animationDuration animations:^{
            self.scrollView.bounds = desBounds;
        } completion:^(BOOL finished) {
            if (finished) {
                // 滑动到第二帧
                CGRect desBounds = CGRectMake(scrollViewSize.width, 0, scrollViewSize.width, scrollViewSize.height);
                self.scrollView.bounds = desBounds;
            }
        }];
        self.index = 1;
    }
    else {
        CGRect desBounds = CGRectMake(self.index * scrollViewSize.width, 0, scrollViewSize.width, scrollViewSize.height);
        [UIView animateWithDuration:animationDuration animations:^{
            self.scrollView.bounds = desBounds;
        }];
    }
    [self updatePageControl];
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(banner:didScrollToIndex:)]) {
        [self.delegate banner:self didScrollToIndex:self.pageControl.currentPage];
    }
}

- (void)updatePageControl {
    NSInteger currentPage = 0;
    if (self.index == 0) {
        currentPage = self.pieceViews.count - 1;
    }
    else if (self.index == self.pieceViews.count) {
        
    }
    //    else if (self.index == 1) {
    //        currentPage = 0;
    //    }
    //    else if (self.index == self.pieceViews.count) {
    //        currentPage = self.pieceViews.count - 1;
    //    }
    else {
        currentPage = self.index - 1;
    }
    self.pageControl.currentPage = currentPage;
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGSize scrollViewSize = self.scrollView.bounds.size;
    CGFloat offsetX = scrollView.contentOffset.x;
    self.index = offsetX/scrollView.bounds.size.width;
    if (self.pieceViews.count < 2) {
        return;
    }
    if (self.index >= self.pieceViews.count - 1) {
        CGRect desBounds = CGRectMake(scrollViewSize.width, 0, scrollViewSize.width, scrollViewSize.height);
        self.scrollView.bounds = desBounds;
        self.index = 1;
    }
    else if (self.index == 0) {
        self.index = self.pieceViews.count - 1;
        CGRect desBounds = CGRectMake(self.index*scrollViewSize.width, 0, scrollViewSize.width, scrollViewSize.height);
        self.scrollView.bounds = desBounds;
    }
    
    [self updatePageControl];
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    if (_autoScrollTimer) {
        [self.autoScrollTimer invalidate];
        self.autoScrollTimer = nil;
    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    if (_enableAutoScroll) {
        [self startScroll];
    }
}

#pragma mark - sub views
- (void)configUI {
    [self addSubview:self.scrollView];
    [self addSubview:self.pageControl];
    
    self.scrollView.frame = self.bounds;
    self.pageControl.frame = CGRectMake(self.bounds.size.width/2 - 90, self.bounds.size.height - 10 - 20, 180, 20);
    
    [self.scrollView addGestureRecognizer:self.tap];
    
    if(@available(iOS 11.0, *)) {
        self.scrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }
}

- (UIScrollView *)scrollView {
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc] init];
        _scrollView.pagingEnabled = YES;
        _scrollView.delegate = self;
        _scrollView.bounces = NO;
        _scrollView.showsHorizontalScrollIndicator = NO;
    }
    return _scrollView;
}

- (SZTPageControl *)pageControl {
    if (!_pageControl) {
        _pageControl = [[SZTPageControl alloc] init];
        _pageControl.dotSize = CGSizeMake(8.f, 8.f);
        _pageControl.selectedDotSize = CGSizeMake(8.f, 8.f);
        _pageControl.pageIndicatorTintColor = [[UIColor whiteColor] colorWithAlphaComponent:0.4];
        _pageControl.currentPageIndicatorTintColor = [UIColor whiteColor];
    }
    return _pageControl;
}

- (UITapGestureRecognizer *)tap {
    if (!_tap) {
        __weak typeof(self) weakself = self;
        _tap = [[UITapGestureRecognizer alloc] initWithActionBlock:^(id  _Nonnull sender) {
            if (weakself.delegate && [weakself.delegate respondsToSelector:@selector(banner:didSelectedAtIndex:)]) {
                [weakself.delegate banner:weakself didSelectedAtIndex:weakself.pageControl.currentPage];
            }
        }];
    }
    return _tap;
}

#pragma mark - lazy init
- (NSMutableArray<SZTBannerPieceView *> *)pieceViews {
    if (!_pieceViews) {
        _pieceViews = [[NSMutableArray alloc] init];
    }
    return _pieceViews;
}

@end


@implementation SZTBannerPieceView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.imageView];
        self.imageView.frame = self.bounds;
    }
    return self;
}

- (void)setBannerWithImageUrl:(NSString *)url {
    [self.imageView sd_setImageWithURL:[NSURL URLWithString:url] placeholderImage:TRPLACEHOLDER_IMAGE];
}

#pragma mark - sub views
- (UIImageView *)imageView {
    if (!_imageView) {
        _imageView = [[UIImageView alloc] init];
        _imageView.backgroundColor = [UIColor colorWithRed:179.0/255 green:179.0/255 blue:179.0/255 alpha:1.0];
    }
    return _imageView;
}

@end
