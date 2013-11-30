//
//  VoteSearchResultCell.h
//  vote
//
//  Created by kuaijianghua on 11/16/13.
//  Copyright (c) 2013 rampageworks. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Vote.h"
#import "CellIndexCircle.h"

@interface VoteSearchResultCell : UIView{
    UIImageView *_arrowImageView;
}

@property(nonatomic, assign)NSInteger indexNumber;
@property(nonatomic, assign)VoteArrowColor arrowCorlor;
@property(nonatomic, strong)UILabel *initiatorLabel;
@property(nonatomic, strong)CellIndexCircle *indexCell;


@end
