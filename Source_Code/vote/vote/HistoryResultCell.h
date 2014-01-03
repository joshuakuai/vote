//
//  HistoryResultCell.h
//  vote
//
//  Created by Shine Zhao on 12/24/13.
//  Copyright (c) 2013 rampageworks. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Vote.h"
#import "CellIndexCircle.h"

@class HistoryResultCell;

@protocol HistoryResultCellDelegate <NSObject>

- (void)historyResultCellArrowButtonTapped:(HistoryResultCell*)historyCell;

@end

@interface HistoryResultCell : UIView

@property(nonatomic, weak)id<HistoryResultCellDelegate> delegate;
@property(nonatomic, assign)NSInteger indexNumber;
@property(nonatomic, assign)VoteArrowColor arrowCorlor;
@property(nonatomic, strong)UILabel *timeLabel;;
@property(nonatomic, strong)UIButton *arrowButton;
@property(nonatomic, strong)UILabel *initiatorLabel;
@property(nonatomic, strong)UILabel *stateLabel;
@property(nonatomic, strong)CellIndexCircle *indexCell;


@end
