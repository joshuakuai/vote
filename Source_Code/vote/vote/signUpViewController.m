//
//  signUpViewController.m
//  vote
//
//  Created by kuaijianghua on 11/3/13.
//  Copyright (c) 2013 rampageworks. All rights reserved.
//

#import "signUpViewController.h"
#import "UIViewController+Message.h"
#import "NSString+ValidCheck.h"

@interface signUpViewController ()

@end

@implementation signUpViewController

- (void)viewWillAppear:(BOOL)animated
{
    self.navigationController.navigationBarHidden = NO;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //set the the keyboard dismiss selector
    [_firstNameTextField addTarget:self action:@selector(textFieldDone:) forControlEvents:UIControlEventEditingDidEndOnExit];
    [_lastNameTextField addTarget:self action:@selector(textFieldDone:) forControlEvents:UIControlEventEditingDidEndOnExit];
    [_emailAgainTextField addTarget:self action:@selector(textFieldDone:) forControlEvents:UIControlEventEditingDidEndOnExit];
    [_emailTextField addTarget:self action:@selector(textFieldDone:) forControlEvents:UIControlEventEditingDidEndOnExit];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)textFieldDone:(UITextField*)textField
{
    [textField resignFirstResponder];
}

//begin signUp
- (IBAction)singUp:(id)sender
{
    //check if the textfields has already filled
    if (_firstNameTextField.text == nil || [_firstNameTextField.text isEqualToString:@""] ||
        _lastNameTextField.text == nil || [_lastNameTextField.text isEqualToString:@""] ||
        _lastNameTextField.text == nil || [_lastNameTextField.text isEqualToString:@""] ||
        _lastNameTextField.text == nil || [_lastNameTextField.text isEqualToString:@""]){
        
        [self showErrorMessage:@"Any information can't be empty."];
        return;
    }
    
    //check if the email is valid
    if (![_emailTextField.text isValidEmail] || ![_emailAgainTextField.text isValidEmail]) {
        
        [self showErrorMessage:@"Email address is not valid."];
        return;
    }
    
    if (![_emailTextField.text isEqualToString:_emailAgainTextField.text]) {
        [self showErrorMessage:@"Email address is not the same, please check again."];
        return;
    }
    
    //all pass, prepare the data
    
}


@end
