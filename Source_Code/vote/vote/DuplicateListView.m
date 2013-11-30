//
//  DuplicateListView.m
//  vote
//
//  Created by kuaijianghua on 11/30/13.
//  Copyright (c) 2013 rampageworks. All rights reserved.
//

#import "DuplicateListView.h"
#import "RedTitleView.h"
#import "CellIndexCircle.h"
#import "UILabel+SizeCalculate.h"

@interface DuplicateListView (){
    NSMutableArray *_emailList;
    NSMutableArray *_emailRecordViewArray;
    int _currentDeletingEmailIndex;
}

@end

@implementation DuplicateListView

- (id)initWithDuplicateName:(NSString*)name emailList:(NSArray*)emailList
{
    self = [super init];
    
    if (self) {
        self.duplicateName = name;
        _currentDeletingEmailIndex = -1;
        _emailList = [NSMutableArray arrayWithArray:emailList];
        _emailRecordViewArray = [NSMutableArray arrayWithCapacity:3];
        
        //calculate the height of the view
        self.frame = CGRectMake(0, 0, 320, 30*(emailList.count+1));
        
        //Add the Name title and Name
        RedTitleView *nameTitleRedView = [[RedTitleView alloc] initWithTittle:@"Name" location:CGPointMake(10, 5)];
        [self addSubview:nameTitleRedView];
        
        UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(57, 0, 295, 30)];
        nameLabel.text = name;
        nameLabel.font = [UIFont boldSystemFontOfSize:16];
        [self addSubview:nameLabel];
        
        //TODO:add done button
        
        
        //add the email title
        RedTitleView *emailTitleRedView = [[RedTitleView alloc] initWithTittle:@"Email" location:CGPointMake(10, 35)];
        [self addSubview:emailTitleRedView];
        
        //add list of email
        for (int i = 0; i<emailList.count; i++) {
            CGFloat heightForEmailRecord = 30*(i+1);
            
            UIView *recordView = [[UIView alloc] initWithFrame:CGRectMake(53, heightForEmailRecord, 267, 30)];
            
            //set the index number
            CellIndexCircle *indexCircle = [[CellIndexCircle alloc] initWithNumber:i+1 location:CGPointMake(0, 5)];
            indexCircle.tag = 10086;
            [recordView addSubview:indexCircle];
            
            //set email
            UILabel *emailLabel = [[UILabel alloc] initWithFrame:CGRectMake(22, 0, 214, 30)];
            emailLabel.textAlignment = NSTextAlignmentNatural;
            emailLabel.text = [emailList objectAtIndex:i];
            
            //reset the size of label
            CGSize expectSize = [emailLabel perfectLabelSizeWithMaxSize:CGSizeMake(200, 30)];
            emailLabel.frame = CGRectMake(emailLabel.frame.origin.x, 0, expectSize.width, 30);
            
            emailLabel.numberOfLines = 1;
            emailLabel.adjustsFontSizeToFitWidth = YES;
            [recordView addSubview:emailLabel];
            
            //add delete button
            UIButton *deleteButton = [[UIButton alloc] initWithFrame:CGRectMake(expectSize.width+emailLabel.frame.origin.x + 3, 3, 22, 25)];
            deleteButton.tag = i;
            [deleteButton setBackgroundImage:[UIImage imageNamed:@"DeleteButton"] forState:UIControlStateNormal];
            [deleteButton addTarget:self action:@selector(deleteEmail:) forControlEvents:UIControlEventTouchUpInside];
            [recordView addSubview:deleteButton];
            
            //add the view to the list and array
            [self addSubview:recordView];
            [_emailRecordViewArray addObject:recordView];
        }
    }
    
    return self;
}

- (void)dealloc
{
    self.duplicateName = nil;
    [_emailList removeAllObjects];
    _emailList = nil;
    [_emailRecordViewArray removeAllObjects];
    _emailRecordViewArray = nil;
}

- (void)deleteEmail:(UIButton*)sender
{
    //delete button taped
    if (_delegate && [_delegate respondsToSelector:@selector(deleteButtonTouched:deleteEmail:)]) {
        _currentDeletingEmailIndex = sender.tag;
        [_delegate deleteButtonTouched:self deleteEmail:[_emailList objectAtIndex:sender.tag]];
    }
}

- (void)deleteSelectedEmail;
{
    [UIView animateWithDuration:0.3 animations:^(void){
        //change the alpha of the deleting view
        UIView *duplicateView = [_emailRecordViewArray objectAtIndex:_currentDeletingEmailIndex];
        [duplicateView setAlpha:0.0];
        
        for (int i = _currentDeletingEmailIndex+1; i<_emailList.count; i++) {
            UIView *duplicateView = [_emailRecordViewArray objectAtIndex:i];
            
            CGRect tmpFrame = duplicateView.frame;
            
            duplicateView.frame = CGRectMake(tmpFrame.origin.x, tmpFrame.origin.y-30, tmpFrame.size.width, tmpFrame.size.height);
        }
    }completion:^(BOOL isfinished){
        //reset all circle number and the delete button tag after the deleted item
        for (int i = _currentDeletingEmailIndex+1; i<_emailList.count; i++) {
            UIView *duplicateView = [_emailRecordViewArray objectAtIndex:i];
            
            //change the circle number
            CellIndexCircle *cellIndexCircle = (CellIndexCircle*)[duplicateView viewWithTag:10086];
            [cellIndexCircle setNumber:i];
            
            //change the delete button tag
            UIButton *deleteButton = (UIButton*)[duplicateView viewWithTag:i];
            deleteButton.tag -= 1;
        }
        
        //delete the email record from the email list and remove the view
        [_emailList removeObjectAtIndex:_currentDeletingEmailIndex];
        
        //remove the deleted view from super view
        UIView *duplicateView = [_emailRecordViewArray objectAtIndex:_currentDeletingEmailIndex];
        [duplicateView removeFromSuperview];
        [_emailRecordViewArray removeObjectAtIndex:_currentDeletingEmailIndex];
        
        //resize the view's frame
        self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, 320, self.frame.size.height-30);
        
        _currentDeletingEmailIndex = -1;
        if (_delegate && [_delegate respondsToSelector:@selector(finishDeleteItem:leftEmailRecord:)]) {
            [_delegate finishDeleteItem:self leftEmailRecord:_emailList.count];
        }
    }];
}

@end
