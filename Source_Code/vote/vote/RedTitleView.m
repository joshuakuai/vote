//
//  RedTitleView.m
//  vote
//
//  Created by kuaijianghua on 11/30/13.
//  Copyright (c) 2013 rampageworks. All rights reserved.
//

#import "RedTitleView.h"

@implementation RedTitleView

- (id)initWithTittle:(NSString*)title location:(CGPoint)location
{
    self = [super initWithFrame:CGRectMake(location.x, location.y, 38, 20)];
    
    if (self) {
        //set background
        self.image = [UIImage imageNamed:@"RedTitleBackground"];
        
        //add tittle
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 38, 20)];
        titleLabel.text = title;
        titleLabel.textColor = [UIColor whiteColor];
        [self addSubview:titleLabel];
    }
    
    return self;
}

@end
