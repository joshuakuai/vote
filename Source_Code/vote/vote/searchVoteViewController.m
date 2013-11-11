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
    
    [self dismissLoadingView];
    [_locationManager stopUpdatingLocation];
    [[PLServer shareInstance] closeConnection];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    //try to get the user's location,if the 
    if ([CLLocationManager locationServicesEnabled]) {
        [self startRefreshVoteNearBy];
        _locationServiceUnavailableLabel.hidden = YES;
    }else{
        _locationServiceUnavailableLabel.hidden = NO;
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    _voteSearchBar.delegate = self;
}

- (void)startRefreshVoteNearBy
{
    if (!_locationManager) {
        _locationManager = [[CLLocationManager alloc] init];
        _locationManager.delegate = self;
    }
    
    [self showLoadingView:@"" isWithCancelButton:NO];
    
    [_locationManager startUpdatingLocation];
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
    //begin search the
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
