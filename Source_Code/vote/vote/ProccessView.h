//
//  ProccessView.h
//  CRT
//
//  Created by Karry on 12-10-19.
//
//

#import <UIKit/UIKit.h>
#import "AMBlurView.h"

@interface ProccessView : AMBlurView{
    UIActivityIndicatorView *activityIndicatorView;
}

-(id)init:(NSString*)tittle;
-(void)show;
-(void)stop;

@end
