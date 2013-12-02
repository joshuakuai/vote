//
//  VoteSearchResultCell.m
//  vote
//
//  Created by kuaijianghua on 11/16/13.
//  Copyright (c) 2013 rampageworks. All rights reserved.
//

#import "VoteSearchResultCell.h"

@implementation VoteSearchResultCell

- (id)init
{
    self = [super init];
    
    if (self) {
        //set frame
        self.frame = CGRectMake(0, 0, 320, 60);
        
        //index circle
        self.indexCell = [[CellIndexCircle alloc] initWithNumber:1 location:CGPointMake(20, 15)];
        self.indexNumber = 1;
        
        [self addSubview:self.indexCell];
        
        //add arrow
        _arrowImageView = [[UIImageView alloc] initWithFrame:CGRectMake(70, 10, 209, 40)];
        self.arrowCorlor = greenArrow;
        
        //set label
        self.initiatorLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, 180, 40)];
        self.initiatorLabel.text = [NSString stringWithFormat:@"Initiator: Unknow"];
        self.initiatorLabel.textColor = [UIColor whiteColor];
        [_arrowImageView addSubview:self.initiatorLabel];
        
        [self addSubview:_arrowImageView];
    }
    return self;
}

- (void)dealloc
{
    _arrowImageView = nil;
    self.initiatorLabel = nil;
    self.indexCell = nil;
}

- (void)setIndexNumber:(NSInteger)indexNumber
{
    _indexNumber = indexNumber;
    
    //set the lable text
    [self.indexCell setNumber:_indexNumber+1];
}

- (void)setArrowCorlor:(VoteArrowColor)arrowCorlor
{
    _arrowCorlor = arrowCorlor;
    
    //set the image of image view
    switch (_arrowCorlor) {
        case greenArrow:{
            _arrowImageView.image = [UIImage imageNamed:@"GreenSolidArrow"];
            break;
        }
            
        case yellowArrow:{
            _arrowImageView.image = [UIImage imageNamed:@"YellowSolidArrow"];
            break;
        }

        case redArrow:{
            _arrowImageView.image = [UIImage imageNamed:@"RedSolidArrow"];
            break;
        }

        case blueArrow:{
            _arrowImageView.image = [UIImage imageNamed:@"BlueSolidArrow"];
            break;
        }
            
        case grayArrow:{
            _arrowImageView.image = [UIImage imageNamed:@"GraySolidArrow"];
            break;
        }
            
        default:{
            _arrowImageView.image = [UIImage imageNamed:@"GreenSolidArrow"];
            break;
        }
    }
}

@end
