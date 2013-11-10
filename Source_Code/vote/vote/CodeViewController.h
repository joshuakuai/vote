//
//  codeViewController.h
//  vote
//
//  Created by Shine Zhao on 11/5/13.
//  Copyright (c) 2013 rampageworks. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"

@interface CodeViewController : BaseViewController<UITextFieldDelegate,PLServerDelegate>
@property (weak, nonatomic) IBOutlet UILabel *displayEmail;
@property (weak, nonatomic) IBOutlet UITextField *codeTextField;
@property (weak, nonatomic) IBOutlet UIButton *resendButton;
@property (weak, nonatomic) IBOutlet UILabel *countdownTimer;
@property (strong, nonatomic) NSString *emailAddress;
@property (strong, nonatomic) NSString *lastName;
@property (strong, nonatomic) NSString *firstName;
@property (assign, nonatomic) NSInteger checkType;

- (IBAction)resendCodeAction:(id)sender;
- (IBAction)changeEmailAction:(id)sender;
- (IBAction)submitCodeAction:(id)sender;


@end
