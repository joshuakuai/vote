//
//  NSMutableDictionary+PLPackage.h
//  vote
//
//  Created by kuaijianghua on 11/5/13.
//  Copyright (c) 2013 rampageworks. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Protocal.h"

@interface NSMutableDictionary (PLPackage)

+ (NSMutableDictionary*)getRequestDicWithRequestType:(VoteRequestType)requestType;

@end
