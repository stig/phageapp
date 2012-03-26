//
//  SBCirclePiece.m
//  Phage
//
//  Created by Stig Brautaset on 24/3/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

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


@end
