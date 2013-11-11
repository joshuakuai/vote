//
//  NSDictionary+PLPackage.h
//  vote
//
//  Created by kuaijianghua on 11/10/13.
//  Copyright (c) 2013 rampageworks. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Protocal.h"

@interface NSDictionary (PLPackage)

- (VoteRequestType)getRequestType;

@end
