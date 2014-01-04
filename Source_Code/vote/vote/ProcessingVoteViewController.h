//
//  ProcessingVoteViewController.h
//  vote
//
//  Created by kuaijianghua on 12/31/13.
//  Copyright (c) 2013 rampageworks. All rights reserved.
//

#import "BaseViewController.h"

@interface ProcessingVoteViewController : BaseViewController

//UI
@property (weak, nonatomic) IBOutlet UILabel *lefttimeLabel;
@property (weak, nonatomic) IBOutlet UIView *subjectView;
@property (weak, nonatomic) IBOutlet UILabel *subjectLabel;
@property (weak, nonatomic) IBOutlet UIView *optionView;
@property (weak, nonatomic) IBOutlet UILabel *voteidLabel;
@property (weak, nonatomic) IBOutlet UIImageView *userOptionImageView;
@property (weak, nonatomic) IBOutlet UILabel *pollNumberLabel;
@property (weak, nonatomic) IBOutlet UIView *voteInfoView;

//Data
@property (strong, nonatomic) NSArray *optionDictionaryArray;
@property (strong, nonatomic) NSString *subjectString;
@property (assign, nonatomic) NSInteger voteid;
@property (assign, nonatomic) NSInteger pollNumber;
@property (assign, nonatomic) NSInteger userSelectedOptionID;
@property (assign, nonatomic) NSInteger leftSeconds;

- (IBAction)showUserOption:(id)sender;
@end
