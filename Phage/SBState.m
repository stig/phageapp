//
//  SBState.m
//  Phage
//
//  Created by Stig Brautaset on 25/3/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "SBState.h"
#import "SBGrid.h"
#import "SBPiece.h"
#import "SBCirclePiece.h"
#import "SBDiamondPiece.h"
#import "SBSquarePiece.h"
#import "SBTrianglePiece.h"
#import "SBPoint.h"


@implementation SBState


- (id)init {
    self = [super init];
    if (self) {
        SBCirclePiece *const nc = [[SBCirclePiece alloc] initWithOwner:NORTH];
        SBSquarePiece *const ns = [[SBSquarePiece alloc] initWithOwner:NORTH];
        SBTrianglePiece *const nt = [[SBTrianglePiece alloc] initWithOwner:NORTH];
        SBDiamondPiece *const nd = [[SBDiamondPiece alloc] initWithOwner:NORTH];

        SBCirclePiece *const sc = [[SBCirclePiece alloc] initWithOwner:SOUTH];
        SBSquarePiece *const ss = [[SBSquarePiece alloc] initWithOwner:SOUTH];
        SBTrianglePiece *const st = [[SBTrianglePiece alloc] initWithOwner:SOUTH];
        SBDiamondPiece *const sd = [[SBDiamondPiece alloc] initWithOwner:SOUTH];

        grid = [[SBGrid alloc] init];
        
        [grid setPiece:nc atColumn:1 row:4];
        [grid setPiece:ns atColumn:3 row:5];
        [grid setPiece:nt atColumn:5 row:6];
        [grid setPiece:nd atColumn:7 row:7];

        [grid setPiece:sc atColumn:6 row:3];
        [grid setPiece:ss atColumn:4 row:2];
        [grid setPiece:st atColumn:2 row:1];
        [grid setPiece:sd atColumn:0 row:0];

        north = [[NSArray alloc] initWithObjects:nc, ns, nt, nd, nil];
        south = [[NSArray alloc] initWithObjects:sc, ss, st, sd, nil];

        movesLeft = [[NSMutableDictionary alloc] init];
        for (id p in [north arrayByAddingObjectsFromArray:south]) {
            [movesLeft setObject:[NSNumber numberWithUnsignedInt:7ul] forKey:p];
        }
    }
    return self;
}

- (NSString*)description {
    NSMutableString *desc = [[NSMutableString alloc] init];

    for (id p in north) {
        [desc appendFormat:@"%@: %@\n", p, [movesLeft objectForKey:p]];
    }

    [desc appendString:[grid description]];

    for (id p in south) {
        [desc appendFormat:@"%@: %@\n", p, [movesLeft objectForKey:p]];
    }

    return desc;
}


@end
