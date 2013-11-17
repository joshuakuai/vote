//
//  Vote.m
//  vote
//
//  Created by kuaijianghua on 11/16/13.
//  Copyright (c) 2013 rampageworks. All rights reserved.
//

#import "Vote.h"

@implementation Vote

- (id)init
{
    self = [super init];
    if (self) {
        self.voteID = -1;
        self.initiator = nil;
        self.title = nil;
        self.maxValidUserNumber = -1;
        self.password = nil;
        self.longitude = 0.0;
        self.latitude = 0.0;
        self.createTime = nil;
        self.endTime = 0;
        self.isFinished = NO;
        self.colorIndex = greenArrow;
    }
    return self;
}

@end
