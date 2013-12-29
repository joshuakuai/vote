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
    self = [super initWithFrame:CGRectMake(location.x, location.y, 30, 30)];
    
    if (self) {
        self.image = [UIImage imageNamed:@"CellIndexCircle"];
        
        //add this label to the circle
        self.indexLabel = [[UILabel alloc] initWithFrame:CGRectMake(2, 2, 26, 26)];
        self.indexLabel.font = [UIFont systemFontOfSize:12];
        self.indexLabel.textAlignment = NSTextAlignmentCenter;
        self.indexLabel.text = [NSString stringWithFormat:@"%d",number];
        
        [self addSubview:self.indexLabel];
    }
    
    return self;
}

- (void)dealloc
{
    self.indexLabel = nil;
}

- (void)setNumber:(int)number
{
    self.indexLabel.text = [NSString stringWithFormat:@"%ld",(long)number];
}

- (void)setCircleColorWhile
{
    self.image = [UIImage imageNamed:@"CellIndexCircleWhile"];
}

@end
