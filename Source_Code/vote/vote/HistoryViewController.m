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
    
    NSArray *attendedVoteList;
    NSArray *initiateVoteList;
    
    EGORefreshTableHeaderView *_refreshHeaderViewAttended;
    EGORefreshTableHeaderView *_refreshHeaderViewInitiated;
    
    BOOL _reloading;
    BOOL _reloadAttendedData;
    BOOL _reloadInitiatedData;
    
    UIView *historyContentView;
    OptionView *optionView;
}

@end

@implementation HistoryViewController

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    
    if (self) {
        //set the tab bar item background
        [self.tabBarItem setFinishedSelectedImage:[UIImage imageNamed:@"HistoryTabBarHighlight"] withFinishedUnselectedImage:[UIImage imageNamed:@"HistoryTabBarNormal"]];
        self.tabBarItem.imageInsets = UIEdgeInsetsMake(6, 0, -6, 0);
    }
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    historyContentView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, ScreenHeigh)];
    historyContentView.backgroundColor = [UIColor whiteColor];
    optionView = [[OptionView alloc] initWithFrame:CGRectMake(0, 0, 320, ScreenHeigh)];
    optionView.delegate = self;
    
    indexImage = @"CellIndexCircle";
    
    attendedVoteList = [[NSArray alloc] initWithObjects: nil];
    initiateVoteList = [[NSArray alloc] initWithObjects: nil];
    
    attendArrowButtonArray = [[NSArray alloc] initWithObjects: nil];
    initiatedArrowButtonArray = [[NSArray alloc] initWithObjects: nil];
    
    
    solidArrowImage = [[NSArray alloc] initWithObjects:@"GreenSolidArrow", @"BlueSolidArrow", @"YellowSolidArrow", @"RedSolidArrow", @"GraySolidArrow", nil];

    _titleImage = @"titleImage";
    UIImageView *titleImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:_titleImage]];
    titleImageView.frame = CGRectMake(60, 10, 200, 100);
    [historyContentView addSubview:titleImageView];
    
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
    [historyContentView addSubview:emailLabel];
    
    _historySegment = [ [ UISegmentedControl alloc ] initWithItems: nil ];
    _historySegment.segmentedControlStyle = UISegmentedControlStyleBar;
    
    _historySegment.frame = CGRectMake(0, 130, 320, 30);
    [ _historySegment insertSegmentWithTitle:@"Attended" atIndex: 0 animated: NO ];
    [_historySegment insertSegmentWithTitle:@"Initiated" atIndex: 1 animated: NO ];
    [historyContentView addSubview:_historySegment];
    [_historySegment addTarget:self action:@selector(historySwitchAction:) forControlEvents:UIControlEventValueChanged];
    _historySegment.selectedSegmentIndex = 0;
    
    CGRect tableFrame = CGRectMake(0, 170, 320, 349);
        
    attendedTableView = [[UITableView alloc] init];
    attendedTableView.frame = tableFrame;
    [attendedTableView setDelegate:self];
    [attendedTableView setDataSource:self];
    attendedTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    //attendedTableView.layer.borderWidth = 2;
    [historyContentView addSubview:attendedTableView];
    
    initiatedTableView = [[UITableView alloc] init];
    initiatedTableView.frame = tableFrame;
    [initiatedTableView setDelegate:self];
    [initiatedTableView setDataSource:self];
    initiatedTableView.hidden = YES;
    initiatedTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [historyContentView addSubview:initiatedTableView];
 
    numberOfAllAttendedVotes = attendedVoteList.count;
    numberOfAllInitiatedVotes = initiateVoteList.count;
    
    _refreshHeaderViewAttended = [[EGORefreshTableHeaderView alloc] initWithFrame:CGRectMake(0.0f, 0.0f - tableFrame.size.height, tableFrame.size.width, tableFrame.size.height)];
    _refreshHeaderViewAttended.delegate = self;
    [attendedTableView addSubview:_refreshHeaderViewAttended];
    [_refreshHeaderViewAttended refreshLastUpdatedDate];
    _reloadAttendedData = NO;
    
    _refreshHeaderViewInitiated = [[EGORefreshTableHeaderView alloc] initWithFrame:CGRectMake(0.0f, 0.0f - tableFrame.size.height, tableFrame.size.width, tableFrame.size.height)];
    _refreshHeaderViewInitiated.delegate = self;
    [initiatedTableView addSubview:_refreshHeaderViewInitiated];
    [_refreshHeaderViewInitiated refreshLastUpdatedDate];
    _reloadInitiatedData = NO;
    
    //More option button
    UIButton *moreButton = [UIButton buttonWithType:UIButtonTypeContactAdd];
    moreButton.center = CGPointMake(300, 10);
    [moreButton addTarget:self action:@selector(showOptionView:) forControlEvents:UIControlEventTouchUpInside];
    
    [historyContentView addSubview:moreButton];
    
    //Add option view
    [self.view addSubview:optionView];

    [self.view addSubview:historyContentView];
    
    [self.view sendSubviewToBack:optionView];
}

- (void)dealloc
{
    self.historySegment = nil;
    self.voteHistoryArray = nil;
    self.emailAddress = nil;
}

- (void)viewDidAppear:(BOOL)animated
{
    [attendedTableView setContentOffset:CGPointMake(0, -70) animated:YES];
}

- (void)historySwitchAction:(UIButton *)sender
{
    int selectedIndex = _historySegment.selectedSegmentIndex;
    if (!selectedIndex) {
        attendedTableView.hidden = NO;
        initiatedTableView.hidden = YES;
        [attendedTableView setContentOffset:CGPointMake(0, -70) animated:YES];
    }else{
        attendedTableView.hidden = YES;
        initiatedTableView.hidden = NO;
        [initiatedTableView setContentOffset:CGPointMake(0, -70) animated:YES];
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

#pragma mark - Option View delegate
- (void)signoutButtonTapped
{
    //set the user id as 0
    [[NSUserDefaults standardUserDefaults] setInteger:0 forKey:@"userid"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    //dismiss the tab bar controller
    [self.tabBarController dismissViewControllerAnimated:YES completion:^(void){
        [[NSNotificationCenter defaultCenter] postNotificationName:@"UserLogout" object:nil];
    }];
}

- (void)setPasswordButtonTapped
{
    //show set password controller view
    [self performSegueWithIdentifier:@"historyViewShowSetPasswordViewSegue" sender:self];
}

- (void)aboutButtonTapped
{
    //show about controller view
    [self performSegueWithIdentifier:@"historyViewShowAboutViewSegue" sender:self];
}

#pragma mark - PLServer delegate
- (void)plServer:(PLServer *)plServer didReceivedJSONString:(id)jsonString
{
    [self dismissLoadingView];

    NSDictionary *cacheDic = (NSDictionary*)jsonString;
    BOOL result = [[cacheDic valueForKey:@"success"] boolValue];
    
    //NSLog(@"%@",cacheDic);
    
    if (result) {
        //check if is the refresh by location
        VoteRequestType requetType = [cacheDic getRequestType];
        
        switch (requetType) {
            case IndexHistory:{
                int indexType = [[cacheDic valueForKey:@"indextype"] intValue];
                
                NSArray *historyDicArray = [cacheDic valueForKey:@"historylist"];
                NSString *serverTimeString = [cacheDic objectForKey:@"servercurrentime"];
                
                if (indexType == 1) {
                    NSArray *tempInitiateArray = [self getTempArray:historyDicArray serverTimeString:serverTimeString];
                    initiateVoteList = [[NSArray alloc] initWithArray:tempInitiateArray];
                    
                    [initiatedTableView reloadData];
                }else{
                    NSArray *tempAttendArray = [self getTempArray:historyDicArray serverTimeString:serverTimeString];
                    attendedVoteList = [[NSArray alloc] initWithArray:tempAttendArray];
                    
                    [attendedTableView reloadData];
                }
                
                [self performSelector:@selector(doneLoadingTableViewData) withObject:nil afterDelay:1];
                
                break;
            }
                
            default:
                break;
        }
        
    }else{
        [self showErrorMessage:[cacheDic valueForKey:@"msg"]];
    }
}

- (NSArray*)getTempArray:(NSArray*)historyDicArray serverTimeString:(NSString*)serverTimeString
{
    NSMutableArray *tempAttendArray = [NSMutableArray arrayWithCapacity:3];
    
    if (historyDicArray.count != 0) {
        for (NSDictionary *voteDic in historyDicArray) {
            NSMutableDictionary *tmpDic  = [NSMutableDictionary dictionary];
            [tmpDic setObject:[voteDic valueForKey:@"color"] forKey:@"colorIndex"];
            [tmpDic setObject:[voteDic valueForKey:@"createtime"] forKey:@"time"];
            [tmpDic setObject:[voteDic valueForKey:@"initiator"] forKey:@"initiator"];
            
            int currentUser = [[voteDic objectForKey:@"currentvalidvote"] intValue];
            int maxValidUser = [[voteDic objectForKey:@"maxvaliduser"] intValue];
            
            if (currentUser == maxValidUser) {
                [tmpDic setObject:@"YES" forKey:@"state"];
            }else{
                NSDateFormatter *df = [[NSDateFormatter alloc] init];
                [df setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
                NSString *endTimeString = [voteDic objectForKey:@"endtime"];
                
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
    
    return tempAttendArray;
}

#pragma - mark Table view delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}
 
#pragma mark table view setting
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

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = nil;
    
    static NSString* emptyIdentifier = @"EmptyHistory";
    static NSString* cellIdentifier = @"History";
    
    NSDictionary *tempDictionary;
    NSInteger tempNumberOfVotes;
    NSString *emptyTips;
    
    if ([tableView isEqual:attendedTableView]) {
       // tempDictionary = attendedVoteList[indexPath.row];
        tempNumberOfVotes = attendedVoteList.count;
        emptyTips = @"No attended vote history";
    } else{
        //tempDictionary = initiateVoteList[indexPath.row];
        tempNumberOfVotes = initiateVoteList.count;
        emptyTips = @"No initiated vote history";
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
        
        [cell.contentView addSubview:tempCell];
    }
    
    return cell;
}

#pragma mark Data Source Loading / Reloading Methods
- (void)reloadTableViewDataSource{
    _reloading = YES;
    
    NSMutableDictionary *dic = [NSMutableDictionary getRequestDicWithRequestType:IndexHistory];
    [dic setObject:UserId forKey:@"userid"];
    
    if (_reloadAttendedData) {
        //get the data from server, initia first
        [dic setObject:[NSNumber numberWithInt:2] forKey:@"indextype"];
    }
    
    if (_reloadInitiatedData) {
        [dic setObject:[NSNumber numberWithInt:1] forKey:@"indextype"];
    }
    
    //NSLog(@"%@",[dic description]);
    
    [[PLServer shareInstance] sendDataWithDic:dic];
}

- (void)doneLoadingTableViewData{
    _reloading = NO;
    _reloadAttendedData = NO;
    _reloadInitiatedData = NO;
    [_refreshHeaderViewAttended egoRefreshScrollViewDataSourceDidFinishedLoading:attendedTableView];
    [_refreshHeaderViewInitiated egoRefreshScrollViewDataSourceDidFinishedLoading:initiatedTableView];
}

#pragma mark UIScrollViewDelegate Methods

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    if ([scrollView isEqual:attendedTableView]) {
        [_refreshHeaderViewAttended egoRefreshScrollViewDidScroll:scrollView];
        _reloadAttendedData = YES;
    } else {
        [_refreshHeaderViewInitiated egoRefreshScrollViewDidScroll:scrollView];
        _reloadInitiatedData = YES;
    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if ([scrollView isEqual:attendedTableView]) {
        [_refreshHeaderViewAttended egoRefreshScrollViewDidEndDragging:scrollView];
    } else {
        [_refreshHeaderViewInitiated egoRefreshScrollViewDidEndDragging:scrollView];
    }
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView
{
    if ([scrollView isEqual:attendedTableView]) {
        [_refreshHeaderViewAttended egoRefreshScrollViewDidEndDragging:scrollView];
    } else {
        [_refreshHeaderViewInitiated egoRefreshScrollViewDidEndDragging:scrollView];
    }
}

#pragma mark EGORefreshTableHeaderDelegate Methods
- (void)egoRefreshTableDidTriggerRefresh:(EGORefreshPos)aRefreshPos
{
    [self reloadTableViewDataSource];
}

- (BOOL)egoRefreshTableHeaderDataSourceIsLoading:(EGORefreshTableHeaderView*)view{
    return _reloading; // should return if data source model is reloading
}

- (NSDate*)egoRefreshTableDataSourceLastUpdated:(UIView*)view
{
    return [NSDate date];
}

- (void)showOptionView:(id)sender
{
    if (historyContentView.frame.origin.x==0) {
        [UIView animateWithDuration:0.2 animations:^(void){
            historyContentView.frame = CGRectMake(-160, 0, 320, ScreenHeigh);
        }];
    }else{
        [UIView animateWithDuration:0.2 animations:^(void){
            historyContentView.frame = CGRectMake(0, 0, 320, ScreenHeigh);
        }];
    }
}

@end
