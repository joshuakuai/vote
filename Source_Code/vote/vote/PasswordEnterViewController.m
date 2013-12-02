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
    NSArray *arrowImageArray;
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
    arrowImageArray = [[NSArray alloc] initWithObjects:@"GreenSolidArrow", @"BlueSolidArrow", @"YellowSolidArrow", @"RedSolidArrow", @"GraySolidArrow", nil];
    
    
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
    
    UIImageView *arrowImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:arrowImageArray[1]]];
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
    _passwordTextField.frame = CGRectMake(20, 210, 280, 76);
    
    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)returnToSearchPage:(UIButton *)sender
{
    
}

@end
