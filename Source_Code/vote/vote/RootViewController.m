//
//  rootViewController.m
//  vote
//
//  Created by kuaijianghua on 11/3/13.
//  Copyright (c) 2013 rampageworks. All rights reserved.
//

#import "RootViewController.h"

@interface RootViewController ()

@end

@implementation RootViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBarHidden = YES;
    
    //check if the user has already logined in
    if ([[NSUserDefaults standardUserDefaults] integerForKey:@"userid"]) {
        [self performSegueWithIdentifier:@"rootViewShowMainViewSegue" sender:self];
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
