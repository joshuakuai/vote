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
        
        tmpRect = self.doneButton.frame;
        tmpRect.origin.y -= 67;
        self.doneButton.frame = tmpRect;
        
        tmpRect = self.automaticGeneratePasswordView.frame;
        tmpRect.origin.y -= 67;
        self.automaticGeneratePasswordView.frame = tmpRect;
        
        [self.theNewPasswordTextField becomeFirstResponder];
    }else{
        self.automaticGeneratePasswordView.hidden = YES;
        [self.oldPasswordTextField becomeFirstResponder];
    }
}

- (IBAction)doneButtonTapped:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)setPassword:(id)sender
{
    //check if the password is the same
    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"hasPassword"] &&
        (self.oldPasswordTextField.text == NULL || [self.oldPasswordTextField.text isEqualToString:@""])) {
        [self showErrorMessage:@"Please input your current password."];
        return;
    }
    
    if (self.theNewPasswordTextField.text == NULL ||
        [self.theNewPasswordTextField.text isEqualToString:@""] ||
        self.confrimNewPasswordTextField.text == NULL ||
        [self.confrimNewPasswordTextField.text isEqualToString:@""]) {
        [self showErrorMessage:@"Please input your new password."];
        return;
    }
    
    if (![self.theNewPasswordTextField.text isEqualToString:self.confrimNewPasswordTextField.text]) {
        [self showErrorMessage:@"Please make sure you input the same password twice."];
        return;
    }
    
    //send new password to server
    NSMutableDictionary *dic = [NSMutableDictionary getRequestDicWithRequestType:SetPassword];
    [dic setObject:self.theNewPasswordTextField.text forKey:@"newpass"];
    [dic setObject:UserId forKey:@"userid"];
    
    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"hasPassword"]) {
        [dic setObject:self.oldPasswordTextField.text forKey:@"oldpass"];
    }
    
    NSLog(@"%@",[dic description]);
    
    [[PLServer shareInstance] sendDataWithDic:dic];
    
    [self showLoadingView:@"" isWithCancelButton:NO];
}

- (IBAction)automaticGeneratePassword:(id)sender
{
    NSMutableDictionary *dic = [NSMutableDictionary getRequestDicWithRequestType:AutoPassword];
    [dic setObject:UserId forKey:@"userid"];
    
    NSLog(@"%@",[dic description]);
    
    [[PLServer shareInstance] sendDataWithDic:dic];
    
    [self showLoadingView:@"" isWithCancelButton:NO];
}

- (void)textFieldDone:(UITextField*)sender
{
    [sender resignFirstResponder];
}


#pragma mark - PLServer delegate
- (void)plServer:(PLServer *)plServer didReceivedJSONString:(id)jsonString
{
    [self dismissLoadingView];
    
    NSDictionary *cacheDic = (NSDictionary*)jsonString;
    BOOL result = [[cacheDic valueForKey:@"success"] boolValue];
    
    NSLog(@"%@",cacheDic);
    
    if (result) {
        //check if is the refresh by location
        VoteRequestType requetType = [cacheDic getRequestType];
        
        switch (requetType) {
            case AutoPassword:
            case SetPassword:
                [self showErrorMessage:@"New password set."];
                [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"hasPassword"];
                [[NSUserDefaults standardUserDefaults] synchronize];
                
                //dismiss the controller
                [self doneButtonTapped:nil];
                
                break;
                
            default:
                break;
        }
        
    }else{
        [self showErrorMessage:[cacheDic valueForKey:@"msg"]];
    }
}

@end
