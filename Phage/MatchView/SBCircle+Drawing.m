//
// Created by SuperPappi on 29/07/2012.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import "SBCircle.h"

@implementation SBCircle (Drawing)

- (CGPathRef)pathInRect:(CGRect)rect {
    static CGPathRef path = nil;
    if (!path) path = CGPathCreateWithEllipseInRect(CGRectInset(rect, 5.0, 5.0), nil);
    return path;
}

@end