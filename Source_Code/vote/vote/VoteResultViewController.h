//
//  VoteResultViewController.h
//  vote
//
//  Created by kuaijianghua on 12/31/13.
//  Copyright (c) 2013 rampageworks. All rights reserved.
//

#import "BaseViewController.h"

@interface VoteResultViewController : BaseViewController

//UI
@property (weak, nonatomic) IBOutlet UILabel *initiatorName;
@property (weak, nonatomic) IBOutlet UILabel *includeLabel;
@property (weak, nonatomic) IBOutlet UILabel *winnerNumberLabel;
@property (weak, nonatomic) IBOutlet UILabel *subjectLabel;
@property (weak, nonatomic) IBOutlet UIView *subjectView;
@property (weak, nonatomic) IBOutlet UIView *optionView;
@property (weak, nonatomic) IBOutlet UIScrollView *voteinforView;
@property (weak, nonatomic) IBOutlet UIImageView *userOptionImageView;
@property (weak, nonatomic) IBOutlet UIImageView *participantListImageView;
@property (weak, nonatomic) IBOutlet UILabel *pollNumberLabel;
@property (weak, nonatomic) IBOutlet UIView *userChoiceView;
@property (weak, nonatomic) IBOutlet UIImageView *informationCircleImageView;

//Data
@property (strong, nonatomic) NSArray *optionDictionaryArray;
@property (strong, nonatomic) NSString *subjectString;
@property (assign, nonatomic) NSInteger voteid;
@property (assign, nonatomic) NSInteger pollNumber;
@property (assign, nonatomic) NSInteger userSelectedOptionID;
@property (retain, nonatomic) NSString *initiator;
@property (assign, nonatomic) NSInteger userSelectionOptionState;


- (IBAction)showUserSelection:(id)sender;
- (IBAction)showParticipantList:(id)sender;
@end
