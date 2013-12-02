//
//  HistoryViewController.m
//  vote
//
//  Created by Shine Zhao on 12/2/13.
//  Copyright (c) 2013 rampageworks. All rights reserved.
//

#import "HistoryViewController.h"

@interface HistoryViewController ()
{
    NSString *_titleImage;
    UIScrollView *attendedScrollView;
    UIScrollView *initiatedScrollView;
    int numberOfAllAttendedVotes;
    int numberOfAllInitiatedVotes;
    NSArray *solidArrowImage;
    
    //模拟需要
    NSArray *attendedVoteList;
    NSArray *initiateVoteList;
}

@end

@implementation HistoryViewController

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    
    if (self) {
        //set the tab bar item background
        [self.tabBarItem setFinishedSelectedImage:[UIImage imageNamed:@"HistoryTabBarHighlight"] withFinishedUnselectedImage:[UIImage imageNamed:@"HistoryTabBarNormal"]];
        self.tabBarItem.imageInsets = UIEdgeInsetsMake(6, -0.5, -6, 0.5);
    }
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    attendedVoteList = [[NSArray alloc] initWithObjects: nil];
    initiateVoteList = [[NSArray alloc] initWithObjects: nil];
    
    //模拟服务器传回的数据
    _emailAddress = @"@shineamnys@gmail.com";
    NSMutableArray *tempAttendVoteArray = [[NSMutableArray alloc] initWithArray:attendedVoteList];
    NSMutableArray *tempInitiateArray = [[NSMutableArray alloc] initWithArray:initiateVoteList];
    NSString *voteTime = @"2013/12/2 12:30";
    NSString *voteInitiator = @"Shuai Zhai";
    NSString *finishedState = @"YES";
    NSString *inProgressState = @"NO";
    
    for (int i = 0; i<5; i++) {
        NSMutableDictionary *tempDicitionary = [NSMutableDictionary dictionary];
        [tempDicitionary setObject:[NSString stringWithFormat:@"%d" ,i] forKey:@"colorIndex"];
        [tempDicitionary setObject:voteTime forKey:@"time"];
        [tempDicitionary setObject:voteInitiator forKey:@"initiator"];
        if (i < 2) {
            [tempDicitionary setObject:inProgressState forKey:@"state"];
        }else{
            [tempDicitionary setObject:finishedState forKey:@"state"];
        }
        [tempAttendVoteArray addObject:tempDicitionary];
    }
    attendedVoteList = [[NSArray alloc] initWithArray:tempAttendVoteArray];
    
    for (int i = 0; i<5; i++) {
        NSMutableDictionary *tempDicitionary = [NSMutableDictionary dictionary];
        [tempDicitionary setObject:[NSString stringWithFormat:@"%d" ,4 - i] forKey:@"colorIndex"];
        [tempDicitionary setObject:voteTime forKey:@"time"];
        [tempDicitionary setObject:voteInitiator forKey:@"initiator"];
        if (i < 2) {
            [tempDicitionary setObject:inProgressState forKey:@"state"];
        }else{
            [tempDicitionary setObject:finishedState forKey:@"state"];
        }
        [tempInitiateArray addObject:tempDicitionary];
    }
    initiateVoteList = [[NSArray alloc] initWithArray:tempInitiateArray];
    
    
    solidArrowImage = [[NSArray alloc] initWithObjects:@"GreenSolidArrow", @"BlueSolidArrow", @"YellowSolidArrow", @"RedSolidArrow", @"GraySolidArrow", nil];
	// Do any additional setup after loading the view.
    _titleImage = @"titleImage";
    UIImageView *titleImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:_titleImage]];
    titleImageView.frame = CGRectMake(60, 10, 200, 100);
    [self.view addSubview:titleImageView];
    
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.frame = CGRectMake(0, 0, 200, 100);
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.textColor = [UIColor whiteColor];
    [titleLabel setFont:[UIFont fontWithName:@"Helvetica-Bold" size:45]];
    titleLabel.text = @"History";
    [titleImageView addSubview:titleLabel];
    
    UILabel *emailLabel = [[UILabel alloc] init];
    emailLabel.frame = CGRectMake(0, 105, 320, 20);
    emailLabel.textAlignment = NSTextAlignmentCenter;
   // emailLabel.layer.borderWidth  =1;
    emailLabel.textColor = [UIColor colorWithRed:0.0 green:0.443 blue:0.737 alpha:1.0];
    emailLabel.font = [UIFont systemFontOfSize:14];
    emailLabel.text = _emailAddress;
    [self.view addSubview:emailLabel];
    
    
    _historySegment = [ [ UISegmentedControl alloc ] initWithItems: nil ];
    _historySegment.segmentedControlStyle = UISegmentedControlStyleBar;
    
    _historySegment.frame = CGRectMake(0, 130, 320, 30);
    [ _historySegment insertSegmentWithTitle:@"Attended" atIndex: 0 animated: NO ];
    [_historySegment insertSegmentWithTitle:@"Initiated" atIndex: 1 animated: NO ];
    [self.view addSubview:_historySegment];
    [_historySegment addTarget:self action:@selector(historySwitchAction:) forControlEvents:UIControlEventValueChanged];
    _historySegment.selectedSegmentIndex = 0;
    
#pragma attended part
    //初始化数据
    numberOfAllAttendedVotes = attendedVoteList.count;
    CGRect firstVoteViewFrame = CGRectMake(11, 0, 298, 50);
    CGFloat heightOfeachVoteImageView = 50;
    
    attendedScrollView = [[UIScrollView alloc] init];
    attendedScrollView.frame = CGRectMake(0, 170, 320, 349);
    attendedScrollView.layer.borderWidth = 1;
    attendedScrollView.hidden = NO;
    [self.view addSubview:attendedScrollView];
    
    for (int i = 0 ; i < numberOfAllAttendedVotes; i++) {
        UIView *eachVoteView = [[UIView alloc] init];
        eachVoteView.frame = CGRectMake(firstVoteViewFrame.origin.x, firstVoteViewFrame.origin.y + i * heightOfeachVoteImageView, firstVoteViewFrame.size.width, firstVoteViewFrame.size.height);
        
        
        
    }
    
    
#pragma initiated part
    initiatedScrollView = [[UIScrollView alloc] init];
    initiatedScrollView.frame = CGRectMake(0, 170, 320, 349);
    initiatedScrollView.layer.borderWidth = 2;
    initiatedScrollView.hidden = YES;
    [self.view addSubview:initiatedScrollView];
    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)historySwitchAction:(UIButton *)sender
{
    int selectedIndex = _historySegment.selectedSegmentIndex;
    if (!selectedIndex) {
        attendedScrollView.hidden = NO;
        initiatedScrollView.hidden = YES;
    }else{
        attendedScrollView.hidden = YES;
        initiatedScrollView.hidden = NO;
    }
}

@end
