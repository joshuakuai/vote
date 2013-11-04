//
//  UIViewController+Message.m
//  vote
//
//  Created by kuaijianghua on 11/3/13.
//  Copyright (c) 2013 rampageworks. All rights reserved.
//

#import "UIViewController+Message.h"

@implementation UIViewController (Message)

- (void)showErrorMessage:(NSString*)content
{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"error" message:content delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
    [alertView show];
}

@end
