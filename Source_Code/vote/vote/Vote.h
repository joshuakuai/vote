//
//  Vote.h
//  vote
//
//  Created by kuaijianghua on 11/16/13.
//  Copyright (c) 2013 rampageworks. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum{greenArrow = 0,blueArrow,redArrow,yellowArrow,grayArrow}VoteArrowColor;

@interface Vote : NSObject

@property(nonatomic,assign)NSInteger voteID;
@property(nonatomic,strong)NSString *initiator;
@property(nonatomic,strong)NSString *title;
@property(nonatomic,assign)int maxValidUserNumber;
@property(nonatomic,strong)NSString *password;
@property(nonatomic,assign)double longitude;
@property(nonatomic,assign)double latitude;
@property(nonatomic,strong)NSDate *createTime;
@property(nonatomic,strong)NSDate *endTime;
@property(nonatomic,assign)BOOL isFinished;
@property(nonatomic,assign)VoteArrowColor colorIndex;

@end
