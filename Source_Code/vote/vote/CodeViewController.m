//
//  codeViewController.m
//  vote
//
//  Created by Shine Zhao on 11/5/13.
//  Copyright (c) 2013 rampageworks. All rights reserved.
//

#import "CodeViewController.h"

@interface CodeViewController ()

@end

@implementation CodeViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBarHidden = YES;
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
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)textView:(UITextView *)aTextView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    // "Length of existing text" - "Length of replaced text" + "Length of replacement text"
    NSInteger newTextLength = [aTextView.text length] - range.length + [text length];
    
    if (newTextLength > 4) {
        // don't allow change
        return NO;
    }
    _codeTextField.text = [NSString stringWithFormat:@"%li", (long)newTextLength];
    return YES;
}

- (void)doneWithNumberPad
{
    [_codeTextField resignFirstResponder];
}

- (IBAction)resendCodeAction:(id)sender
{
    
}

- (IBAction)changeEmailAction:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)submitCodeAction:(id)sender
{
    if ([_codeTextField.text isEqualToString:@""] || _codeTextField.text != nil || _codeTextField.text.length < 4) {
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
        [self performSegueWithIdentifier:@"signUpShowCodeViewSegue" sender:self];
    }else{
        [self showErrorMessage:[[cacheDic valueForKey:@"msg"] stringValue]];
    }
}

- (void)plServer:(PLServer *)plServer failedWithError:(NSError *)error
{
    [self dismissLoadingView];
    [self showErrorMessage:[error description]];
}

@end
