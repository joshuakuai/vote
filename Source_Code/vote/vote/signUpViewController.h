//
//  signUpViewController.h
//  vote
//
//  Created by kuaijianghua on 11/3/13.
//  Copyright (c) 2013 rampageworks. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface signUpViewController : UIViewController

@property (weak, nonatomic) IBOutlet UITextField *firstNameTextField;
@property (weak, nonatomic) IBOutlet UITextField *lastNameTextField;
@property (weak, nonatomic) IBOutlet UITextField *emailTextField;
@property (weak, nonatomic) IBOutlet UITextField *emailAgainTextField;

- (IBAction)singUp:(id)sender;

@end