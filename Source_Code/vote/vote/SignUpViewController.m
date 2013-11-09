//
//  signUpViewController.m
//  vote
//
//  Created by kuaijianghua on 11/3/13.
//  Copyright (c) 2013 rampageworks. All rights reserved.
//

#import "SignUpViewController.h"
#import "NSString+ValidCheck.h"
#import "codeViewController.h"

@interface SignUpViewController ()

@end

@implementation SignUpViewController

- (void)viewWillAppear:(BOOL)animated
{
    self.navigationController.navigationBarHidden = NO;
    
    _emailTextField.text = @"";
    _emailAgainTextField.text = @"";
    
    //set the plankton server's delegate
    [[PLServer shareInstance] setDelegate:self];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //set the the keyboard dismiss selector
    [_firstNameTextField addTarget:self action:@selector(textFieldDone:) forControlEvents:UIControlEventEditingDidEndOnExit];
    [_lastNameTextField addTarget:self action:@selector(textFieldDone:) forControlEvents:UIControlEventEditingDidEndOnExit];
    [_emailAgainTextField addTarget:self action:@selector(textFieldDone:) forControlEvents:UIControlEventEditingDidEndOnExit];
    [_emailTextField addTarget:self action:@selector(textFieldDone:) forControlEvents:UIControlEventEditingDidEndOnExit];
    
    [_firstNameTextField becomeFirstResponder];
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
    NSMutableDictionary *dic = [NSMutableDictionary getRequestDicWithRequestType:Register];
    [dic setObject:_firstNameTextField.text forKey:@"firstName"];
    [dic setObject:_emailTextField.text forKey:@"email"];
    [dic setObject:_lastNameTextField.text forKey:@"lastName"];

    [[PLServer shareInstance] sendDataWithDic:dic];
    
    [self showLoadingView:@"" isWithCancelButton:NO];
}

//over written the loading dismisView
- (void)loadingViewDidUnload
{
    
}


//prepare the data, transfer to the next scene
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ([segue.identifier isEqualToString:@"signUpShowCodeViewSegue"]) {
        CodeViewController *destViewController = segue.destinationViewController;
        //NSLog(@"%@", _emailTextField.text);
        destViewController.emailAddress = [_emailTextField.text copy];
    }
}

#pragma mark - PLServer delegate
- (void)plServer:(PLServer *)plServer didReceivedJSONString:(id)jsonString
{
    [self dismissLoadingView];
    NSDictionary *cacheDic = (NSDictionary*)jsonString;
    BOOL result = [[cacheDic valueForKey:@"success"] boolValue];
    if (result) {
        [self performSegueWithIdentifier:@"signUpShowCodeViewSegue" sender:self];
    }else{
        [self showErrorMessage:[cacheDic valueForKey:@"msg"]];
    }
}

- (void)plServer:(PLServer *)plServer failedWithError:(NSError *)error
{
    [self dismissLoadingView];
    [self showErrorMessage:[error description]];
}

- (void)connectionClosed:(PLServer *)plServer
{
    if (isShowingLoadingView) {
        [self dismissLoadingView];
        [self showErrorMessage:@"Lost connection,check your internet connection."];
    }
}

@end
