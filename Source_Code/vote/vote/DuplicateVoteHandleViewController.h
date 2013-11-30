//
//  DuplicateVoteHandleViewController.h
//  vote
//
//  Created by kuaijianghua on 11/30/13.
//  Copyright (c) 2013 rampageworks. All rights reserved.
//

#import "RootViewController.h"
#import "DuplicateListView.h"

@interface DuplicateVoteHandleViewController : RootViewController<DuplicateListViewDelegate>

//UI
@property (weak, nonatomic) IBOutlet UIScrollView *DuplicateListScrollView;

//Data
@property (nonatomic,strong) NSDictionary *duplicateDictionary;
@property (nonatomic,assign) int voteid;

@end
