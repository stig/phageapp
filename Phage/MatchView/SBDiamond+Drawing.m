//
// Created by SuperPappi on 29/07/2012.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import "SBDiamond.h"

@implementation SBDiamond (Drawing)

- (CGPathRef)pathInRect:(CGRect)rect {
    static CGMutablePathRef path = nil;
    if (!path) {
        CGRect r = CGRectInset(rect, 4.0, 4.0);
        CGFloat w2 = r.origin.x + r.size.width / 2.0;
        CGFloat h2 = r.origin.y + r.size.height / 2.0;

        path = CGPathCreateMutable();
        CGPathMoveToPoint(path, nil, w2, r.origin.y);
        CGPathAddLineToPoint(path, nil, r.origin.x + r.size.width, h2);
        CGPathAddLineToPoint(path, nil, w2, r.origin.y + r.size.height);
        CGPathAddLineToPoint(path, nil, r.origin.x, h2);
        CGPathCloseSubpath(path);
    }
    return path;
}


@end