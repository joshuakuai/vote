//
//  HistoryViewController.h
//  vote
//
//  Created by Shine Zhao on 12/2/13.
//  Copyright (c) 2013 rampageworks. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"
#import "OptionView.h"

@interface HistoryViewController : BaseViewController<OptionViewDelegate>

@property NSString *emailAddress;
@property (strong, nonatomic) UISegmentedControl *historySegment;
@property NSArray *voteHistoryArray;

@end
