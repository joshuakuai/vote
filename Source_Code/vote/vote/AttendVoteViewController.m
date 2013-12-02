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
    CGFloat _heightOf_subjectView;
    NSString *_subject;
    int _numberOfOptions;
    NSArray *_optionsContent;
    CGRect _firstOptionOriginalSize;
    GLfloat _heightOfOptionView;
    GLfloat _widthOfOptionView;
    GLfloat _intervalBetweenOptions;
    GLfloat _indexSize;
    
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

    _subject = @"Eventually, the car she was in came to a stop with a thud. She managed to get off the train carrying her cell phone, its screen shattered but still working.";
    _optionsContent = [[NSArray alloc] initWithObjects:@"kobe", @"James", @"jodan", nil];
    _numberOfOptions = _optionsContent.count;
    
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
    
    _heightOf_subjectView = 100;
    UIView *_subjectView = [[UIView alloc] init];
    _subjectView.frame = CGRectMake(11, 180, 298, _heightOf_subjectView);
    _subjectView.layer.borderWidth = 1;
    [self.view addSubview:_subjectView];
    
    UIImageView *_subjectImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"flowerImage"]];
    _subjectImageView.frame = CGRectMake(0, 5, 20, 20);
    [_subjectView addSubview:_subjectImageView];
    
    UILabel *_subjectLabel = [[UILabel alloc] init];
    _subjectLabel.frame = CGRectMake(20, 0, 60, 30);
    _subjectLabel.textAlignment = NSTextAlignmentCenter;
    _subjectLabel.textColor = [UIColor colorWithRed:0.0 green:0.443 blue:0.737 alpha:1.0];
    _subjectLabel.font = [UIFont systemFontOfSize:16];
    _subjectLabel.text = @"_subject";
    [_subjectView addSubview:_subjectLabel];
    
    UILabel *_subjectContentLabel = [[UILabel alloc] init];
    _subjectContentLabel.frame = CGRectMake(20, 20, 278, 150);
    _subjectContentLabel.numberOfLines = 0;
    _subjectContentLabel.font = [UIFont systemFontOfSize:20];
    _subjectContentLabel.text = _subject;
    //resize the height of _subject view
    CGSize expectedSize = [_subjectLabel perfectLabelSizeWithMaxSize:CGSizeMake(278, 9999)];
    _subjectContentLabel.frame = CGRectMake(20, 20, expectedSize.width, expectedSize.height);
    [_subjectView addSubview:_subjectContentLabel];

    //option part
    CGFloat heightOfOptionView = 200;
    
    UIView *optionView = [[UIView alloc] init];
    optionView.frame = CGRectMake(11, 280, 298, heightOfOptionView);
    optionView.layer.borderWidth = 1;
    [self.view addSubview:optionView];

    UIImageView *optionImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"starImage"]];
    _subjectImageView.frame = CGRectMake(0, 5, 20, 20);
    [optionView addSubview:optionImageView];
    
    UILabel *optionLabel = [[UILabel alloc] init];
    optionLabel.frame = CGRectMake(20, 0, 60, 30);
    optionLabel.textAlignment = NSTextAlignmentCenter;
    optionLabel.textColor = [UIColor colorWithRed:0.0 green:0.443 blue:0.737 alpha:1.0];
    optionLabel.font = [UIFont systemFontOfSize:16];
    optionLabel.text = @"Options";
    [optionView addSubview:optionLabel];
    
    _widthOfOptionView = 278;
    _heightOfOptionView = 30;
    _intervalBetweenOptions = 5;
    _firstOptionOriginalSize = CGRectMake(20, 30, _widthOfOptionView, _heightOfOptionView);
    _indexSize = 28;
    
    for (int i =0; i < _numberOfOptions; i++) {
        UIView *eachOptionView = [[UIView alloc] init];
        eachOptionView.frame = CGRectMake(_firstOptionOriginalSize.origin.x, _firstOptionOriginalSize.origin.y + i * (_intervalBetweenOptions + _heightOfOptionView), _widthOfOptionView, _heightOfOptionView);
        eachOptionView.layer.borderWidth = 1;
        [optionView addSubview:eachOptionView];
        
        UIButton *indexButton = [UIButton buttonWithType:UIButtonTypeCustom];
        indexButton.frame = CGRectMake(0, (_heightOfOptionView - _indexSize ) / 2 + eachOptionView.frame.size.height - _heightOfOptionView, _indexSize, _indexSize);
        [indexButton setImage:[UIImage imageNamed:optionIndexImage] forState:UIControlStateNormal];
        [indexButton setImage:[UIImage imageNamed:optionIndexImage] forState:UIControlStateHighlighted];
        [indexButton addTarget:self action:@selector(tapOnIndexOfOption:) forControlEvents:UIControlEventTouchDown];
        [_thirdResponder addSubview:indexButton];
        
        //index number
        UILabel *addedIndexLabel = [[UILabel alloc] init];
        addedIndexLabel.frame = CGRectMake(0, 0, _indexSize, _indexSize);
        addedIndexLabel.textAlignment = NSTextAlignmentCenter;
        [addedIndexLabel setText:[NSString stringWithFormat:@"%d", _numberOfOptions]];
        [indexButton addSubview:addedIndexLabel];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
