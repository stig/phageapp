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
    return [NSArray arrayWithObjects:
            [SBDirection directionWithColumn:-1 row:-1],
            [SBDirection directionWithColumn:1 row:-1],
            [SBDirection directionWithColumn:-1 row:1],
            [SBDirection directionWithColumn:1 row:1],
            nil];
}

- (CGPathRef)pathInRect:(CGRect)rect {
    static CGPathRef path = nil;
    if (!path) path = CGPathCreateWithRect(CGRectInset(rect, 6.0, 6.0), nil);
    return path;
}


@end
