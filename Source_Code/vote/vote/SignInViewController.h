//
//  SignInViewController.h
//  vote
//
//  Created by kuaijianghua on 11/10/13.
//  Copyright (c) 2013 rampageworks. All rights reserved.
//

#import "BaseViewController.h"

@interface SignInViewController : BaseViewController<PLServerDelegate>
@property (weak, nonatomic) IBOutlet UITextField *emailTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;

- (IBAction)signInWithEmail:(id)sender;
- (IBAction)signInWithPassword:(id)sender;

@end
