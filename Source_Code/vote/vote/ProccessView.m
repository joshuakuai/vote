//
//  ProccessView.m
//  CRT
//
//  Created by Karry on 12-10-19.
//
//

#import "ProccessView.h"
#import <QuartzCore/QuartzCore.h>

@implementation ProccessView

-(id)init:(NSString*)tittle
{
    self = [super init];
    if (self) {
        [self setFrame:CGRectMake(100, (ScreenHeigh-120)/2, 120, 120)];
        self.layer.cornerRadius = 8;
        [self setBlurTintColor:nil];
        
        activityIndicatorView = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(20, 10, 80, 80)];
        [activityIndicatorView setActivityIndicatorViewStyle:UIActivityIndicatorViewStyleGray];
        [activityIndicatorView setBackgroundColor:[UIColor clearColor]];
        [self addSubview:activityIndicatorView];
        
        UILabel *tittleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 90, 120, 30)];
        tittleLabel.textAlignment = NSTextAlignmentCenter;
        tittleLabel.text = tittle;
        tittleLabel.textColor = [UIColor whiteColor];
        tittleLabel.backgroundColor = [UIColor clearColor];
        [self addSubview:tittleLabel];
    }
    return self;
}

-(void)show
{
    UIWindow* mainWindow = [[UIApplication sharedApplication] keyWindow];
    [mainWindow addSubview: self];
    [activityIndicatorView startAnimating];
}

-(void)stop
{
    if (self.superview) {
        [self removeFromSuperview];
        [activityIndicatorView stopAnimating];
    }
}


@end
