//
// Created by SuperPappi on 29/07/2012.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import "SBSquare.h"

@implementation SBSquare (Drawing)

- (CGPathRef)pathInRect:(CGRect)rect {
    static CGPathRef path = nil;
    if (!path) path = CGPathCreateWithRect(CGRectInset(rect, 6.0, 6.0), nil);
    return path;
}

@end