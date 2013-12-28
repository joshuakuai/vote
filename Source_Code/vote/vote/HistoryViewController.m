//
//  HistoryViewController.m
//  vote
//
//  Created by Shine Zhao on 12/2/13.
//  Copyright (c) 2013 rampageworks. All rights reserved.
//

#import "HistoryViewController.h"
#import "Vote.h"
#import "HistoryResultCell.h"

@interface HistoryViewController ()
{
    NSString *_titleImage;
    UITableView *attendedTableView;
    UITableView *initiatedTableView;
    int numberOfAllAttendedVotes;
    int numberOfAllInitiatedVotes;
    NSArray *solidArrowImage;
    NSString *indexImage;
    NSArray *attendArrowButtonArray;
    NSArray *initiatedArrowButtonArray;
    
    
    //模拟需要
    NSArray *attendedVoteList;
    NSArray *initiateVoteList;
    
    EGORefreshTableHeaderView *_refreshHeaderView;
    BOOL _reloading;
    
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
    
    indexImage = @"CellIndexCircle";
    
    attendedVoteList = [[NSArray alloc] initWithObjects: nil];
    initiateVoteList = [[NSArray alloc] initWithObjects: nil];
    
    attendArrowButtonArray = [[NSArray alloc] initWithObjects: nil];
    initiatedArrowButtonArray = [[NSArray alloc] initWithObjects: nil];
    
    
/*
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
    
 */
    
    
    
    
    
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
    
    CGRect tableFrame = CGRectMake(0, 170, 320, 349);
        
    attendedTableView = [[UITableView alloc] init];
    attendedTableView.frame = tableFrame;
    [attendedTableView setDelegate:self];
    [attendedTableView setDataSource:self];
    attendedTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:attendedTableView];
    
    initiatedTableView = [[UITableView alloc] init];
    initiatedTableView.frame = tableFrame;
    [initiatedTableView setDelegate:self];
    [initiatedTableView setDataSource:self];
    initiatedTableView.hidden = YES;
    initiatedTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:initiatedTableView];
 
    numberOfAllAttendedVotes = attendedVoteList.count;
    numberOfAllInitiatedVotes = initiateVoteList.count;
    
    if (_refreshHeaderView == nil) {
        
        _refreshHeaderView = [[EGORefreshTableHeaderView alloc] initWithFrame:CGRectMake(0.0f, 0.0f - tableFrame.size.height, tableFrame.size.width, tableFrame.size.height)];
        _refreshHeaderView.delegate = self;
        [attendedTableView addSubview:_refreshHeaderView];
    }
    [_refreshHeaderView refreshLastUpdatedDate];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    //TODO:add refresh
    //get the data from server, initia first
    NSMutableDictionary *dic = [NSMutableDictionary getRequestDicWithRequestType:IndexHistory];
    [dic setObject:[NSNumber numberWithInt:1] forKey:@"indextype"];
    [dic setObject:UserId forKey:@"userid"];
    
    //NSLog(@"%@",[dic description]);
    
    [[PLServer shareInstance] sendDataWithDic:dic];
    
    [self showLoadingView:@"" isWithCancelButton:NO];
}

/*
- (void)refresh
{
    if (attendedScrollView || initiatedScrollView) {
        [attendedScrollView removeFromSuperview];
        [initiatedScrollView removeFromSuperview];
        attendedScrollView = nil;
        initiatedScrollView = nil;
    }
    
    //共用数据
    GLfloat sizeOfIndexImage = 20;
    GLfloat leftMargin = 30;
    GLfloat heightOftimeLabel = 15;
    GLfloat heightOfArrowButton = 50;
    GLfloat heightOfStateLabel = 15;
    GLfloat intervalBetweenEachVoteView = 5;
    
#pragma mark attended part
    //初始化数据
    numberOfAllAttendedVotes = attendedVoteList.count;
    CGRect firstVoteViewFrame = CGRectMake(11, 0, 298, 70);
    CGFloat heightOfeachVoteImageView = heightOftimeLabel + heightOfArrowButton + heightOfStateLabel;
    

     
 


    
    NSMutableArray *tempAttendArrowButtonArray = [[NSMutableArray alloc] initWithArray:attendArrowButtonArray];
    
    for (int i = 0 ; i < numberOfAllAttendedVotes; i++) {
        
        NSDictionary *tempDictionary = attendedVoteList[i];
        UIView *eachVoteView = [[UIView alloc] init];
        eachVoteView.frame = CGRectMake(firstVoteViewFrame.origin.x, firstVoteViewFrame.origin.y + i * (heightOfeachVoteImageView + intervalBetweenEachVoteView), firstVoteViewFrame.size.width, firstVoteViewFrame.size.height);
        //eachVoteView.layer.borderWidth = 2;
        [attendedScrollView addSubview:eachVoteView];
        
        UIImageView *indexImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:indexImage]];
        indexImageView.frame = CGRectMake(0, (heightOfeachVoteImageView - sizeOfIndexImage) /2, sizeOfIndexImage, sizeOfIndexImage);
        [eachVoteView addSubview:indexImageView];
        
        UILabel *indexLabel = [[UILabel alloc] init];
        indexLabel.frame = CGRectMake(0, 0, sizeOfIndexImage, sizeOfIndexImage);
        indexLabel.textColor = [UIColor colorWithRed:0.0 green:0.443 blue:0.737 alpha:1.0];
        indexLabel.textAlignment = NSTextAlignmentCenter;
        indexLabel.text = [NSString stringWithFormat:@"%d", i+1];
        [indexImageView addSubview:indexLabel];
        
        UILabel *timeLabel = [[UILabel alloc] init];
        timeLabel.frame = CGRectMake(leftMargin, 0, 200, heightOftimeLabel);
        timeLabel.textColor = [UIColor colorWithRed:0.0 green:0.443 blue:0.737 alpha:1.0];
        timeLabel.font = [UIFont systemFontOfSize:12];
        timeLabel.text = [tempDictionary objectForKey:@"time"];
        [eachVoteView addSubview:timeLabel];
        
        int indexOfcolor = [[tempDictionary objectForKey:@"colorIndex"] intValue];
        NSString *arrowImage = solidArrowImage[indexOfcolor];
        
        UIButton *arrowButton = [UIButton buttonWithType:UIButtonTypeCustom];
        arrowButton.frame = CGRectMake(leftMargin, heightOftimeLabel, 298 - leftMargin, heightOfArrowButton);
        [arrowButton setImage:[UIImage imageNamed:arrowImage]  forState:UIControlStateNormal];
        [arrowButton setImage:[UIImage imageNamed:arrowImage]  forState:UIControlStateHighlighted];
        [eachVoteView addSubview:arrowButton];
        
        [tempAttendArrowButtonArray addObject:arrowButton];
        
        UILabel *initiatorLabel = [[UILabel alloc] init];
        initiatorLabel.frame = CGRectMake(0, 0, 298 - leftMargin, heightOfArrowButton);
        initiatorLabel.textColor = [UIColor whiteColor];
        initiatorLabel.textAlignment = NSTextAlignmentCenter;
        initiatorLabel.text = [@"Initiator:" stringByAppendingString:[tempDictionary objectForKey:@"initiator"]];
        [arrowButton addSubview:initiatorLabel];
        
        NSString *stateString = [tempDictionary objectForKey:@"state"];
        UILabel *stateLabel = [[UILabel alloc] init];
        stateLabel.frame = CGRectMake(leftMargin, heightOftimeLabel + heightOfArrowButton, 298 - leftMargin, heightOfStateLabel);
        stateLabel.font = [UIFont systemFontOfSize:12];
        stateLabel.textAlignment = NSTextAlignmentCenter;
        timeLabel.textColor = [UIColor colorWithRed:0.0 green:0.443 blue:0.737 alpha:1.0];
        if ([stateString isEqualToString:@"YES"]) {
            stateLabel.text = @"This vote is finished";
        }else{
            stateLabel.text = @"This vote is in progress";
        }
        [eachVoteView addSubview:stateLabel];
        
    }
    attendArrowButtonArray = [[NSArray alloc] initWithArray:tempAttendArrowButtonArray];
    
    
#pragma initiated part
    numberOfAllInitiatedVotes = initiateVoteList.count;
    initiatedScrollView = [[UIScrollView alloc] init];
    initiatedScrollView.frame = CGRectMake(0, 170, 320, 349);
    //initiatedScrollView.layer.borderWidth = 2;
    initiatedScrollView.hidden = YES;
    [self.view addSubview:initiatedScrollView];
    initiatedScrollView.contentSize = CGSizeMake(320, (numberOfAllAttendedVotes - 1) * (heightOfeachVoteImageView + intervalBetweenEachVoteView) + heightOfeachVoteImageView);
    
    NSMutableArray *tempInitiatedArrowButtonArray = [[NSMutableArray alloc] initWithArray:initiatedArrowButtonArray];
    
    for (int i = 0; i < numberOfAllInitiatedVotes; i++) {
        NSDictionary *tempDictionary = initiateVoteList[i];
        UIView *eachVoteView = [[UIView alloc] init];
        eachVoteView.frame = CGRectMake(firstVoteViewFrame.origin.x, firstVoteViewFrame.origin.y + i * (heightOfeachVoteImageView + intervalBetweenEachVoteView), firstVoteViewFrame.size.width, firstVoteViewFrame.size.height);
        //eachVoteView.layer.borderWidth = 2;
        [initiatedScrollView addSubview:eachVoteView];
        
        UIImageView *indexImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:indexImage]];
        indexImageView.frame = CGRectMake(0, (heightOfeachVoteImageView - sizeOfIndexImage) /2, sizeOfIndexImage, sizeOfIndexImage);
        [eachVoteView addSubview:indexImageView];
        
        UILabel *indexLabel = [[UILabel alloc] init];
        indexLabel.frame = CGRectMake(0, 0, sizeOfIndexImage, sizeOfIndexImage);
        indexLabel.textColor = [UIColor colorWithRed:0.0 green:0.443 blue:0.737 alpha:1.0];
        indexLabel.textAlignment = NSTextAlignmentCenter;
        indexLabel.text = [NSString stringWithFormat:@"%d", i+1];
        [indexImageView addSubview:indexLabel];
        
        UILabel *timeLabel = [[UILabel alloc] init];
        timeLabel.frame = CGRectMake(leftMargin, 0, 200, heightOftimeLabel);
        timeLabel.textColor = [UIColor colorWithRed:0.0 green:0.443 blue:0.737 alpha:1.0];
        timeLabel.font = [UIFont systemFontOfSize:12];
        timeLabel.text = [tempDictionary objectForKey:@"time"];
        [eachVoteView addSubview:timeLabel];
        
        int indexOfcolor = [[tempDictionary objectForKey:@"colorIndex"] intValue];
        NSString *arrowImage = solidArrowImage[indexOfcolor];
        
        UIButton *arrowButton = [UIButton buttonWithType:UIButtonTypeCustom];
        arrowButton.frame = CGRectMake(leftMargin, heightOftimeLabel, 298 - leftMargin, heightOfArrowButton);
        [arrowButton setImage:[UIImage imageNamed:arrowImage]  forState:UIControlStateNormal];
        [arrowButton setImage:[UIImage imageNamed:arrowImage]  forState:UIControlStateHighlighted];
        [eachVoteView addSubview:arrowButton];
        
        [tempAttendArrowButtonArray addObject:arrowButton];
        
        UILabel *initiatorLabel = [[UILabel alloc] init];
        initiatorLabel.frame = CGRectMake(0, 0, 298 - leftMargin, heightOfArrowButton);
        initiatorLabel.textColor = [UIColor whiteColor];
        initiatorLabel.textAlignment = NSTextAlignmentCenter;
        initiatorLabel.text = [@"Initiator:" stringByAppendingString:[tempDictionary objectForKey:@"initiator"]];
        [arrowButton addSubview:initiatorLabel];
        
        NSString *stateString = [tempDictionary objectForKey:@"state"];
        UILabel *stateLabel = [[UILabel alloc] init];
        stateLabel.frame = CGRectMake(leftMargin, heightOftimeLabel + heightOfArrowButton, 298 - leftMargin, heightOfStateLabel);
        stateLabel.font = [UIFont systemFontOfSize:12];
        stateLabel.textAlignment = NSTextAlignmentCenter;
        timeLabel.textColor = [UIColor colorWithRed:0.0 green:0.443 blue:0.737 alpha:1.0];
        if ([stateString isEqualToString:@"YES"]) {
            stateLabel.text = @"This vote is finished";
        }else{
            stateLabel.text = @"This vote is in progress";
        }
        [eachVoteView addSubview:stateLabel];
    }
    initiatedArrowButtonArray = [[NSArray alloc] initWithArray:tempInitiatedArrowButtonArray];
}
*/


- (void)historySwitchAction:(UIButton *)sender
{
    int selectedIndex = _historySegment.selectedSegmentIndex;
    if (!selectedIndex) {
        attendedTableView.hidden = NO;
        initiatedTableView.hidden = YES;
    }else{
        attendedTableView.hidden = YES;
        initiatedTableView.hidden = NO;
    }
}

- (VoteArrowColor)getColor:(int)indexOfColor{
    switch (indexOfColor) {
        case 0:
            return greenArrow;
            break;
        case 1:
            return blueArrow;
            break;
        case 2:
            return yellowArrow;
            break;
        case 3:
            return redArrow;
            break;
        case 4:
            return grayArrow;
            break;
            
        default:
            return greenArrow;
            break;
    }
}

#pragma mark - PLServer delegate
- (void)plServer:(PLServer *)plServer didReceivedJSONString:(id)jsonString
{
    [self dismissLoadingView];

    NSDictionary *cacheDic = (NSDictionary*)jsonString;
    BOOL result = [[cacheDic valueForKey:@"success"] boolValue];
    
    NSLog(@"%@",cacheDic);
    
    if (result) {
        //check if is the refresh by location
        VoteRequestType requetType = [cacheDic getRequestType];
        
        switch (requetType) {
            case IndexHistory:{
                int indexType = [[cacheDic valueForKey:@"indextype"] intValue];
                
                if (indexType == 1) {
                    //fullfill the data
                    NSMutableArray *tempInitiateArray = [NSMutableArray arrayWithCapacity:3];
                    NSArray *historyDicArray = [cacheDic valueForKey:@"historylist"];
                    
                    if (historyDicArray.count != 0) {
                        for (NSDictionary *voteDic in historyDicArray) {
                            NSMutableDictionary *tmpDic  = [NSMutableDictionary dictionary];
                            [tmpDic setObject:[voteDic valueForKey:@"color"] forKey:@"colorIndex"];
                            [tmpDic setObject:[voteDic valueForKey:@"cteatetime"] forKey:@"time"];
                            [tmpDic setObject:[voteDic valueForKey:@"initiator"] forKey:@"initiator"];
                            
                            int currentUser = [[voteDic objectForKey:@"currentvalidvote"] intValue];
                            int maxValidUser = [[voteDic objectForKey:@"maxvaliduser"] intValue];
                            
                            if (currentUser == maxValidUser) {
                                [tmpDic setObject:@"YES" forKey:@"state"];
                            }else{
                                NSDateFormatter *df = [[NSDateFormatter alloc] init];
                                [df setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
                                NSString *endTimeString = [voteDic objectForKey:@"endtime"];
                                NSString *serverTimeString = [voteDic objectForKey:@"servercurrentime"];
                                
                                NSDate *endTime = [df dateFromString:endTimeString];
                                NSDate *serverCurrentTime = [df dateFromString:serverTimeString];
                                
                                int intervall = (int) [endTime timeIntervalSinceDate: serverCurrentTime] / 60;
                                
                                if (intervall > 0) {
                                    [tmpDic setObject:@"NO" forKey:@"state"];
                                }else{
                                    [tmpDic setObject:@"YES" forKey:@"state"];
                                }
                            }
                            

                            [tempInitiateArray addObject:tmpDic];
                        }
                    }
                    
                    initiateVoteList = [[NSArray alloc] initWithArray:tempInitiateArray];
                    
                    //request the particiapant
                    NSMutableDictionary *dic = [NSMutableDictionary getRequestDicWithRequestType:IndexHistory];
                    [dic setObject:[NSNumber numberWithInt:2] forKey:@"indextype"];
                    [dic setObject:UserId forKey:@"userid"];
                    
                    [[PLServer shareInstance] sendDataWithDic:dic];
                    
                    [self showLoadingView:@"" isWithCancelButton:NO];
                }else{
                    //refresh the scroll view
                    NSMutableArray *tempAttendArray = [NSMutableArray arrayWithCapacity:3];
                    NSArray *historyDicArray = [cacheDic valueForKey:@"historylist"];
                    
                    if (historyDicArray.count != 0) {
                        for (NSDictionary *voteDic in historyDicArray) {
                            NSMutableDictionary *tmpDic  = [NSMutableDictionary dictionary];
                            [tmpDic setObject:[voteDic valueForKey:@"color"] forKey:@"colorIndex"];
                            [tmpDic setObject:[voteDic valueForKey:@"cteatetime"] forKey:@"time"];
                            [tmpDic setObject:[voteDic valueForKey:@"initiator"] forKey:@"initiator"];
                            
                            int currentUser = [[voteDic objectForKey:@"currentvalidvote"] intValue];
                            int maxValidUser = [[voteDic objectForKey:@"maxvaliduser"] intValue];
                            
                            if (currentUser == maxValidUser) {
                                [tmpDic setObject:@"YES" forKey:@"state"];
                            }else{
                                NSDateFormatter *df = [[NSDateFormatter alloc] init];
                                [df setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
                                NSString *endTimeString = [voteDic objectForKey:@"endtime"];
                                NSString *serverTimeString = [cacheDic objectForKey:@"servercurrentime"];
                                
                                NSDate *endTime = [df dateFromString:endTimeString];
                                NSDate *serverCurrentTime = [df dateFromString:serverTimeString];
                                
                                int intervall = (int) [endTime timeIntervalSinceDate: serverCurrentTime] / 60;
                                
                                if (intervall > 0) {
                                    [tmpDic setObject:@"NO" forKey:@"state"];
                                }else{
                                    [tmpDic setObject:@"YES" forKey:@"state"];
                                }
                            }
                            
                            
                            [tempAttendArray addObject:tmpDic];
                        }
                    }
                    
                    attendedVoteList = [[NSArray alloc] initWithArray:tempAttendArray];
                    
                   // [self refresh];
                }
                
                break;
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

 
#pragma mark table view setting
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if ([tableView isEqual:attendedTableView]) {
        if (numberOfAllAttendedVotes) {
            return numberOfAllAttendedVotes;
        } else {
            return 1;
        }
        
    } else {
        if (numberOfAllInitiatedVotes) {
            return numberOfAllInitiatedVotes;
        } else {
            return 1;
        }
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    GLfloat heightOftimeLabel = 15;
    GLfloat heightOfArrowButton = 50;
    GLfloat heightOfStateLabel = 15;
    return heightOftimeLabel + heightOfArrowButton + heightOfStateLabel;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = nil;
    
    static NSString* emptyIdentifier = @"EmptyHistory";
    static NSString* cellIdentifier = @"History";
    
    NSDictionary *tempDictionary;
    NSInteger tempNumberOfVotes;
    NSString *emptyTips;
    
    NSString *textOutput;
    
    if ([tableView isEqual:attendedTableView]) {
       // tempDictionary = attendedVoteList[indexPath.row];
        tempNumberOfVotes = attendedVoteList.count;
        emptyTips = @"No attended vote history";
        textOutput = @"attended table";
    } else{
        //tempDictionary = initiateVoteList[indexPath.row];
        tempNumberOfVotes = initiateVoteList.count;
        emptyTips = @"No initiated vote history";
        textOutput = @"initiated table";
    }
    
    if (!tempNumberOfVotes) {
        cell = [tableView dequeueReusableCellWithIdentifier:emptyIdentifier];
        
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:emptyIdentifier];
            cell.textLabel.frame = CGRectMake(11, 0, 298, 70);
            cell.textLabel.textAlignment = NSTextAlignmentCenter;
            cell.textLabel.text = emptyTips;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
    } else {
        if ([tableView isEqual:attendedTableView]) {
            tempDictionary = attendedVoteList[indexPath.row];
        } else{
            tempDictionary = initiateVoteList[indexPath.row];
        }
        
        cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        }
        
        HistoryResultCell *tempCell = [[HistoryResultCell alloc] init];
        
        //index number
        tempCell.indexNumber = indexPath.row;
        
        //set time
        tempCell.timeLabel.text = [tempDictionary objectForKey:@"time"];
        
        //set arrow color
        int indexOfcolor = [[tempDictionary objectForKey:@"colorIndex"] intValue];
        tempCell.arrowCorlor = [self getColor:indexOfcolor];
        
        //set initiator's name
        tempCell.initiatorLabel.text = [@"Initiator:" stringByAppendingString:[tempDictionary objectForKey:@"initiator"]];
        
        //set state label
        NSString *stateString = [tempDictionary objectForKey:@"state"];
        if ([stateString isEqualToString:@"YES"]) {
            tempCell.stateLabel.text = @"This vote is finished";
        }else{
            tempCell.stateLabel.text = @"This vote is in progress";
        }
        
        [cell addSubview:tempCell];
    }
    
    return cell;
}

#pragma mark Data Source Loading / Reloading Methods
- (void)reloadTableViewDataSource{
    
    //  should be calling your tableviews data source model to reload
    //  put here just for demo
    _reloading = YES;
    
}

- (void)doneLoadingTableViewData{
    
    //  model should call this when its done loading
    _reloading = NO;
    [_refreshHeaderView egoRefreshScrollViewDataSourceDidFinishedLoading:attendedTableView];
    
}

#pragma mark UIScrollViewDelegate Methods

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    [_refreshHeaderView egoRefreshScrollViewDidScroll:scrollView];
    
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    
    [_refreshHeaderView egoRefreshScrollViewDidEndDragging:scrollView];
    
}

#pragma mark EGORefreshTableHeaderDelegate Methods

- (void)egoRefreshTableHeaderDidTriggerRefresh:(EGORefreshTableHeaderView*)view{
    
    [self reloadTableViewDataSource];
    [self performSelector:@selector(doneLoadingTableViewData) withObject:nil afterDelay:3.0];
    
}

- (BOOL)egoRefreshTableHeaderDataSourceIsLoading:(EGORefreshTableHeaderView*)view{
    
    return _reloading; // should return if data source model is reloading
    
}

- (NSDate*)egoRefreshTableHeaderDataSourceLastUpdated:(EGORefreshTableHeaderView*)view{
    
    return [NSDate date]; // should return date data source was last changed
    
}

@end
