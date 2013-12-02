//
//  AttendVoteViewController.h
//  vote
//
//  Created by Shine Zhao on 12/2/13.
//  Copyright (c) 2013 rampageworks. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"

@interface AttendVoteViewController : BaseViewController<PLServerDelegate>

@property int indexOfColor;
@property int leftMinutes;

//subject
@property NSString *subject;
//option array
@property (strong, nonatomic)NSArray *optionArray;

@end
