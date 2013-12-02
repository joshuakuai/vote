//
//  VoteOption.m
//  vote
//
//  Created by kuaijianghua on 12/2/13.
//  Copyright (c) 2013 rampageworks. All rights reserved.
//

#import "VoteOption.h"

@implementation VoteOption

- (id)init
{
    self = [super init];
    
    if (self) {
        self.voteID = -1;
        self.voteOptionID = -1;
        self.content = nil;
    }
    
    return self;
}

- (void)dealloc
{
    self.content = nil;
}

@end
