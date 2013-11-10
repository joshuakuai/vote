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
@property (strong, nonatomic) NSString *emailAddress;
@property (weak, nonatomic) IBOutlet UIButton *resendButton;
@property (weak, nonatomic) IBOutlet UILabel *countdownTimer;

- (IBAction)resendCodeAction:(id)sender;
- (IBAction)changeEmailAction:(id)sender;
- (IBAction)submitCodeAction:(id)sender;


@end
