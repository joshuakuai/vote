//
//  PasswordEnterViewController.m
//  vote
//
//  Created by Shine Zhao on 12/1/13.
//  Copyright (c) 2013 rampageworks. All rights reserved.
//

#import "PasswordEnterViewController.h"

@interface PasswordEnterViewController ()
{
    GLfloat _lengthOfButton;
    NSString *_imageOfReturnButton;
    NSArray *_arrowImageArray;
    UILabel *_passwordTip;
}

@end

@implementation PasswordEnterViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    _lengthOfButton = 25.0;
    _imageOfReturnButton = @"returnButton.png";
    _arrowImageArray = [[NSArray alloc] initWithObjects:@"GreenSolidArrow", @"BlueSolidArrow", @"YellowSolidArrow", @"RedSolidArrow", @"GraySolidArrow", nil];
    
    
	// Do any additional setup after loading the view.
    UIButton *returnButton = [UIButton buttonWithType:UIButtonTypeCustom];
    returnButton.frame = CGRectMake(11, 20, _lengthOfButton, _lengthOfButton);
    [returnButton setImage:[UIImage imageNamed:_imageOfReturnButton] forState:UIControlStateNormal];
    [returnButton setImage:[UIImage imageNamed:_imageOfReturnButton] forState:UIControlStateNormal];
    [returnButton addTarget:self action:@selector(returnToSearchPage:) forControlEvents:UIControlEventTouchDown];
    [self.view addSubview:returnButton];
    
    UIView *titleView = [[UIView alloc] init];
    titleView.frame = CGRectMake(11, 60, 298, 76);
    [self.view addSubview:titleView];
    
    UIImageView *arrowImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:_arrowImageArray[1]]];
    arrowImageView.frame = CGRectMake(19, 13, 260, 50);
    [titleView addSubview:arrowImageView];
    
    UILabel *initiator = [[UILabel alloc] init];
    initiator.frame = CGRectMake(0, 0, 298, 76);
    initiator.textAlignment = NSTextAlignmentCenter;
    initiator.textColor = [UIColor whiteColor];
    initiator.font = [UIFont systemFontOfSize:25];
    initiator.text = [@"Initiator:" stringByAppendingString:@"Coach K"];
    [titleView addSubview:initiator];
    
    UILabel *passwordLabel = [[UILabel alloc] init];
    passwordLabel.frame = CGRectMake(0, 130, 320, 76);
    passwordLabel.textAlignment = NSTextAlignmentCenter;
    passwordLabel.textColor = [UIColor colorWithRed:0.0 green:0.443 blue:0.737 alpha:1.0];
    [passwordLabel setFont:[UIFont fontWithName:@"Helvetica-Bold" size:30]];
    passwordLabel.text = @"Password";
    [self.view addSubview:passwordLabel];
    
    _passwordTextField = [[UITextField alloc] init];
    _passwordTextField.frame = CGRectMake(20, 190, 280, 76);
    _passwordTextField.keyboardType = UIKeyboardTypeNumberPad;
    _passwordTextField.font = [UIFont systemFontOfSize:30];
    _passwordTextField.textAlignment = UITextAlignmentCenter;
    _passwordTextField.delegate = self;
    _passwordTextField.secureTextEntry = YES;
    [self.view addSubview:_passwordTextField];
    
    UIButton *doneButton = [UIButton buttonWithType:UIButtonTypeCustom];
    doneButton.frame = CGRectMake(82, 266, 156, 30);
    [doneButton setImage:[UIImage imageNamed:_arrowImageArray[1]] forState:UIControlStateNormal];
    [doneButton setImage:[UIImage imageNamed:_arrowImageArray[1]] forState:UIControlStateHighlighted];
    [doneButton addTarget:self action:@selector(doneWithPassword:) forControlEvents:UIControlEventTouchDown];
    [self.view addSubview:doneButton];
    
    UILabel *doneLabel = [[UILabel alloc] init];
    doneLabel.frame = CGRectMake(-8, 0, 165, 30);
    doneLabel.textColor = [UIColor whiteColor];
    doneLabel.font = [UIFont systemFontOfSize:22];
    doneLabel.textAlignment = NSTextAlignmentCenter;
    doneLabel.text = @"Done";
    [doneButton addSubview:doneLabel];
    
    _passwordTip = [[UILabel alloc] init];
    _passwordTip.frame = CGRectMake(0, 300, 320, 30);
    _passwordTip.textColor = [UIColor redColor];
    _passwordTip.font = [UIFont systemFontOfSize:22];
    _passwordTip.textAlignment = NSTextAlignmentCenter;
    _passwordTip.text = @"Need six numbers!";
    [self.view addSubview:_passwordTip];
    _passwordTip.hidden = YES;
    
    [_passwordTextField becomeFirstResponder];
    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)returnToSearchPage:(UIButton *)sender
{
    
}

- (void)doneWithPassword:(UIButton *)sender
{
    int passwordInt = [_passwordTextField.text intValue];
    if (passwordInt/100000) {
        
    }else{
        _passwordTip.hidden = NO;
    }
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    _passwordTip.hidden = YES;
    if (range.location >= 6){
        return NO;
    }
    
    return  YES;
}



@end
