//
//  ProcessingVoteViewController.m
//  vote
//
//  Created by kuaijianghua on 12/31/13.
//  Copyright (c) 2013 rampageworks. All rights reserved.
//

#import "ProcessingVoteViewController.h"
#import "UILabel+SizeCalculate.h"
#include "CellIndexCircle.h"

@interface ProcessingVoteViewController ()

@end

@implementation ProcessingVoteViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.subjectLabel.text = self.subjectString;
    
    self.userOptionImageView.userInteractionEnabled = YES;
    
    //calculate the left time
    self.lefttimeLabel.text = [NSString stringWithFormat:@"%02d:%02d",self.leftSeconds/60,self.leftSeconds%60];
    
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
        
        indexNumber ++;
    }
    
    tmpRect = self.subjectView.frame;
    tmpRect.size.height += (indexNumber-1)*32;
    self.optionView.frame = tmpRect;

    //set value to the vote information view
    self.voteidLabel.text = [NSString stringWithFormat:@"%d",self.voteid];
    self.pollNumberLabel.text = [NSString stringWithFormat:@"%d people has voted",self.pollNumber];
    
    //adjust the view position
    tmpRect = self.optionView.frame;
    tmpRect.origin.y = self.subjectView.frame.origin.y + self.subjectView.frame.size.height + 5;
    self.optionView.frame = tmpRect;
    
    tmpRect = self.voteInfoView.frame;
    tmpRect.origin.y = self.optionView.frame.origin.y + self.optionView.frame.size.height;
    self.voteInfoView.frame = tmpRect;
}

- (void)dealloc
{
    self.optionDictionaryArray = nil;
    self.subjectString = nil;
}

- (IBAction)showUserOption:(id)sender
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
    [self.voteInfoView addSubview:indexCircle];
    
    //hide the blue circle
    self.userOptionImageView.hidden = YES;
}

@end
