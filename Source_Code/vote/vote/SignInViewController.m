//
//  SignInViewController.m
//  vote
//
//  Created by kuaijianghua on 11/10/13.
//  Copyright (c) 2013 rampageworks. All rights reserved.
//

#import "SignInViewController.h"
#import "NSString+ValidCheck.h"
#import "CodeViewController.h"

@interface SignInViewController ()

@end

@implementation SignInViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBarHidden = NO;
    
    _emailTextField.text = @"";
    _passwordTextField.text = @"";
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

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ([segue.identifier isEqualToString:@"signInShowCodeViewSegue"]) {
        CodeViewController *destViewController = segue.destinationViewController;
        destViewController.emailAddress = [_emailTextField.text copy];
        destViewController.checkType = 1;
    }
}

- (IBAction)signInWithEmail:(id)sender
{
    if (_emailTextField.text == nil || [_emailTextField.text isEqualToString:@""]) {
        [self showErrorMessage:@"Please input your email to verify."];
        return;
    }
    
    //check if the email is valid
    if (![_emailTextField.text isValidEmail]) {
        [self showErrorMessage:@"Email address is not valid."];
        return;
    }
    
    //all pass, prepare the data
    NSMutableDictionary *dic = [NSMutableDictionary getRequestDicWithRequestType:SignInWithEmail];
    [dic setObject:_emailTextField.text forKey:@"email"];
    
    [[PLServer shareInstance] sendDataWithDic:dic];
    
    [self showLoadingView:@"" isWithCancelButton:NO];
}

- (IBAction)signInWithPassword:(id)sender
{
    if (_emailTextField.text == nil || [_emailTextField.text isEqualToString:@""] ||
        _passwordTextField.text == nil || [_passwordTextField.text isEqualToString:@""]) {
        [self showErrorMessage:@"Please input your email and password to verify. If you forget your password or you haven't set it yet,please use the email verfication to login"];
        return;
    }
    
    //check if the email is valid
    if (![_emailTextField.text isValidEmail]) {
        [self showErrorMessage:@"Email address is not valid."];
        return;
    }
}

#pragma mark - PLServer delegate
- (void)plServer:(PLServer *)plServer didReceivedJSONString:(id)jsonString
{
    [self dismissLoadingView];
    NSDictionary *cacheDic = (NSDictionary*)jsonString;
    BOOL result = [[cacheDic valueForKey:@"success"] boolValue];
    if (result) {
        //check if userid is avaliable
        if ([cacheDic getRequestType] == SignInWithPassword) {
            [[NSUserDefaults standardUserDefaults] setObject:[cacheDic valueForKey:@"userid"] forKey:@"userid"];
            
            //get the token
            [[UIApplication sharedApplication] registerForRemoteNotificationTypes:(UIRemoteNotificationTypeBadge|UIRemoteNotificationTypeSound|UIRemoteNotificationTypeAlert)];

            [self performSegueWithIdentifier:@"signInShowMainViewSegue" sender:self];
        }else{
            [self performSegueWithIdentifier:@"signInShowCodeViewSegue" sender:self];
        }
    }else{
        [self showErrorMessage:[cacheDic valueForKey:@"msg"]];
    }
}

@end
