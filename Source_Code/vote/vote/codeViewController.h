//
//  codeViewController.h
//  vote
//
//  Created by Shine Zhao on 11/5/13.
//  Copyright (c) 2013 rampageworks. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "baseViewController.h"

@interface codeViewController : baseViewController
@property (weak, nonatomic) IBOutlet UILabel *displayEmail;
@property (weak, nonatomic) IBOutlet UITextField *codeTextField;
@property (strong, nonatomic) NSString *emailAddress;

- (IBAction)resendCodeAction:(id)sender;
- (IBAction)changeEmailAction:(id)sender;
- (IBAction)submitCodeAction:(id)sender;

@end
