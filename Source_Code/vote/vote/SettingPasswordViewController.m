//
//  SettingPasswordViewController.m
//  vote
//
//  Created by kuaijianghua on 12/29/13.
//  Copyright (c) 2013 rampageworks. All rights reserved.
//

#import "SettingPasswordViewController.h"

@interface SettingPasswordViewController ()

@end

@implementation SettingPasswordViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //set dismiss selector
    [self.theNewPasswordTextField addTarget:self action:@selector(textFieldDone:) forControlEvents:UIControlEventEditingDidEndOnExit];
    [self.oldPasswordTextField addTarget:self action:@selector(textFieldDone:) forControlEvents:UIControlEventEditingDidEndOnExit];
    [self.confrimNewPasswordTextField addTarget:self action:@selector(textFieldDone:) forControlEvents:UIControlEventEditingDidEndOnExit];
	
    //check if the user seted the password before
    if (![[NSUserDefaults standardUserDefaults] boolForKey:@"hasPassword"]) {
        //user doesn't have password, so we hide the old password
        self.oldPasswordLabel.hidden = YES;
        self.oldPasswordTextField.hidden = YES;
        
        CGRect tmpRect = self.theNewPasswordLabel.frame;
        tmpRect.origin.y -= 67;
        self.theNewPasswordLabel.frame = tmpRect;
        
        tmpRect = self.theNewPasswordTextField.frame;
        tmpRect.origin.y -= 67;
        self.theNewPasswordTextField.frame = tmpRect;
        
        tmpRect = self.confirmNewPasswordLabel.frame;
        tmpRect.origin.y -= 67;
        self.confirmNewPasswordLabel.frame = tmpRect;
        
        tmpRect = self.confrimNewPasswordTextField.frame;
        tmpRect.origin.y -= 67;
        self.confrimNewPasswordTextField.frame = tmpRect;
        
        [self.theNewPasswordTextField becomeFirstResponder];
    }else{
        [self.oldPasswordTextField becomeFirstResponder];
    }
}

- (IBAction)doneButtonTapped:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)textFieldDone:(UITextField*)sender
{
    [sender resignFirstResponder];
}

@end
