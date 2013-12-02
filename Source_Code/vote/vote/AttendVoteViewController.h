//
//  AttendVoteViewController.h
//  vote
//
//  Created by Shine Zhao on 12/2/13.
//  Copyright (c) 2013 rampageworks. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AttendVoteViewController : UIViewController

@property int indexOfColor;
//TODO: time
//subject
@property NSString *sujectContent;
//option array
@property (strong, nonatomic)NSArray *optionArray;

@end
