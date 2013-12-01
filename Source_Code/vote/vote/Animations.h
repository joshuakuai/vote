//
//  Animations.h
//
//  Created by Pulkit Kathuria on 10/8/12.
//  Copyright (c) 2012 Pulkit Kathuria. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

@interface Animations : UIViewController{
}


+ (void) moveRight: (UIView *)view andAnimationDuration: (float) duration andWait:(BOOL) wait andLength:(float) length;

+ (void) moveUp: (UIView *)view andAnimationDuration: (float) duration andWait:(BOOL) wait andLength:(float) length;
+ (void) moveDown: (UIView *)view andAnimationDuration: (float) duration andWait:(BOOL) wait andLength:(float) length;

+ (void) doubleMoveDown: (UIView *)view anotherView: (UIView *)anotherView andAnimationDuration: (float) duration andWait:(BOOL) wait andLength:(float) length;

+ (void) doubleMoveUp: (UIView *)view anotherView: (UIView *)anotherView andAnimationDuration: (float) duration andWait:(BOOL) wait andLength:(float) length;
@end
