//
//  OptionView.h
//  vote
//
//  Created by kuaijianghua on 12/24/13.
//  Copyright (c) 2013 rampageworks. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol OptionViewDelegate <NSObject>

- (void)signoutButtonTapped;
- (void)setPasswordButtonTapped;
- (void)aboutButtonTapped;

@end

@interface OptionView : UIView<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,weak) id<OptionViewDelegate> delegate;

@end
