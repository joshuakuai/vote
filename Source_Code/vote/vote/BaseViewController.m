//
//  baseViewController.m
//  vote
//
//  Created by kuaijianghua on 11/9/13.
//  Copyright (c) 2013 rampageworks. All rights reserved.
//

#import "BaseViewController.h"
#import "ProccessView.h"

@interface BaseViewController (){
    UIView *loadingView;
    UIView *messageView;
}

@end

@implementation BaseViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    //set the plankton server's delegate
    [[PLServer shareInstance] setDelegate:self];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [self dismissLoadingView];
}

#pragma mark - Loading View Method
- (void)showLoadingView:(NSString*)message isWithCancelButton:(BOOL)isWhitCancelButton
{
    UIActivityIndicatorView*  activityIndicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    
    //determine which type of the loadingView is
    if (isWhitCancelButton) {
        //we just use the alertView to show it
        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:nil message:message delegate:self cancelButtonTitle:@"取消" otherButtonTitles:nil ];
        loadingView = alert;
        
        [activityIndicatorView setCenter:CGPointMake(alert.center.x, alert.center.y)];
        [activityIndicatorView startAnimating];
        [alert addSubview:activityIndicatorView];
        [alert show];
    }else{
        ProccessView *processView = [[ProccessView alloc] init:message];
        loadingView = processView;
        [processView show];
    }

    isShowingLoadingView = YES;    
}

- (void)dismissLoadingView
{
    if (!loadingView) {
        return;
    }
    
    if ([loadingView isKindOfClass:[UIAlertView class]]) {
        [(UIAlertView*)loadingView dismissWithClickedButtonIndex:1 animated:YES];
    }else{
        [(ProccessView*)loadingView stop];
    }
    
    isShowingLoadingView = NO;
    
    [self loadingViewDidUnload];
}

- (void)loadingViewDidUnload
{
    //do nothing,waiting for being rewrited
    NSLog(@"You see this message because you did not rewrite loadingViewDidUnload method.");
}

#pragma - mark Message Method
- (void)showErrorMessage:(NSString*)content
{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"error" message:content delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
    [alertView show];
}

#pragma - mark PLServer Delegate
- (void)plServer:(PLServer *)plServer failedWithError:(NSError *)error
{
    [self dismissLoadingView];
    if (error) {
        [self showErrorMessage:[error description]];
    }else{
        [self showErrorMessage:@"We're experiencing some technique problems, please try again later."];
    }
}

- (void)connectionClosed:(PLServer *)plServer
{
    if (isShowingLoadingView) {
        [self dismissLoadingView];
        [self showErrorMessage:@"Lost connection,check your internet connection."];
    }
}

@end
