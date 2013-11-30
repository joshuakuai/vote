//
//  searchVoteViewController.m
//  vote
//
//  Created by kuaijianghua on 11/10/13.
//  Copyright (c) 2013 rampageworks. All rights reserved.
//

#import "searchVoteViewController.h"
#import "VoteSearchResultCell.h"

@interface searchVoteViewController (){
    CLLocationManager *_locationManager;
    EGORefreshTableHeaderView *_refreshHeaderView;
    VoteSearchResultCell *_voteByIDResultView;
    BOOL _isReloading;
    BOOL _isAutoScroll;
}

@end

@implementation searchVoteViewController

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    
    if (self) {
        //set the tab bar item background
        [self.tabBarItem setFinishedSelectedImage:[UIImage imageNamed:@"AttendTabBarHighlight"] withFinishedUnselectedImage:[UIImage imageNamed:@"AttendTabBarNormal"]];
        
        self.tabBarItem.imageInsets = UIEdgeInsetsMake(6, 0, -6, 0);
    }
    
    return self;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBarHidden = YES;
    
    //set the plankton server's delegate
    [[PLServer shareInstance] setDelegate:self];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    _isAutoScroll = NO;
    [self dismissLoadingView];
    [_locationManager stopUpdatingLocation];
    [[PLServer shareInstance] closeConnection];
    [self doneLoadingVoteNearBy];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    //try to get the user's location,if the 
    if ([CLLocationManager locationServicesEnabled]) {
        //decide to scroll or not
        _isAutoScroll = YES;
        [_voteByLocationTableView setContentOffset:CGPointMake(0, -70) animated:YES];
    }else{
        [self showErrorMessage:@"Location service is not avaiable now, please use id to search.."];
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.voteSearchBar.delegate = self;
    
    self.voteByLocationArray = [[NSMutableArray alloc] initWithCapacity:3];
    
    //init the vote by location table view
    self.voteByLocationTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 44, 320, ScreenHeigh-44) style:UITableViewStyleGrouped];
    self.voteByLocationTableView.delegate = self;
    self.voteByLocationTableView.dataSource = self;
    self.voteByLocationTableView.separatorColor = [UIColor colorWithRed:1 green:1 blue:1 alpha:0];
    self.voteByLocationTableView.backgroundColor = [UIColor colorWithRed:1 green:1 blue:1 alpha:0];
    
    //add refresh
    _isReloading = NO;
    _isAutoScroll = NO;
	_refreshHeaderView = [[EGORefreshTableHeaderView alloc] initWithFrame:
                          CGRectMake(0.0f, 0.0f - self.view.bounds.size.height,self.view.frame.size.width, self.view.bounds.size.height)];
    _refreshHeaderView.delegate = self;
	[_voteByLocationTableView addSubview:_refreshHeaderView];
    [_refreshHeaderView refreshLastUpdatedDate];
    
    [self.view addSubview:_voteByLocationTableView];
    
    //init the vote by id view
    _voteByIDResultView = [[VoteSearchResultCell alloc] init];
    _voteByIDResultView.frame = CGRectMake(0, 44, _voteByIDResultView.frame.size.width, _voteByIDResultView.frame.size.height);
    [_voteByIDResultView setHidden:YES];
    [self.view addSubview:_voteByIDResultView];
    
    //hide the index label
    _voteByIDResultView.indexCell.hidden = YES;
    
    //init the vote object which will store the result of searching by id
    self.voteByIDInfo = [[Vote alloc] init];
}

- (void)dealloc
{
    self.voteByLocationTableView = nil;
    self.voteByLocationArray = nil;
    self.voteByIDInfo = nil;
    _refreshHeaderView = nil;
    _locationManager = nil;
    _voteByIDResultView = nil;
}

- (void)setVoteArrayByJSONArray:(NSArray*)voteJSONArray
{
    NSMutableArray *tmpArray = [[NSMutableArray alloc] init];
    
    for (NSDictionary *voteDic in voteJSONArray) {
        Vote* vote = [[Vote alloc] init];
        vote.initiator = [voteDic objectForKey:@"initiator"];
        vote.voteID = [[voteDic objectForKey:@"voteid"] integerValue];
        vote.colorIndex = [[voteDic objectForKey:@"color"] intValue];
        
        [tmpArray addObject:vote];
    }
    
    self.voteByLocationArray = tmpArray;
}

#pragma mark - Loading Relate
- (void)doneLoadingVoteNearBy
{
    _isReloading = NO;
    [_refreshHeaderView egoRefreshScrollViewDataSourceDidFinishedLoading:_voteByLocationTableView];
}

- (void)refreshVoteNearByHandler
{
    _isReloading = YES;
    
    if (!_locationManager) {
        _locationManager = [[CLLocationManager alloc] init];
        _locationManager.delegate = self;
    }
    
    [_locationManager startUpdatingLocation];
}

#pragma mark - UIScrollViewDelegate Methods

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [_refreshHeaderView egoRefreshScrollViewDidScroll:scrollView];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    [_refreshHeaderView egoRefreshScrollViewDidEndDragging:scrollView];
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView
{
    if (_isAutoScroll) {
        _isAutoScroll = NO;
        [_refreshHeaderView egoRefreshScrollViewDidEndDragging:scrollView];
    }
}

#pragma mark - EGO Delegate
- (void)egoRefreshTableDidTriggerRefresh:(EGORefreshPos)aRefreshPos
{
    [self refreshVoteNearByHandler];
}

- (BOOL)egoRefreshTableDataSourceIsLoading:(UIView*)view
{
    return _isReloading;
}

- (NSDate*)egoRefreshTableDataSourceLastUpdated:(UIView*)view
{
    return [NSDate date];
}

#pragma mark - Tableview delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    //TODO:request the vote data and prepare to segue to detial
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 30;
}

#pragma mark - Tableview datasource
- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = nil;
    
    static NSString* emptyCellIdentifier = @"SearchVoteEmptyCell";
    static NSString* arrowCellIdentifier = @"SearchVoteArrowCell";
    
    if (_voteByLocationArray.count == 0) {
        
        cell = [tableView dequeueReusableCellWithIdentifier:emptyCellIdentifier];
        
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:emptyCellIdentifier];
            cell.textLabel.frame = CGRectMake(0, 0, 320, 60);
            cell.textLabel.textAlignment = NSTextAlignmentCenter;
            cell.textLabel.text  = @"No Vote avaiable near by.";
        }
        
    }else{
        
        cell = [tableView dequeueReusableCellWithIdentifier:arrowCellIdentifier];
        
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:arrowCellIdentifier];
            
            VoteSearchResultCell *tmpCellView = [[VoteSearchResultCell alloc] init];
        
            tmpCellView.indexNumber = indexPath.row;
        
            //get the vote object
            Vote *tmpVote = [_voteByLocationArray objectAtIndex:indexPath.row];
            tmpCellView.arrowCorlor = tmpVote.colorIndex;
            tmpCellView.initiatorLabel.text = [NSString stringWithFormat:@"Initiator: %@",tmpVote.initiator];
            
            [cell addSubview:tmpCellView];
        }
    }
    
    return cell;
}

- (UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 30)];
    headView.backgroundColor = [UIColor colorWithRed:1 green:1 blue:1 alpha:0];
    
    //add arrow
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(20, 5, 20, 20)];
    imageView.image = [UIImage imageNamed:@"location_arrow.png"];
    [headView addSubview:imageView];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(60, 0, 250, 30)];
    label.text = @"All vote event near 1000m";
    [headView addSubview:label];
    
    return headView;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (_voteByLocationArray.count != 0) {
        return _voteByLocationArray.count;
    }else{
        return 1;
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

#pragma mark - Search bar delegate
- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar
{
    searchBar.showsCancelButton = YES;
    
    //hide the table view
    _voteByLocationTableView.hidden = YES;
}

- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar
{
    searchBar.showsCancelButton = NO;
    
    //hide the search reult view
    //hide the table view
    _voteByLocationTableView.hidden = NO;
    _voteByIDResultView.hidden = YES;
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    [searchBar resignFirstResponder];
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    //begin search by id
    
    //check if the id is valid
    if (!searchBar.text || !searchBar.text.length) {
        [self showErrorMessage:@"The id can't be empty!"];
        return;
    }
    
    NSMutableDictionary *dic = [NSMutableDictionary getRequestDicWithRequestType:SearchVote];
    [dic setObject:[NSNumber numberWithInt:0] forKey:@"searchtype"];
    [dic setObject:[NSNumber numberWithInt:[searchBar.text intValue]] forKey:@"voteid"];
    
    [[PLServer shareInstance] sendDataWithDic:dic];
    
    [self showLoadingView:@"" isWithCancelButton:NO];
}

#pragma mark - Location Manager delegate
- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    [_locationManager stopUpdatingLocation];
    
    //get current location and prepare the data
    CLLocationCoordinate2D location = manager.location.coordinate;
    
    NSMutableDictionary *dic = [NSMutableDictionary getRequestDicWithRequestType:SearchVote];
    [dic setObject:[NSNumber numberWithInt:0] forKey:@"searchtype"];
    [dic setObject:[NSNumber numberWithDouble:location.longitude] forKey:@"longitude"];
    [dic setObject:[NSNumber numberWithDouble:location.latitude] forKey:@"latitude"];
    
    [[PLServer shareInstance] sendDataWithDic:dic];
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    [self showErrorMessage:@"Failed to fetch vote near by, please check your setting and network."];
}

#pragma mark - PLServer delegate
- (void)plServer:(PLServer *)plServer didReceivedJSONString:(id)jsonString
{
    [self dismissLoadingView];
    [self doneLoadingVoteNearBy];

    NSDictionary *cacheDic = (NSDictionary*)jsonString;
    BOOL result = [[cacheDic valueForKey:@"success"] boolValue];
    if (result) {
        //check if is the refresh by location
        VoteRequestType requetType = [cacheDic getRequestType];
        
        switch (requetType) {
            case SearchVote:{
                //check the request type
                if ([[cacheDic valueForKey:@"searchtype"] intValue] == 0) {
                    //location
                    [self setVoteArrayByJSONArray:[cacheDic objectForKey:@"votelist"]];
                    [_voteByLocationTableView reloadData];
                }else{
                    NSArray *result = [cacheDic objectForKey:@"votelist"];
                    NSDictionary *voteDic = [result objectAtIndex:0];
                    
                    self.voteByIDInfo.initiator = [voteDic objectForKey:@"initiator"];
                    self.voteByIDInfo.voteID = [[voteDic objectForKey:@"voteid"] integerValue];
                    self.voteByIDInfo.colorIndex = [[voteDic objectForKey:@"color"] intValue];
                    
                    _voteByIDResultView.initiatorLabel.text =[NSString stringWithFormat:@"Initiator: %@",_voteByIDInfo.initiator];
                    _voteByIDResultView.arrowCorlor = _voteByIDInfo.colorIndex;
                    
                    //show the result
                    _voteByIDResultView.hidden = NO;
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
    [self doneLoadingVoteNearBy];
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
        [self doneLoadingVoteNearBy];
        [self showErrorMessage:@"Lost connection,check your internet connection."];
    }
}


@end
