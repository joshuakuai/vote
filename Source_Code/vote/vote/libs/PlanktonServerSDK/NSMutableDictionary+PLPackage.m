//
//  NSMutableDictionary+PLPackage.m
//  vote
//
//  Created by kuaijianghua on 11/5/13.
//  Copyright (c) 2013 rampageworks. All rights reserved.
//

#import "NSMutableDictionary+PLPackage.h"

@implementation NSMutableDictionary (PLPackage)

+ (NSMutableDictionary*)getRequestDicWithRequestType:(VoteRequestType)requestType
{
    return [NSMutableDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInt:requestType],@"requestType",nil];
}

@end
