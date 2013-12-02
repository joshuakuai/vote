//
//  PasswordEnterViewController.h
//  vote
//
//  Created by Shine Zhao on 12/1/13.
//  Copyright (c) 2013 rampageworks. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"

@interface PasswordEnterViewController : BaseViewController<UITextFieldDelegate>

@property (strong, nonatomic) UITextField *passwordTextField;

@end
