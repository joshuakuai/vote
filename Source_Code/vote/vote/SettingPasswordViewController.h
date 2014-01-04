//
//  SettingPasswordViewController.h
//  vote
//
//  Created by kuaijianghua on 12/29/13.
//  Copyright (c) 2013 rampageworks. All rights reserved.
//

#import "BaseViewController.h"

@interface SettingPasswordViewController : BaseViewController
@property (weak, nonatomic) IBOutlet UILabel *oldPasswordLabel;
@property (weak, nonatomic) IBOutlet UILabel *theNewPasswordLabel;
@property (weak, nonatomic) IBOutlet UILabel *confirmNewPasswordLabel;
@property (weak, nonatomic) IBOutlet UITextField *oldPasswordTextField;
@property (weak, nonatomic) IBOutlet UITextField *theNewPasswordTextField;
@property (weak, nonatomic) IBOutlet UITextField *confrimNewPasswordTextField;
@property (weak, nonatomic) IBOutlet UIButton *doneButton;
@property (weak, nonatomic) IBOutlet UIView *automaticGeneratePasswordView;


- (IBAction)doneButtonTapped:(id)sender;
- (IBAction)setPassword:(id)sender;
- (IBAction)automaticGeneratePassword:(id)sender;
@end
