//
//  DuplicateVoteHandleViewController.m
//  vote
//
//  Created by kuaijianghua on 11/30/13.
//  Copyright (c) 2013 rampageworks. All rights reserved.
//

#import "DuplicateVoteHandleViewController.h"

@interface DuplicateVoteHandleViewController (){
    NSMutableArray *_duplicateListViewArray;
    
    int _currentOperationViewTag;
}

@end

@implementation DuplicateVoteHandleViewController

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    
    if (self) {
        _duplicateListViewArray = [NSMutableArray arrayWithCapacity:3];
        _currentOperationViewTag = -1;
        self.voteid = -1;
        
        NSArray *textEmailListArray = [[NSArray alloc] initWithObjects:@"1123@qq.com",@"12312412@qq.com",@"kuaijianghua@yaoho.com.cn",nil];
        NSArray *textEmailListArray2 = [[NSArray alloc] initWithObjects:@"asdasdas@qq.com",@"woceshi@qq.com",@"kuaijianghua@yaoho.com.cn",nil];
        
        NSDictionary *textDuplicateDictionary = [NSDictionary dictionaryWithObjectsAndKeys:textEmailListArray,@"jianghua kuai",textEmailListArray2,@"shuai zhao",nil];
        
        self.duplicateDictionary = textDuplicateDictionary;
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
    
    [self dismissLoadingView];
    [[PLServer shareInstance] closeConnection];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	
    NSArray *nameList = [self.duplicateDictionary allKeys];
    
    CGFloat yLocationForNextDuplicateView = 0;
    //set the duplicate view list
    for (int i = 0;i<nameList.count;i++) {
        NSString *name = [nameList objectAtIndex:i];
        
        NSArray *emailList = [self.duplicateDictionary objectForKey:name];
        
        DuplicateListView *duplicateView = [[DuplicateListView alloc] initWithDuplicateName:name emailList:emailList];
        duplicateView.frame = CGRectMake(0, yLocationForNextDuplicateView, 320, duplicateView.frame.size.height);
        duplicateView.delegate = self;
        duplicateView.tag = i;
        [self.duplicateListScrollView addSubview:duplicateView];
        [_duplicateListViewArray addObject:duplicateView];
        
        //re-calculate the ylocation
        yLocationForNextDuplicateView +=duplicateView.frame.size.height;
    }
    
    //set the scrollview's content size
    [self.duplicateListScrollView setContentSize:CGSizeMake(320, yLocationForNextDuplicateView)];
}

- (void)dealloc
{
    self.duplicateDictionary = nil;
    [_duplicateListViewArray removeAllObjects];
    _duplicateListViewArray = nil;
}


- (void)beginDeleteRecordLocal
{
    //Delete the record inside the view
    DuplicateListView *currentDeletingDuplicateView = [_duplicateListViewArray objectAtIndex:_currentOperationViewTag];
    
    //begin delete the item, will get call back
    [currentDeletingDuplicateView deleteSelectedEmail];
}

- (void)finishDuplicateOperation
{
    //send the request to server to try to end this vote
    
}

#pragma mark - Duplicate List View delegate
- (void)deleteButtonTouched:(DuplicateListView*)duplicateListView deleteEmail:(NSString*)emailString
{
    //get the tag of this duplicate list view
    _currentOperationViewTag = duplicateListView.tag;
    
    //test
    [self beginDeleteRecordLocal];
    
    /*
     //prepare the data
     NSMutableDictionary *dic = [NSMutableDictionary getRequestDicWithRequestType:CancelSelection];
     [dic setObject:[NSNumber numberWithInt:self.voteid] forKey:@"voteid"];
     [dic setObject:emailString forKey:@"email"];
     
     [[PLServer shareInstance] sendDataWithDic:dic];
     
     [self showLoadingView:@"" isWithCancelButton:NO];
     
     //prevent the use to touch the screen again
     self.view.userInteractionEnabled = NO;
     */
}

- (void)finishDeleteItem:(DuplicateListView*)duplicateListView leftEmailRecord:(int)leftNumber
{
    //if this view only have one record now, delete this view from the scroll view, reset the content size
    if (leftNumber == 1) {
        
        //if there are only one duplicate view, the operation automatically end
        if (_duplicateListViewArray.count == 1) {
            [self finishDuplicateOperation];
        }
        
        DuplicateListView *tmpView = [_duplicateListViewArray objectAtIndex:_currentOperationViewTag];
        CGFloat tmpViewHeight = tmpView.frame.size.height+30;
        
        //or we should move up all other view
        [UIView animateWithDuration:0.2 animations:^(void){
            [tmpView setAlpha:0.0];
            
            for (int i = _currentOperationViewTag+1; i<_duplicateListViewArray.count; i++) {
                DuplicateListView *tmpMovingView = [_duplicateListViewArray objectAtIndex:i];
                
                CGRect tmpFrame = tmpMovingView.frame;
                tmpMovingView.frame = CGRectMake(tmpFrame.origin.x, tmpFrame.origin.y-tmpViewHeight, tmpFrame.size.width, tmpFrame.size.height);
            }
        }completion:^(BOOL isFinished){
            if (isFinished) {
                //change the tag of all duplicate view
                for (int i =_currentOperationViewTag+1; i<_duplicateListViewArray.count; i++) {
                    DuplicateListView *tmpDuplicateView = [_duplicateListViewArray objectAtIndex:i];
                    tmpDuplicateView.tag -= 1;
                }
                
                //remove the view from array and super view
                [tmpView removeFromSuperview];
                [_duplicateListViewArray removeObjectAtIndex:_currentOperationViewTag];
                
                _currentOperationViewTag = -1;
                self.view.userInteractionEnabled = YES;
            }
        }];
    }else{
        [UIView animateWithDuration:0.2 animations:^(void){
            for (int i = _currentOperationViewTag+1; i<_duplicateListViewArray.count; i++) {
                DuplicateListView *tmpMovingView = [_duplicateListViewArray objectAtIndex:i];
                
                CGRect tmpFrame = tmpMovingView.frame;
                tmpMovingView.frame = CGRectMake(tmpFrame.origin.x, tmpFrame.origin.y-30, tmpFrame.size.width, tmpFrame.size.height);
            }
        }completion:^(BOOL isFinished){
            if (isFinished) {
                _currentOperationViewTag = -1;
                self.view.userInteractionEnabled = YES;
            }
        }];
    }
}

#pragma mark - PLServer delegate
- (void)plServer:(PLServer *)plServer didReceivedJSONString:(id)jsonString
{
    [self dismissLoadingView];
    
    NSDictionary *cacheDic = (NSDictionary*)jsonString;
    BOOL result = [[cacheDic valueForKey:@"success"] boolValue];
    
    VoteRequestType requetType = [cacheDic getRequestType];
    if (result) {

        switch (requetType) {
            case CancelSelection:{
                [self beginDeleteRecordLocal];
                break;
            }
                
            case AdminResolveVote:{
                [self dismissViewControllerAnimated:YES completion:nil];
                break;
            }
                
            default:
                break;
        }
        
    }else{
        [self showErrorMessage:[cacheDic valueForKey:@"msg"]];
        if (requetType == AdminResolveVote) {
            [self dismissViewControllerAnimated:YES completion:nil];
        }
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
