//
//  SBTrianglePiece.m
//  Phage
//
//  Created by Stig Brautaset on 24/3/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "SBTrianglePiece.h"
#import "SBDirection.h"

@implementation SBTrianglePiece

- (NSArray *)directions {
    return [[NSArray alloc] initWithObjects:
            [[SBDirection alloc] initWithColumn:1 row:0],
            [[SBDirection alloc] initWithColumn:-1 row:0],
            self.isPlayerOne == YES
                    ? [[SBDirection alloc] initWithColumn:0 row:-1]
                    : [[SBDirection alloc] initWithColumn:0 row:1],
            nil];
}

- (void)drawLayer:(CAShapeLayer *)layer inContext:(CGContextRef)ctx {
    [super drawLayer:layer inContext:ctx];

    CGRect r = CGRectInset(layer.bounds, 6.0, 6.0);
    CGFloat w2 = r.origin.x + r.size.width / 2.0;

    CGMutablePathRef path = CGPathCreateMutable();

    if (self.isPlayerOne) {
        CGPathMoveToPoint(path, nil, r.origin.x, r.size.height + r.origin.y);
        CGPathAddLineToPoint(path, nil, w2, r.origin.y);
        CGPathAddLineToPoint(path, nil, r.origin.x + r.size.width, r.size.height + r.origin.y);
    } else {
        CGPathMoveToPoint(path, nil, r.origin.x, r.origin.y);
        CGPathAddLineToPoint(path, nil, w2, r.size.height + r.origin.y);
        CGPathAddLineToPoint(path, nil, r.origin.x + r.size.width, r.origin.y);
    }
    CGPathCloseSubpath(path);

    layer.path = path;

    CGPathRelease(path);
}


@end
