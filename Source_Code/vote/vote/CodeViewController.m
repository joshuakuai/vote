//
//  codeViewController.m
//  vote
//
//  Created by Shine Zhao on 11/5/13.
//  Copyright (c) 2013 rampageworks. All rights reserved.
//

#import "CodeViewController.h"

@interface CodeViewController (){
   
    NSTimer *_time;
    int _initTime;
}
@end

@implementation CodeViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBarHidden = YES;
    
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

    _displayEmail.text = _emailAddress;
    
    _codeTextField.keyboardType = UIKeyboardTypeNumberPad;
    _codeTextField.delegate = self;
    
    UIToolbar* numberToolbar = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, 320, 50)];
    numberToolbar.barStyle = UIBarStyleBlackTranslucent;
    numberToolbar.items = [NSArray arrayWithObjects:
                           [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil],
                           [[UIBarButtonItem alloc]initWithTitle:@"Apply" style:UIBarButtonItemStyleDone target:self action:@selector(doneWithNumberPad)],nil];
    [numberToolbar sizeToFit];
    _codeTextField.inputAccessoryView = numberToolbar;
    
    _time = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(timerFireMethod) userInfo:nil repeats:YES];
    _initTime = 60;
    _resendButton.hidden = true;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    NSUInteger newLength = [textField.text length] + [string length] - range.length;
    return (newLength > 4) ? NO : YES;
}

- (void)doneWithNumberPad
{
    [_codeTextField resignFirstResponder];
}

- (IBAction)resendCodeAction:(id)sender
{
    _time = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(timerFireMethod) userInfo:nil repeats:YES];
    _initTime = 60;
    _countdownTimer.hidden = false;
    _resendButton.hidden = true;
}

- (void)timerFireMethod
{
    _initTime --;
    _countdownTimer.text = [NSString stringWithFormat:@"%d",_initTime];
    if (_initTime == 0) {
        
        [_time invalidate];
        _resendButton.hidden = FALSE;
        _countdownTimer.hidden = TRUE;
        _countdownTimer.text = @"60";
    }
    
}

- (IBAction)changeEmailAction:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)submitCodeAction:(id)sender
{
    if ([_codeTextField.text isEqualToString:@""] || _codeTextField.text == nil || _codeTextField.text.length < 4) {
        [self showErrorMessage:@"Please input 4 digt code."];
        return;
    }
    
    //prepare the data
    NSMutableDictionary *dic = [NSMutableDictionary getRequestDicWithRequestType:CheckCode];
    [dic setObject:_codeTextField.text forKey:@"code"];
    [dic setObject:_emailAddress forKey:@"email"];
    [dic setObject:[NSNumber numberWithInt:0] forKey:@"checkType"];
    
    [[PLServer shareInstance] sendDataWithDic:dic];
    
    [self showLoadingView:@"" isWithCancelButton:NO];
}

#pragma mark - PLServer delegate
- (void)plServer:(PLServer *)plServer didReceivedJSONString:(id)jsonString
{
    [self dismissLoadingView];
    NSDictionary *cacheDic = (NSDictionary*)jsonString;
    BOOL result = [[cacheDic valueForKey:@"success"] boolValue];
    if (result) {
        //TODO:save the userid
        [self performSegueWithIdentifier:@"CodeViewShowMainViewSegue" sender:self];
    }else{
        [self showErrorMessage:[cacheDic valueForKey:@"msg"]];
    }
}

- (void)plServer:(PLServer *)plServer failedWithError:(NSError *)error
{
    [self dismissLoadingView];
    if (error) {
        [self showErrorMessage:[error description]];
    }else{
        [self showErrorMessage:@"We're experiencing some technique problems, please try again later."];
    }
}

- (void)connectionClosed:(PLServer *)plServer
{
    if (isShowingLoadingView) {
        [self dismissLoadingView];
        [self showErrorMessage:@"Lost connection,check your internet connection."];
    }
}

@end
