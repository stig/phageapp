//
//  SBCirclePiece.m
//  Phage
//
//  Created by Stig Brautaset on 24/3/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <CoreGraphics/CoreGraphics.h>
#import "SBCirclePiece.h"
#import "SBDirection.h"

@implementation SBCirclePiece

- (NSArray *)directions {
    return [[NSArray alloc] initWithObjects:
            [[SBDirection alloc] initWithColumn:-1 row:-1],
            [[SBDirection alloc] initWithColumn:1 row:-1],
            [[SBDirection alloc] initWithColumn:-1 row:1],
            [[SBDirection alloc] initWithColumn:1 row:1],
            [[SBDirection alloc] initWithColumn:-1 row:0],
            [[SBDirection alloc] initWithColumn:1 row:0],
            [[SBDirection alloc] initWithColumn:0 row:-1],
            [[SBDirection alloc] initWithColumn:0 row:1],
            nil];
}

- (void)drawLayer:(CALayer *)layer inContext:(CGContextRef)ctx {
    [super drawLayer:layer inContext:ctx];
    layer.cornerRadius = layer.bounds.size.height / 2.0;
}


@end
