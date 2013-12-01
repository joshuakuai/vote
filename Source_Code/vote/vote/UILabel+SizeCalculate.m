//
//  UILabel+SizeCalculate.m
//  vote
//
//  Created by kuaijianghua on 11/30/13.
//  Copyright (c) 2013 rampageworks. All rights reserved.
//

#import "UILabel+SizeCalculate.h"

@implementation UILabel (SizeCalculate)

- (CGSize)perfectLabelSizeWithMaxSize:(CGSize)maxSize;
{
    //Calculate the expected size based on the font and linebreak mode of the label
    CGSize expectedLabelSize = [self.text sizeWithFont:self.font
                                constrainedToSize:maxSize
                                    lineBreakMode:self.lineBreakMode];

    return expectedLabelSize;
}

@end
