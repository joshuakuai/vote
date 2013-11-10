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
        [self setFrame:CGRectMake(115, 175, 90, 90)];
        self.backgroundColor = [UIColor blackColor];
        self.layer.cornerRadius = 8;
        [self setAlpha:0.6];
        
        activityIndicatorView = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(5, 10, 80, 80)];
        [activityIndicatorView setActivityIndicatorViewStyle:UIActivityIndicatorViewStyleWhiteLarge];
        [activityIndicatorView setBackgroundColor:[UIColor clearColor]];
        [self addSubview:activityIndicatorView];
        
        UILabel *tittleLabel = [[[UILabel alloc] initWithFrame:CGRectMake(0, 0, 90, 30)] autorelease];
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

-(void)dealloc
{
    [activityIndicatorView release];
    [super dealloc];
}

@end
