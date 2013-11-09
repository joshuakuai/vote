//
//  codeViewController.m
//  vote
//
//  Created by Shine Zhao on 11/5/13.
//  Copyright (c) 2013 rampageworks. All rights reserved.
//

#import "codeViewController.h"

@interface codeViewController ()

@end

@implementation codeViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBarHidden = YES;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    _displayEmail.text = _emailAddress;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
    
}

@end
