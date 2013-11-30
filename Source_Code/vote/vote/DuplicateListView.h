//
//  DuplicateListView.h
//  vote
//
//  Created by kuaijianghua on 11/30/13.
//  Copyright (c) 2013 rampageworks. All rights reserved.
//

#import <UIKit/UIKit.h>

@class DuplicateListView;

@protocol DuplicateListViewDelegate <NSObject>

- (void)deleteButtonTouched:(DuplicateListView*)duplicateListView deleteEmail:(NSString*)emailString;
- (void)finishDeleteItem:(DuplicateListView*)duplicateListView leftEmailRecord:(int)leftNumber;
- (void)doneButtonTouched:(DuplicateListView*)duplicateListView;

@end

@interface DuplicateListView : UIView

@property(nonatomic, strong)NSString *duplicateName;
@property(nonatomic, weak)id<DuplicateListViewDelegate> delegate;

- (id)initWithDuplicateName:(NSString*)name emailList:(NSArray*)emailList;
- (void)deleteSelectedEmail;

@end
