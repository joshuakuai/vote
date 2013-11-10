//
//  SignInViewController.m
//  vote
//
//  Created by kuaijianghua on 11/10/13.
//  Copyright (c) 2013 rampageworks. All rights reserved.
//

#import "SignInViewController.h"

@interface SignInViewController ()

@end

@implementation SignInViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBarHidden = NO;
    
    //set the plankton server's delegate
    [[PLServer shareInstance] setDelegate:self];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [[PLServer shareInstance] closeConnection];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //set the the keyboard dismiss selector
    [_emailTextField addTarget:self action:@selector(textFieldDone:) forControlEvents:UIControlEventEditingDidEndOnExit];
    [_passwordTextField addTarget:self action:@selector(textFieldDone:) forControlEvents:UIControlEventEditingDidEndOnExit];
    
    [_emailTextField becomeFirstResponder];
}

- (void)textFieldDone:(UITextField*)textField
{
    [textField resignFirstResponder];
}

- (IBAction)signInWithEmail:(id)sender
{
    
}

- (IBAction)signInWithPassword:(id)sender
{
    
}

@end
