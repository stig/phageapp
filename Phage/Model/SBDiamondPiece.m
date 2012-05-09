//
//  SBDiamondPiece.m
//  Phage
//
//  Created by Stig Brautaset on 24/3/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "SBDiamondPiece.h"
#import "SBDirection.h"

@implementation SBDiamondPiece

- (NSArray *)directions {
    return [[NSArray alloc] initWithObjects:
            [[SBDirection alloc] initWithColumn:-1 row:0],
            [[SBDirection alloc] initWithColumn:1 row:0],
            [[SBDirection alloc] initWithColumn:0 row:-1],
            [[SBDirection alloc] initWithColumn:0 row:1],
            nil];
}

- (void)drawLayer:(CAShapeLayer *)layer inContext:(CGContextRef)ctx {
    [super drawLayer:layer inContext:ctx];

    CGRect r = CGRectInset(layer.bounds, 4.0, 4.0);
    CGFloat w2 = r.origin.x + r.size.width / 2.0;
    CGFloat h2 = r.origin.y + r.size.height / 2.0;

    CGMutablePathRef path = CGPathCreateMutable();
    CGPathMoveToPoint(path, nil, w2, r.origin.y);
    CGPathAddLineToPoint(path, nil, r.origin.x + r.size.width, h2);
    CGPathAddLineToPoint(path, nil, w2, r.origin.y + r.size.height);
    CGPathAddLineToPoint(path, nil, r.origin.x, h2);
    CGPathCloseSubpath(path);
    layer.path = path;
    CGPathRelease(path);
}


@end
