//
//  ABCDubTableViewCell.h
//  PlayerWithDub
//
//  Created by 泽泰 舒 on 2018/11/5.
//  Copyright © 2018年 泽泰 舒. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ABCDubTableViewCell : UITableViewCell

@property (nonatomic, strong) ABCHandler recordHandler;

- (void)setCellWithIndex:(NSInteger)index count:(NSInteger)count enContent:(NSString *)enContent chContent:(NSString *)chContent;

- (void)setStartMilliSeconds:(NSInteger)start endMilliSeconds:(NSInteger)end;

@end

NS_ASSUME_NONNULL_END
