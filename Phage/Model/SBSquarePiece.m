//
//  SBSquarePiece.m
//  Phage
//
//  Created by Stig Brautaset on 24/3/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "SBSquarePiece.h"
#import "SBDirection.h"

@implementation SBSquarePiece

- (NSArray *)directions {
    return [[NSArray alloc] initWithObjects:
            [[SBDirection alloc] initWithColumn:-1 row:-1],
            [[SBDirection alloc] initWithColumn:1 row:-1],
            [[SBDirection alloc] initWithColumn:-1 row:1],
            [[SBDirection alloc] initWithColumn:1 row:1],
            nil];
}

- (void)drawLayer:(CAShapeLayer *)layer inContext:(CGContextRef)ctx {
    [super drawLayer:layer inContext:ctx];

    CGMutablePathRef path = CGPathCreateMutable();
    CGPathAddRect(path, nil, CGRectInset(layer.bounds, 6.0, 6.0));
    layer.path = path;
    CGPathRelease(path);
}


@end
