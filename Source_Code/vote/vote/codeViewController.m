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

@synthesize emailAddress;

@synthesize displayEmail;

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBarHidden = YES;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    displayEmail.text = emailAddress;
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
    
}

- (IBAction)submitCodeAction:(id)sender
{
    
}

@end
