//
//  baseViewController.h
//  vote
//
//  Created by kuaijianghua on 11/9/13.
//  Copyright (c) 2013 rampageworks. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PLServer.h"

//This class should be every controller's super class
@interface BaseViewController : UIViewController<UIAlertViewDelegate>{
    UIAlertView *_alertView;
    UITextField *_alertTextFieldView;
    BOOL isShowingLoadingView;
}

//loading view
- (void)showLoadingView:(NSString*)message isWithCancelButton:(BOOL)isWhitCancelButton;
- (void)dismissLoadingView;
- (void)loadingViewDidUnload;
- (void)showErrorMessage:(NSString*)content;

//PLServer delegate methods
- (void)plServer:(PLServer *)plServer failedWithError:(NSError *)error;
- (void)connectionClosed:(PLServer *)plServer;

@end
