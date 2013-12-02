//
//  AttendVoteViewController.m
//  vote
//
//  Created by Shine Zhao on 12/2/13.
//  Copyright (c) 2013 rampageworks. All rights reserved.
//

#import "AttendVoteViewController.h"
#import "UILabel+SizeCalculate.h"
#import "VoteOption.h"

@interface AttendVoteViewController ()
{
    UILabel *titleLabel;
    NSString *_titleImage;
    NSArray *_arrowImageArray;
    CGFloat _heightOfSubjectView;
    int _numberOfOptions;
    NSMutableArray *_optionsContent;
    CGRect _firstOptionOriginalSize;
    GLfloat _heightOfOptionView;
    GLfloat _widthOfOptionView;
    GLfloat _intervalBetweenOptions;
    GLfloat _indexSize;
    NSString *_optionIndexImage;
    UIButton *_doneButton;
    //height and width of the button
    int _heightOfButton;
    int _widthOfButton;
    NSString *_blueButtonBackground;
    NSString *_redButtonBackground;
    
    //store index buttons to array
    NSArray *buttonArray;
    
    int voteIndex;
}

@end

@implementation AttendVoteViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBarHidden = YES;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    /*
    //模拟服务器传过来的数值

    _optionsContent = [[NSArray alloc] initWithObjects:@"kobe", @"James", @"jodan", nil];
    _numberOfOptions = _optionsContent.count;
     */
    _optionsContent = [NSMutableArray arrayWithCapacity:3];
    
    for (VoteOption *voteOption in self.optionArray) {
        [_optionsContent addObject:voteOption.content];
    }
    
    _numberOfOptions = _optionsContent.count;
    
    buttonArray = [[NSArray alloc] initWithObjects: nil];
    
    _titleImage = @"titleImage";
    _arrowImageArray = [[NSArray alloc] initWithObjects:@"GreenSolidArrow", @"BlueSolidArrow", @"YellowSolidArrow", @"RedSolidArrow", @"GraySolidArrow", nil];
	// Do any additional setup after loading the view.
    UIImageView *titleImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:_titleImage]];
    titleImageView.frame = CGRectMake(60, 10, 200, 100);
    [self.view addSubview:titleImageView];
    
    titleLabel = [[UILabel alloc] init];
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
    NSString *timeLeftString = [NSString stringWithFormat:@"%d minutes",self.leftMinutes];
    timeLabel.text = [@"Time left: about " stringByAppendingString:timeLeftString];
    [timeImageView addSubview:timeLabel];
    
    _heightOfSubjectView = 100;
    UIView *subjectView = [[UIView alloc] init];
    subjectView.frame = CGRectMake(11, 180, 298, _heightOfSubjectView);
    //subjectView.layer.borderWidth = 1;
    [self.view addSubview:subjectView];
    
    UIImageView *subjectImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"flowerImage"]];
    subjectImageView.frame = CGRectMake(0, 5, 20, 20);
    [subjectView addSubview:subjectImageView];
    
    UILabel *subjectLabel = [[UILabel alloc] init];
    subjectLabel.frame = CGRectMake(20, 0, 60, 30);
    subjectLabel.textAlignment = NSTextAlignmentCenter;
    subjectLabel.textColor = [UIColor colorWithRed:0.0 green:0.443 blue:0.737 alpha:1.0];
    subjectLabel.font = [UIFont systemFontOfSize:16];
    subjectLabel.text = @"subject";
    [subjectView addSubview:subjectLabel];

    UILabel *subjectContentLabel = [[UILabel alloc] init];
    subjectContentLabel.frame = CGRectMake(20, 20, 278, 150);
    subjectContentLabel.numberOfLines = 0;
    subjectContentLabel.font = [UIFont systemFontOfSize:20];
    subjectContentLabel.text = _subject;
    
    //resize the height of _subject view
    CGSize expectedSize = [subjectContentLabel perfectLabelSizeWithMaxSize:CGSizeMake(278, 1000)];
    subjectContentLabel.frame = CGRectMake(20, 20, expectedSize.width, expectedSize.height);
    [subjectView addSubview:subjectContentLabel];
    
    //recalculate the frame of subject view
    _heightOfSubjectView = 30 + expectedSize.height;
    subjectView.frame = CGRectMake(11, 180, 298, _heightOfSubjectView);

    //option part
    _widthOfOptionView = 278;
    _heightOfOptionView = 30;
    _intervalBetweenOptions = 5;
    _firstOptionOriginalSize = CGRectMake(20, 30 , _widthOfOptionView, _heightOfOptionView);
    _indexSize = 28;
    _optionIndexImage = @"CellIndexCircle";
    
    CGFloat heightOfOptionView = _numberOfOptions * (_intervalBetweenOptions + _heightOfOptionView) + _indexSize;
    
    UIView *optionView = [[UIView alloc] init];
    optionView.frame = CGRectMake(11, 180 + _heightOfSubjectView + 5, 298, heightOfOptionView);
    //optionView.layer.borderWidth = 2;
    [self.view addSubview:optionView];

    UIImageView *optionImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"starImage"]];
    optionImageView.frame = CGRectMake(0, 5, 20, 20);
    [optionView addSubview:optionImageView];
    
    UILabel *optionLabel = [[UILabel alloc] init];
    optionLabel.frame = CGRectMake(20, 0, 60, 30);
    optionLabel.textAlignment = NSTextAlignmentCenter;
    optionLabel.textColor = [UIColor colorWithRed:0.0 green:0.443 blue:0.737 alpha:1.0];
    optionLabel.font = [UIFont systemFontOfSize:16];
    optionLabel.text = @"Options";
    [optionView addSubview:optionLabel];
    

    
    for (int i =0; i < _numberOfOptions; i++) {
        UIView *eachOptionView = [[UIView alloc] init];
        eachOptionView.frame = CGRectMake(_firstOptionOriginalSize.origin.x, _firstOptionOriginalSize.origin.y + i * (_intervalBetweenOptions + _heightOfOptionView), _widthOfOptionView, _heightOfOptionView);
        //eachOptionView.layer.borderWidth = 1;
        [optionView addSubview:eachOptionView];
        
        NSMutableArray *tempButtonArray = [[NSMutableArray alloc] initWithArray:buttonArray];
        
        
        UIButton *indexButton = [UIButton buttonWithType:UIButtonTypeCustom];
        indexButton.frame = CGRectMake(0, (_heightOfOptionView - _indexSize ) / 2 + eachOptionView.frame.size.height - _heightOfOptionView, _indexSize, _indexSize);
        [indexButton setImage:[UIImage imageNamed:_optionIndexImage] forState:UIControlStateNormal];
        [indexButton setImage:[UIImage imageNamed:_optionIndexImage] forState:UIControlStateHighlighted];
        [indexButton addTarget:self action:@selector(tapOnIndexOfOption:) forControlEvents:UIControlEventTouchDown];
        [eachOptionView addSubview:indexButton];
        
        [tempButtonArray addObject:indexButton];
        buttonArray = [[NSArray alloc] initWithArray:tempButtonArray];
        
        //index number
        UILabel *addedIndexLabel = [[UILabel alloc] init];
        addedIndexLabel.frame = CGRectMake(0, 0, _indexSize, _indexSize);
        addedIndexLabel.textAlignment = NSTextAlignmentCenter;
        [addedIndexLabel setText:[NSString stringWithFormat:@"%d", i+1]];
        [indexButton addSubview:addedIndexLabel];
        
        //option content
        UILabel *optionContent = [[UILabel alloc] init];
        optionContent.frame = CGRectMake(_indexSize + 5, 0, _widthOfOptionView, _heightOfOptionView);
        optionContent.textColor = [UIColor colorWithRed:0.0 green:0.443 blue:0.737 alpha:1.0];
        optionContent.font = [UIFont systemFontOfSize:20];
        optionContent.text = _optionsContent[i];
        //resize the height of _subject view
        [eachOptionView addSubview:optionContent];
    }
    

    _heightOfButton = 30;
    _widthOfButton = _heightOfButton *176 /97;
    _blueButtonBackground = @"BlueTitleBackground";
    _redButtonBackground = @"RedTitleBackground";
    //Done button
    _doneButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _doneButton.frame = CGRectMake(11, 280 + heightOfOptionView + 30, _widthOfButton, _heightOfButton );
    [_doneButton setImage:[UIImage imageNamed:_blueButtonBackground] forState:UIControlStateNormal];
    [_doneButton setImage:[UIImage imageNamed:_redButtonBackground] forState:UIControlStateHighlighted];
    _doneButton.hidden = YES;
    [_doneButton addTarget:self action:@selector(doneWithVote:) forControlEvents:UIControlEventTouchDown];
    [self.view addSubview:_doneButton];
    
    UILabel *doneLabel = [[UILabel alloc] init];
    doneLabel.frame = CGRectMake(0, 0, _widthOfButton, _heightOfButton);
    doneLabel.textColor = [UIColor whiteColor];
    doneLabel.textAlignment = NSTextAlignmentCenter;
    doneLabel.text = @"Done";
    [_doneButton addSubview:doneLabel];
    
}

- (void)tapOnIndexOfOption:(UIButton *)sender
{
    for (int i=0; i < _numberOfOptions; i++) {
        if ([sender isEqual:buttonArray[i]]) {
            titleLabel.text = [NSString stringWithFormat:@"%d",i + 1];
            voteIndex = i;
        }
    }
    _doneButton.hidden = NO;
}

- (void)doneWithVote:(UIButton *)sender
{
    //get the option id
    VoteOption *option = [_optionArray objectAtIndex:voteIndex];
    
    NSMutableDictionary *dic = [NSMutableDictionary getRequestDicWithRequestType:JoinVote];
    [dic setObject:[NSNumber numberWithInt:option.voteOptionID] forKey:@"voteoptionid"];
    [dic setObject:UserId forKey:@"userid"];
    
    //NSLog(@"%@",[dic description]);
    
    [[PLServer shareInstance] sendDataWithDic:dic];
    
    [self showLoadingView:@"" isWithCancelButton:NO];
}

#pragma mark - PLServer delegate
- (void)plServer:(PLServer *)plServer didReceivedJSONString:(id)jsonString
{
    [self dismissLoadingView];
    
    NSDictionary *cacheDic = (NSDictionary*)jsonString;
    
    NSLog(@"%@",[cacheDic description]);
    
    BOOL result = [[cacheDic valueForKey:@"success"] boolValue];
    if (result) {
        //check if is the refresh by location
        VoteRequestType requetType = [cacheDic getRequestType];
        
        switch (requetType) {
            case JoinVote:{
                //success
                [self.navigationController popToRootViewControllerAnimated:YES];
            }
                
            default:
                break;
        }
        
    }else{
        [self showErrorMessage:[cacheDic valueForKey:@"msg"]];
    }
}

- (void)plServer:(PLServer *)plServer failedWithError:(NSError *)error
{
    [self dismissLoadingView];
    if (error) {
        [self showErrorMessage:[error description]];
    }else{
        [self showErrorMessage:@"We're experiencing some technique problems, please try again later."];
    }
}

- (void)connectionClosed:(PLServer *)plServer
{
    if (isShowingLoadingView) {
        [self dismissLoadingView];
        [self showErrorMessage:@"Lost connection,check your internet connection."];
    }
}

@end
