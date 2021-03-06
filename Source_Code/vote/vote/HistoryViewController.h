//
//  HistoryViewController.h
//  vote
//
//  Created by Shine Zhao on 12/2/13.
//  Copyright (c) 2013 rampageworks. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"
#import "EGORefreshTableHeaderView.h"
#import "OptionView.h"
#import "HistoryResultCell.h"

@interface HistoryViewController : BaseViewController<UITableViewDataSource, UITableViewDelegate, EGORefreshTableDelegate,OptionViewDelegate,HistoryResultCellDelegate>

@property NSString *emailAddress;
@property (strong, nonatomic) UISegmentedControl *historySegment;
@property NSArray *voteHistoryArray;

- (IBAction)showOptionView:(id)sender;

@end
