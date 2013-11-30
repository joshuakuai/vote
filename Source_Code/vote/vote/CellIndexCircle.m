//
//  CellIndexCircle.m
//  vote
//
//  Created by kuaijianghua on 11/30/13.
//  Copyright (c) 2013 rampageworks. All rights reserved.
//

#import "CellIndexCircle.h"

@implementation CellIndexCircle

- (id)initWithNumber:(int)number location:(CGPoint)location
{
    self = [super initWithFrame:CGRectMake(location.x, location.y, 40, 40)];
    
    if (self) {
        self.image = [UIImage imageNamed:@"CellIndexCircle"];
        
        //add this label to the circle
        _indexLabel = [[UILabel alloc] initWithFrame:CGRectMake(2, 2, 36, 36)];
        _indexLabel.font = [UIFont systemFontOfSize:12];
        _indexLabel.text = [NSString stringWithFormat:@"%d",number];
        
        [self addSubview:_indexLabel];
    }
    
    return self;
}

- (void)dealloc
{
    _indexLabel = nil;
}

- (void)setNumber:(int)number
{
    _indexLabel.text = [NSString stringWithFormat:@"%ld",(long)number];
}

@end
