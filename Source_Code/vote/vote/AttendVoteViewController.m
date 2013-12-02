//
//  AttendVoteViewController.m
//  vote
//
//  Created by Shine Zhao on 12/2/13.
//  Copyright (c) 2013 rampageworks. All rights reserved.
//

#import "AttendVoteViewController.h"
#import "UILabel+SizeCalculate.h"

@interface AttendVoteViewController ()
{
    NSString *_titleImage;
    NSArray *_arrowImageArray;
    CGFloat heightOfSubjectView;
    NSString *subject;
    int numberOfOptions;
}

@end

@implementation AttendVoteViewController

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
    
    //模拟服务器传过来的数值
    numberOfOptions = 3;
    subject = @"Eventually, the car she was in came to a stop with a thud. She managed to get off the train carrying her cell phone, its screen shattered but still working.";
    
    
    _titleImage = @"titleImage";
    _arrowImageArray = [[NSArray alloc] initWithObjects:@"GreenSolidArrow", @"BlueSolidArrow", @"YellowSolidArrow", @"RedSolidArrow", @"GraySolidArrow", nil];
	// Do any additional setup after loading the view.
    UIImageView *titleImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:_titleImage]];
    titleImageView.frame = CGRectMake(60, 10, 200, 100);
    [self.view addSubview:titleImageView];
    
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.frame = CGRectMake(0, 0, 200, 100);
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.textColor = [UIColor whiteColor];
    [titleLabel setFont:[UIFont fontWithName:@"Helvetica-Bold" size:50]];
    titleLabel.text = @"Vote";
    [titleImageView addSubview:titleLabel];
    
    CGFloat timeImageWidth = 230;
    CGFloat timeImageHeight = 230 / 5.2;
    UIImageView *timeImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:_arrowImageArray[1]]];
    timeImageView.frame = CGRectMake((320 - timeImageWidth) / 2, 120, timeImageWidth, timeImageHeight);
    [self.view addSubview:timeImageView];
    
    UILabel *timeLabel = [[UILabel alloc] init];
    timeLabel.frame = CGRectMake(0, 0, timeImageWidth, timeImageHeight);
    timeLabel.textAlignment = NSTextAlignmentCenter;
    timeLabel.textColor = [UIColor whiteColor];
    timeLabel.font = [UIFont systemFontOfSize:16];
    timeLabel.text = [@"Time left: about " stringByAppendingString:@"5 minutes"];
    [timeImageView addSubview:timeLabel];
    
    heightOfSubjectView = 100;
    UIView *subjectView = [[UIView alloc] init];
    subjectView.frame = CGRectMake(11, 180, 298, heightOfSubjectView);
    subjectView.layer.borderWidth = 1;
    [self.view addSubview:subjectView];
    
    UIImageView *subjectImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"flowerImage"]];
    subjectImageView.frame = CGRectMake(0, 5, 20, 20);
    [subjectView addSubview:subjectImageView];
    
    UILabel *subjectLabel = [[UILabel alloc] init];
    subjectLabel.frame = CGRectMake(20, 0, 60, 30);
    subjectLabel.textAlignment = NSTextAlignmentCenter;
    subjectLabel.textColor = [UIColor colorWithRed:0.0 green:0.443 blue:0.737 alpha:1.0];
    subjectLabel.font = [UIFont systemFontOfSize:16];
    subjectLabel.text = @"Subject";
    
    
    [subjectView addSubview:subjectLabel];
    
    UILabel *subjectContentLabel = [[UILabel alloc] init];
    subjectContentLabel.frame = CGRectMake(20, 20, 278, 150);
    subjectContentLabel.numberOfLines = 0;
    subjectContentLabel.font = [UIFont systemFontOfSize:20];
    subjectContentLabel.text = subject;
    //resize the height of subject view
    CGSize expectedSize = [subjectLabel perfectLabelSizeWithMaxSize:CGSizeMake(278, 9999)];
    subjectContentLabel.frame = CGRectMake(20, 20, expectedSize.width, expectedSize.height);
    [subjectView addSubview:subjectContentLabel];

    CGFloat heightOfOptionView = 100;
    UIView *optionView = [[UIView alloc] init];
    optionView.frame = CGRectMake(11, 280, 298, heightOfSubjectView);
    optionView.layer.borderWidth = 1;
    [self.view addSubview:optionView];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
