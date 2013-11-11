//
//  searchVoteViewController.h
//  vote
//
//  Created by kuaijianghua on 11/10/13.
//  Copyright (c) 2013 rampageworks. All rights reserved.
//

#import "BaseViewController.h"
#include <CoreLocation/CoreLocation.h>

@interface searchVoteViewController : BaseViewController<PLServerDelegate,CLLocationManagerDelegate>
@property (weak, nonatomic) IBOutlet UILabel *locationServiceUnavailableLabel;
@property (weak, nonatomic) IBOutlet UISearchBar *voteSearchBar;

@end
