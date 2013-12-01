//
//  RedTitleView.m
//  vote
//
//  Created by kuaijianghua on 11/30/13.
//  Copyright (c) 2013 rampageworks. All rights reserved.
//

#import "TitleView.h"

@implementation TitleView

- (id)initWithTittle:(NSString*)title color:(TitleBackgroundColor)color location:(CGPoint)location
{
    self = [super initWithFrame:CGRectMake(location.x, location.y, 57, 30)];
    
    if (self) {
        //set background
        if (color == Red) {
            self.image = [UIImage imageNamed:@"RedTitleBackground"];
        }else{
              self.image = [UIImage imageNamed:@"BlueTitleBackground"];
        }
        
        //add tittle
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 57, 30)];
        titleLabel.text = title;
        titleLabel.textAlignment = NSTextAlignmentCenter;
        titleLabel.textColor = [UIColor whiteColor];
        titleLabel.font = [UIFont systemFontOfSize:11];
        [self addSubview:titleLabel];
    }
    
    return self;
}

@end
