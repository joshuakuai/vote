//
//  RedTitleView.h
//  vote
//
//  Created by kuaijianghua on 11/30/13.
//  Copyright (c) 2013 rampageworks. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum _TitleBackgroundColor{Red,Blue}TitleBackgroundColor;

@interface TitleView : UIImageView

- (id)initWithTittle:(NSString*)title color:(TitleBackgroundColor)color location:(CGPoint)location;

@end
