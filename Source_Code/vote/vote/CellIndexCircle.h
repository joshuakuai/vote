//
//  CellIndexCircle.h
//  vote
//
//  Created by kuaijianghua on 11/30/13.
//  Copyright (c) 2013 rampageworks. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CellIndexCircle : UIImageView

@property (nonatomic,strong) UILabel *indexLabel;

//default as gray circle and black
- (id)initWithNumber:(int)number location:(CGPoint)location;
- (void)setNumber:(int)number;
- (void)setCircleColorWhile;

@end
