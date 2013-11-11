//
//  searchVoteViewController.m
//  vote
//
//  Created by kuaijianghua on 11/10/13.
//  Copyright (c) 2013 rampageworks. All rights reserved.
//

#import "searchVoteViewController.h"

@interface searchVoteViewController (){
    CLLocationManager *_locationManager;
    EGORefreshTableHeaderView *_refreshHeaderView;
    BOOL _isReloading;
    BOOL _isAutoScroll;
}

@end

@implementation searchVoteViewController

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
    
    _voteSearchBar.delegate = self;
    
    _voteByLocationArray = [[NSMutableArray alloc] initWithCapacity:3];
    
    //init the vote by location table view
    _voteByLocationTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 44, 320, ScreenHeigh-44) style:UITableViewStyleGrouped];
    _voteByLocationTableView.delegate = self;
    _voteByLocationTableView.dataSource = self;
    _voteByLocationTableView.separatorColor = [UIColor colorWithRed:1 green:1 blue:1 alpha:0];
    _voteByLocationTableView.backgroundColor = [UIColor colorWithRed:1 green:1 blue:1 alpha:0];
    
    //add refresh
    _isReloading = NO;
    _isAutoScroll = NO;
	_refreshHeaderView = [[EGORefreshTableHeaderView alloc] initWithFrame:
                          CGRectMake(0.0f, 0.0f - self.view.bounds.size.height,self.view.frame.size.width, self.view.bounds.size.height)];
    _refreshHeaderView.delegate = self;
	[_voteByLocationTableView addSubview:_refreshHeaderView];
    [_refreshHeaderView refreshLastUpdatedDate];

    
    [self.view addSubview:_voteByLocationTableView];
}

- (void)dealloc
{
    _voteByLocationTableView = nil;
    _voteByLocationArray = nil;
    _refreshHeaderView = nil;
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

#pragma mark - Loading Relate
- (void)doneLoadingVoteNearBy
{
    _isReloading = NO;
    [_refreshHeaderView egoRefreshScrollViewDataSourceDidFinishedLoading:_voteByLocationTableView];
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
    
    //request the vote data and prepare to segue to detial
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
    static NSString* identifier = @"SearchVoteCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        
        if (_voteByLocationArray.count == 0) {
            cell.textLabel.text  = @"No Vote avaiable near by.";
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
    
    //show the search result view
}

- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar
{
    searchBar.showsCancelButton = NO;
    
    //hide the search reult view
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    [searchBar resignFirstResponder];
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    //begin search by id
}

#pragma mark - Location Manager delegate
- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    [_locationManager stopUpdatingLocation];
    
    //get current location and prepare the data
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    [self showErrorMessage:@"Failed to fetch vote near by, please check your setting and network."];
}

#pragma mark - PLServer delegate
- (void)plServer:(PLServer *)plServer didReceivedJSONString:(id)jsonString
{
    [self dismissLoadingView];
    NSDictionary *cacheDic = (NSDictionary*)jsonString;
    BOOL result = [[cacheDic valueForKey:@"success"] boolValue];
    if (result) {
        //check if is the refresh by location
        //refresh finish
        [self doneLoadingVoteNearBy];
        
        
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
