//
//  VoteOption.h
//  vote
//
//  Created by kuaijianghua on 12/2/13.
//  Copyright (c) 2013 rampageworks. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface VoteOption : NSObject

@property (nonatomic, assign) int voteID;
@property (nonatomic, assign) int voteOptionID;
@property (nonatomic, strong) NSString *content;

@end
