//
// Created by SuperPappi on 29/07/2012.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import "SBTriangle.h"

@implementation SBTriangle (Drawing)

- (CGPathRef)createPathInRect:(CGRect)rect {
    CGRect r = CGRectInset(rect, 6.0, 6.0);
    CGFloat w2 = r.origin.x + r.size.width / 2.0;

    CGMutablePathRef path = CGPathCreateMutable();
    if (self.owner == 0) {
        CGPathMoveToPoint(path, nil, r.origin.x, r.size.height + r.origin.y);
        CGPathAddLineToPoint(path, nil, w2, r.origin.y);
        CGPathAddLineToPoint(path, nil, r.origin.x + r.size.width, r.size.height + r.origin.y);
    } else {
        CGPathMoveToPoint(path, nil, r.origin.x, r.origin.y);
        CGPathAddLineToPoint(path, nil, w2, r.size.height + r.origin.y);
        CGPathAddLineToPoint(path, nil, r.origin.x + r.size.width, r.origin.y);
    }
    CGPathCloseSubpath(path);

    return path;
}


- (CGPathRef)pathInRect:(CGRect)rect {
    if (self.owner) {
        static CGPathRef path = nil;
        if (!path) path = [self createPathInRect:rect];
        return path;
    } else {
        static CGPathRef path = nil;
        if (!path) path = [self createPathInRect:rect];
        return path;
    }
}

@end