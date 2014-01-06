//
//  VoteResultViewController.m
//  vote
//
//  Created by kuaijianghua on 12/31/13.
//  Copyright (c) 2013 rampageworks. All rights reserved.
//

#import "VoteResultViewController.h"
#import "UILabel+SizeCalculate.h"
#import "CellIndexCircle.h"

@interface VoteResultViewController (){
    BOOL _isShowingUserList;
    NSMutableArray *_userList;
    NSMutableArray *_nameLabelArray;
}

@end

@implementation VoteResultViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    //initial value
    self.subjectLabel.text = self.subjectString;
    self.userOptionImageView.userInteractionEnabled = YES;
    self.participantListImageView.userInteractionEnabled = YES;
    _isShowingUserList = NO;
    _userList = nil;
    
    self.voteinforView.contentSize = self.voteinforView.frame.size;
    
    //check if the user's vote is included
    if (self.userSelectionOptionState == -1) {
        self.includeLabel.text = @"You vote is canceled by the Admin.";
    }
    
    //calculate the left time
    self.initiatorName.text = self.initiator;
    
    //adjust the subject hegiht and the subject label height
    CGSize expectedSize = [self.subjectLabel perfectLabelSizeWithMaxSize:CGSizeMake(251, 300)];
    if (expectedSize.height < 21) {
        expectedSize.height = 21;
    }
    self.subjectLabel.frame = CGRectMake(self.subjectLabel.frame.origin.x, self.subjectLabel.frame.origin.y, expectedSize.width, expectedSize.height);
    
    CGFloat heightSub = expectedSize.height - 21;
    CGRect tmpRect = self.subjectView.frame;
    tmpRect.size.height += heightSub;
    self.subjectView.frame = tmpRect;
    
    //adjust the option view height and add option
    int indexNumber = 1;
    int winnerPollNumber = 0;
    int winnerIndexNumber = 1;
    for (NSDictionary *optionDic in self.optionDictionaryArray) {
        //calculate the y position
        CGFloat yPosition = (indexNumber-1)*32 + 21;
        
        //add index circle
        CellIndexCircle *indexCircle = [[CellIndexCircle alloc] initWithNumber:indexNumber location:CGPointMake(49, yPosition+1)];
        [self.optionView addSubview:indexCircle];
        
        //add option label
        UILabel *stringLabel = [[UILabel alloc] initWithFrame:CGRectMake(85, yPosition, 220, 32)];
        stringLabel.textColor = [UIColor colorWithRed:0.0 green:0.443 blue:0.737 alpha:1.0];
        stringLabel.text = [optionDic objectForKey:@"content"];
        [self.optionView addSubview:stringLabel];
        
        int pollNumber = [[optionDic objectForKey:@"pollnumber"] integerValue];
        if (pollNumber > winnerPollNumber) {
            winnerPollNumber = pollNumber;
            winnerIndexNumber = indexNumber;
        }
        
        indexNumber ++;
    }
    
    self.winnerNumberLabel.text = [NSString stringWithFormat:@"%d",winnerIndexNumber];
    
    tmpRect = self.subjectView.frame;
    tmpRect.size.height += (indexNumber-1)*32;
    self.optionView.frame = tmpRect;
    
    //set value to the vote information view
    self.pollNumberLabel.text = [NSString stringWithFormat:@"%d people voted. Name list:",self.pollNumber];
    
    //adjust the view position
    tmpRect = self.optionView.frame;
    tmpRect.origin.y = self.subjectView.frame.origin.y + self.subjectView.frame.size.height + 5;
    self.optionView.frame = tmpRect;
    
    tmpRect = self.userChoiceView.frame;
    tmpRect.origin.y = self.optionView.frame.origin.y + self.optionView.frame.size.height;
    self.userChoiceView.frame = tmpRect;
    
    tmpRect = self.voteinforView.frame;
    tmpRect.origin.y = self.userChoiceView.frame.origin.y + self.userChoiceView.frame.size.height;
    self.voteinforView.frame = tmpRect;
}

- (void)dealloc
{
    self.optionDictionaryArray = nil;
    self.subjectString = nil;
    self.initiator = nil;
}

- (IBAction)showUserSelection:(id)sender
{
    //add the index circle
    int indexNumber = 1;
    for (NSDictionary *optionDic in self.optionDictionaryArray) {
        int optionID = [[optionDic objectForKey:@"voteoptionid"] integerValue];
        
        if (optionID == self.userSelectedOptionID) {
            break;
        }
        
        indexNumber++;
    }
    
    CellIndexCircle *indexCircle = [[CellIndexCircle alloc] initWithNumber:indexNumber location:CGPointMake(0, 0)];
    indexCircle.frame = self.userOptionImageView.frame;
    indexCircle.indexLabel.frame = CGRectMake(0, 0, indexCircle.frame.size.width, indexCircle.frame.size.height);
    [self.userChoiceView addSubview:indexCircle];
    
    //hide the blue circle
    self.userOptionImageView.hidden = YES;
}

- (IBAction)showParticipantList:(id)sender
{
    self.participantListImageView.userInteractionEnabled = NO;
    
    if (!_isShowingUserList) {
        if (!_userList) {
            //request userList
            NSMutableDictionary *dic = [NSMutableDictionary getRequestDicWithRequestType:GetParticipants];
            [dic setObject:[NSNumber numberWithInt:self.voteid] forKey:@"voteid"];
            
            //NSLog(@"%@",[dic description]);
            
            [[PLServer shareInstance] sendDataWithDic:dic];
            
            [self showLoadingView:@"" isWithCancelButton:NO];
        }else{
            [self showUserList];
        }
    }else{
        [self dismissUserList];
    }
}

- (void)showUserList
{
    [UIView animateWithDuration:0.4 animations:^(void){
        self.subjectView.alpha = 0.0;
        self.optionView.alpha = 0.0;
        self.userChoiceView.alpha = 0.0;
        
        CGRect tmpRect = self.voteinforView.frame;
        tmpRect.origin.y -= (self.subjectView.frame.size.height+self.optionView.frame.size.height+self.userChoiceView.frame.size.height);
        self.voteinforView.frame = tmpRect;
        
    }completion:^(BOOL isFinished){
        if (isFinished) {
            CGRect tmpRect = self.voteinforView.frame;
            tmpRect.size.height = ScreenHeigh - tmpRect.origin.y - 49;
            self.voteinforView.frame = tmpRect;
            self.voteinforView.contentSize = tmpRect.size;
            
            tmpRect = self.informationCircleImageView.frame;
            tmpRect.size.height = tmpRect.size.width = 21;
            self.informationCircleImageView.frame = tmpRect;
            
            _nameLabelArray = [[NSMutableArray alloc] initWithCapacity:3];
            CGFloat yPosition = 21;
            for (NSInteger i = 0; i< _userList.count; i++) {
                yPosition = i*30 + 30;
                
                UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(49, yPosition, 200, 30)];
                nameLabel.font = [UIFont boldSystemFontOfSize:13];
                nameLabel.text = [_userList objectAtIndex:i];
                
                [self.voteinforView addSubview:nameLabel];
                
                [_nameLabelArray addObject:nameLabel];
            }
            
            if (yPosition+30 > self.voteinforView.frame.size.height) {
                self.voteinforView.contentSize = CGSizeMake(320, yPosition+30);
            }
            
            self.participantListImageView.userInteractionEnabled = YES;
            _isShowingUserList = YES;
        }
    }];
}

- (void)dismissUserList
{
    self.participantListImageView.userInteractionEnabled = NO;
    [UIView animateWithDuration:0.4 animations:^(void){
        self.subjectView.alpha = 1.0;
        self.optionView.alpha = 1.0;
        self.userChoiceView.alpha = 1.0;
        
        CGRect tmpRect = self.voteinforView.frame;
        tmpRect.origin.y += (self.subjectView.frame.size.height+self.optionView.frame.size.height+self.userChoiceView.frame.size.height);
        self.voteinforView.frame = tmpRect;
        
    }completion:^(BOOL isFinished){
        if (isFinished) {
            CGRect tmpRect = self.voteinforView.frame;
            tmpRect.size.height = 35;
            self.voteinforView.frame = tmpRect;
            self.voteinforView.contentSize = tmpRect.size;
            
            tmpRect = self.informationCircleImageView.frame;
            tmpRect.size.height = tmpRect.size.width = 21;
            self.informationCircleImageView.frame = tmpRect;
            
            for (UILabel *nameLabel in _nameLabelArray) {
                [nameLabel removeFromSuperview];
            }
            
            self.participantListImageView.userInteractionEnabled = YES;
            _isShowingUserList = NO;
        }
    }];
}

#pragma mark - PLServer delegate
- (void)plServer:(PLServer *)plServer didReceivedJSONString:(id)jsonString
{
    [self dismissLoadingView];
    
    NSDictionary *cacheDic = (NSDictionary*)jsonString;
    BOOL result = [[cacheDic valueForKey:@"success"] boolValue];
    
    //NSLog(@"%@",cacheDic);
    
    if (result) {
        VoteRequestType requetType = [cacheDic getRequestType];
        
        switch (requetType) {
            case GetParticipants:{
                NSArray *nameDcitionaryArray = [cacheDic objectForKey:@"participatorlist"];
                _userList = [[NSMutableArray alloc] initWithCapacity:3];
                
                for (NSDictionary *nameDic in nameDcitionaryArray) {
                    NSString *tmpName = [nameDic objectForKey:@"name"];
                    [_userList addObject:tmpName];
                }
                
                [self showUserList];
            }
                
            default:
                break;
        }
        
    }else{
        [self showErrorMessage:[cacheDic valueForKey:@"msg"]];
    }
}

@end
