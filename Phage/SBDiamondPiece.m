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

- (void)drawLayer:(CALayer *)layer inContext:(CGContextRef)ctx {
    [super drawLayer:layer inContext:ctx];
    layer.bounds = CGRectInset(layer.bounds, 2.0, 2.0);
    layer.anchorPoint = CGPointMake(0.5f, 0.5f);
    layer.affineTransform = CGAffineTransformMakeRotation(M_PI / 4.0);
}


@end
