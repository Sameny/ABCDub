//
//  ABCCommonCollectionViewCell.m
//  PlayerWithDub
//
//  Created by 泽泰 舒 on 2018/11/15.
//  Copyright © 2018年 泽泰 舒. All rights reserved.
//

#import "ABCCommonCollectionViewCell.h"

@interface ABCCommonCollectionViewCell ()

@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UILabel *titleLabel;

@end

@implementation ABCCommonCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self configUI];
    }
    return self;
}

- (void)setCellWithCellItemData:(__kindof ABCCommonCollectionViewItemData *)itemData {
    UIImage *image;
    if ([itemData.imageUrl hasPrefix:@"file//:"]) {
        image = [UIImage imageWithContentsOfFile:itemData.imageUrl];
    }
    if (!image) {
        image = [UIImage imageNamed:itemData.imageUrl];
    }
    if (!image) {
        [self.imageView sd_setImageWithURL:[NSURL URLWithString:itemData.imageUrl]];
    }
    else {
        self.imageView.image = image;
    }
    self.titleLabel.text = itemData.title;
}

- (void)setCellWithImage:(UIImage *)image title:(NSString *)title {
    self.imageView.image = image;
    self.titleLabel.text = title;
}

- (void)setCellWithImageUrl:(NSString *)imageUrl title:(NSString *)title {
    UIImage *image = [UIImage imageNamed:imageUrl];
    if (image) {
        self.imageView.image = image;
    }
    else {
        [self.imageView sd_setImageWithURL:[NSURL URLWithString:imageUrl]];
    }
    self.titleLabel.text = title;
}

#pragma mark - UI
- (void)configUI {
    [self.contentView addSubview:self.imageView];
    [self.contentView addSubview:self.titleLabel];
}

- (UIImageView *)imageView {
    if (!_imageView) {
        _imageView = [[UIImageView alloc] init];
        _imageView.image = ABCImageViewPlaceHolderImage;
    }
    return _imageView;
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.font = [UIFont fontWithName:ABCFontNamePingFangSC size:12.f];
        _titleLabel.textColor = ABCRGBA(58, 58, 58, 1);
    }
    return _titleLabel;
}

+ (NSString *)abc_reuseId {
    return NSStringFromClass([self class]);
}

@end

