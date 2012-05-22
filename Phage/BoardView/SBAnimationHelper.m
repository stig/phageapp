//
// Created by SuperPappi on 22/05/2012.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import "SBAnimationHelper.h"

@implementation SBAnimationHelper


+ (void)addPulseAnimationToLayer:(CALayer *)layer {
    CABasicAnimation *theAnimation = [CABasicAnimation animationWithKeyPath:@"opacity"];
    theAnimation.duration = 1.0;
    theAnimation.repeatCount = HUGE_VALF;
    theAnimation.autoreverses = YES;
    theAnimation.fromValue = [NSNumber numberWithFloat:1.0];
    theAnimation.toValue = [NSNumber numberWithFloat:0.5];
    theAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    [layer addAnimation:theAnimation forKey:@"opacityAnimation"];
}

+ (void)removePulseAnimationFromLayer:(CALayer *)layer {
    [layer removeAnimationForKey:@"opacityAnimation"];
}

@end