//
//  DuplicateListView.m
//  vote
//
//  Created by kuaijianghua on 11/30/13.
//  Copyright (c) 2013 rampageworks. All rights reserved.
//

#import "DuplicateListView.h"
#import "RedTitleView.h"

@interface DuplicateListView (){
    NSString *_duplicateName;
    NSMutableArray *_emailList;
}

@end

@implementation DuplicateListView

- (id)initWithDuplicateName:(NSString*)name emailList:(NSArray*)emailList
{
    self = [super init];
    
    if (self) {
        _duplicateName = name;
        _emailList = [NSMutableArray arrayWithArray:emailList];
        
        //calculate the height of the view
        self.frame = CGRectMake(0, 0, 320, 22*(emailList.count+1));
        
        //Add the Name title
    }
    
    return self;
}



- (void)dealloc
{
    _duplicateName = nil;
    _emailList = nil;
}

@end
