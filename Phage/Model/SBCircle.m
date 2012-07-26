//
//  SBCirclePiece.m
//  Phage
//
//  Created by Stig Brautaset on 24/3/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "SBCircle.h"
#import "SBDirection.h"

@implementation SBCircle

- (NSArray *)directions {
    return @[[SBDirection directionWithColumn:-1 row:-1],
            [SBDirection directionWithColumn:1 row:-1],
            [SBDirection directionWithColumn:-1 row:1],
            [SBDirection directionWithColumn:1 row:1],
            [SBDirection directionWithColumn:-1 row:0],
            [SBDirection directionWithColumn:1 row:0],
            [SBDirection directionWithColumn:0 row:-1],
            [SBDirection directionWithColumn:0 row:1]];
}

- (CGPathRef)pathInRect:(CGRect)rect {
    static CGPathRef path = nil;
    if (!path) path = CGPathCreateWithEllipseInRect(CGRectInset(rect, 5.0, 5.0), nil);
    return path;
}


@end
