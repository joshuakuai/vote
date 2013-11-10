//
//  ProccessView.h
//  CRT
//
//  Created by Karry on 12-10-19.
//
//

#import <UIKit/UIKit.h>

@interface ProccessView : UIView{
    UIActivityIndicatorView *activityIndicatorView;
}

-(id)init:(NSString*)tittle;
-(void)show;
-(void)stop;

@end
