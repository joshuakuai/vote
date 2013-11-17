//
//  searchVoteViewController.h
//  vote
//
//  Created by kuaijianghua on 11/10/13.
//  Copyright (c) 2013 rampageworks. All rights reserved.
//

#import "BaseViewController.h"
#include <CoreLocation/CoreLocation.h>
#import "EGORefreshTableHeaderView.h"
#import "Vote.h"

@interface searchVoteViewController : BaseViewController<PLServerDelegate,CLLocationManagerDelegate,UISearchBarDelegate,UITableViewDataSource,UITableViewDelegate,EGORefreshTableDelegate,UIScrollViewDelegate>

@property (weak, nonatomic) IBOutlet UISearchBar *voteSearchBar;
@property (strong, nonatomic) UITableView *voteByLocationTableView;
@property (strong, nonatomic) NSMutableArray *voteByLocationArray;
@property (strong, nonatomic) Vote *voteByIDInfo;

@end
