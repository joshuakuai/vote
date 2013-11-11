//
//  NSDictionary+PLPackage.m
//  vote
//
//  Created by kuaijianghua on 11/10/13.
//  Copyright (c) 2013 rampageworks. All rights reserved.
//

#import "NSDictionary+PLPackage.h"

@implementation NSDictionary (PLPackage)

- (VoteRequestType)getRequestType
{
    if ([self objectForKey:@"requestType"]) {
        return [[self objectForKey:@"requestType"] intValue];
    }
    
    return Unknow;
}

@end
