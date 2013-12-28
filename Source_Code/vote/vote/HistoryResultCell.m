//
//  HistoryResultCell.m
//  vote
//
//  Created by Shine Zhao on 12/24/13.
//  Copyright (c) 2013 rampageworks. All rights reserved.
//

#import "HistoryResultCell.h"

@interface HistoryResultCell ()
{
    GLfloat _leftMargin;
    GLfloat _heightOftimeLabel;
    GLfloat _heightOfArrowButton;
    GLfloat _heightOfStateLabel;
    CGFloat _heightOfeachVoteImageView;
    UIView *_cellContentView;
}

@end

@implementation HistoryResultCell

- (id)init
{
    self = [super init];
    if (self) {
        // Initialization code
        _leftMargin = 40;
        _heightOftimeLabel = 15;
        _heightOfArrowButton = 50;
        _heightOfStateLabel = 15;
        _heightOfeachVoteImageView = _heightOftimeLabel + _heightOfArrowButton + _heightOfStateLabel;
        
        //the frame of each cell
        self.frame = CGRectMake(0, 0, 320, 70);
        
        //the container of a cell
        _cellContentView = [[UIView alloc] init];
        _cellContentView.frame = CGRectMake(11, 0, 298, 70);
        [self addSubview:_cellContentView];
        
        //index circle
        self.indexCell = [[CellIndexCircle alloc] initWithNumber:1 location:CGPointMake(0, 20)];
        self.indexNumber = 0;
        
        [_cellContentView addSubview:self.indexCell];
        
        //time label
        _timeLabel = [[UILabel alloc] init];
        _timeLabel.frame = CGRectMake(_leftMargin, 0, 200, _heightOftimeLabel);
        _timeLabel.textColor = [UIColor colorWithRed:0.0 green:0.443 blue:0.737 alpha:1.0];
        _timeLabel.font = [UIFont systemFontOfSize:12];
        _timeLabel.text = @"N/A";
        [_cellContentView addSubview:_timeLabel];
        
        //arrow button-- the main part
        _arrowButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _arrowButton.frame = CGRectMake(_leftMargin, _heightOftimeLabel, 298 - _leftMargin, _heightOfArrowButton);
        self.arrowCorlor = greenArrow;
        [_cellContentView addSubview:_arrowButton];
        
        //initiator label
        _initiatorLabel = [[UILabel alloc] init];
        _initiatorLabel.frame = CGRectMake(0, 0, 298 - _leftMargin, _heightOfArrowButton);
        _initiatorLabel.textColor = [UIColor whiteColor];
        _initiatorLabel.textAlignment = NSTextAlignmentCenter;
        _initiatorLabel.text = @"Initiator: N/A";
        [_arrowButton addSubview:_initiatorLabel];
        
        _stateLabel = [[UILabel alloc] init];
        _stateLabel.frame = CGRectMake(_leftMargin, _heightOftimeLabel + _heightOfArrowButton, 298 - _leftMargin, _heightOfStateLabel);
        _stateLabel.font = [UIFont systemFontOfSize:12];
        _stateLabel.textAlignment = NSTextAlignmentCenter;
        _stateLabel.textColor = [UIColor colorWithRed:0.0 green:0.443 blue:0.737 alpha:1.0];
        _stateLabel.text = @"N/A";
        [_cellContentView addSubview:_stateLabel];
        
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

- (void)setIndexNumber:(NSInteger)indexNumber
{
    _indexNumber = indexNumber;
    
    //set the lable text
    [self.indexCell setNumber:_indexNumber+1];
}

- (void)setSpecificTime:(NSString *)specificTime
{
    _timeLabel.text = specificTime;
}

- (void)setArrowCorlor:(VoteArrowColor)arrowCorlor
{
    _arrowCorlor = arrowCorlor;
    
    //set the image of image view
    switch (_arrowCorlor) {
        case greenArrow:{
            [_arrowButton setImage:[UIImage imageNamed:@"GreenSolidArrow"]  forState:UIControlStateNormal];
            [_arrowButton setImage:[UIImage imageNamed:@"GreenSolidArrow"]  forState:UIControlStateHighlighted];
            break;
        }
            
        case yellowArrow:{
            [_arrowButton setImage:[UIImage imageNamed:@"YellowSolidArrow"]  forState:UIControlStateNormal];
            [_arrowButton setImage:[UIImage imageNamed:@"YellowSolidArrow"]  forState:UIControlStateHighlighted];
            break;
        }
            
        case redArrow:{
            [_arrowButton setImage:[UIImage imageNamed:@"RedSolidArrow"]  forState:UIControlStateNormal];
            [_arrowButton setImage:[UIImage imageNamed:@"RedSolidArrow"]  forState:UIControlStateHighlighted];
            break;
        }
            
        case blueArrow:{
            [_arrowButton setImage:[UIImage imageNamed:@"BlueSolidArrow"]  forState:UIControlStateNormal];
            [_arrowButton setImage:[UIImage imageNamed:@"BlueSolidArrow"]  forState:UIControlStateHighlighted];
            break;
        }
            
        case grayArrow:{
            [_arrowButton setImage:[UIImage imageNamed:@"GraySolidArrow"]  forState:UIControlStateNormal];
            [_arrowButton setImage:[UIImage imageNamed:@"GraySolidArrow"]  forState:UIControlStateHighlighted];
            break;
        }
            
        default:{
            [_arrowButton setImage:[UIImage imageNamed:@"GreenSolidArrow"]  forState:UIControlStateNormal];
            [_arrowButton setImage:[UIImage imageNamed:@"GreenSolidArrow"]  forState:UIControlStateHighlighted];
            break;
        }
    }
}

- (void)setInitatorName:(NSString *)initatorName
{
    _initiatorLabel.text = initatorName;
}

- (void)setStateString:(NSString *)stateString
{
    _stateLabel.text = stateString;
}
@end
