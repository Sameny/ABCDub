//
//  ABCCommonEntryCell.m
//  PlayerWithDub
//
//  Created by 泽泰 舒 on 2018/11/16.
//  Copyright © 2018年 泽泰 舒. All rights reserved.
//

#import "ABCCommonCollectionView.h"
#import "ABCCommonEntryCell.h"

@interface ABCCommonEntryCell () <UICollectionViewDelegate>

@property (nonatomic, strong) ABCCommonCollectionView *collectionView;

@end

@implementation ABCCommonEntryCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self configUI];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self configUI];
    }
    return self;
}

- (void)setFrame:(CGRect)frame {
    [super setFrame:frame];
    self.collectionView.frame = CGRectMake(0, 0, self.width, self.height);
}

- (void)setData:(NSArray<ABCCommonCollectionViewItemData *> *)data {
    self.collectionView.data = data;
}

#pragma mark - UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (self.selectedHandler) {
        self.selectedHandler(indexPath.row);
    }
}

#pragma mark - UI
- (void)configUI {
    [self.contentView addSubview:self.collectionView];
}

- (ABCCommonCollectionView *)collectionView {
    if (!_collectionView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        layout.minimumLineSpacing = 0;
        layout.minimumInteritemSpacing = 0;
        layout.sectionInset = UIEdgeInsetsMake(0, 10, 0, 10);
        
        _collectionView = [[ABCCommonCollectionView alloc] initWithFrame:CGRectMake(0, 0, self.width, self.height) collectionViewLayout:layout];
        _collectionView.cellClass = NSClassFromString(@"ABCCommonEntryCollectionViewCell");
        _collectionView.itemSize = CGSizeMake(0, self.height);
        _collectionView.delegate = self;
    }
    return _collectionView;
}

@end
