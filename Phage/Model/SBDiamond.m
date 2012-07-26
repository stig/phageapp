//
//  SBDiamondPiece.m
//  Phage
//
//  Created by Stig Brautaset on 24/3/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "SBDiamond.h"
#import "SBDirection.h"

@implementation SBDiamond

- (NSArray *)directions {
    return @[[SBDirection directionWithColumn:-1 row:0],
            [SBDirection directionWithColumn:1 row:0],
            [SBDirection directionWithColumn:0 row:-1],
            [SBDirection directionWithColumn:0 row:1]];
}

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
