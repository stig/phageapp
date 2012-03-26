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

@synthesize north;
@synthesize south;

- (id)init {
    self = [super init];
    if (self) {
        north = [[NSArray alloc] initWithObjects:
                 [[SBCirclePiece alloc] initWithOwner:NORTH],
                 [[SBSquarePiece alloc] initWithOwner:NORTH],
                 [[SBTrianglePiece alloc] initWithOwner:NORTH],
                 [[SBDiamondPiece alloc] initWithOwner:NORTH],
                 nil];
        
        south = [[NSArray alloc] initWithObjects:
                 [[SBCirclePiece alloc] initWithOwner:SOUTH],
                 [[SBSquarePiece alloc] initWithOwner:SOUTH],
                 [[SBTrianglePiece alloc] initWithOwner:SOUTH],
                 [[SBDiamondPiece alloc] initWithOwner:SOUTH],
                 nil];

        NSArray *locations = [[NSArray alloc] initWithObjects:
                [[SBPoint alloc] initWithColumn:1 row:4],
                [[SBPoint alloc] initWithColumn:3 row:5],
                [[SBPoint alloc] initWithColumn:5 row:6],
                [[SBPoint alloc] initWithColumn:7 row:7],
                [[SBPoint alloc] initWithColumn:6 row:3],
                [[SBPoint alloc] initWithColumn:4 row:2],
                [[SBPoint alloc] initWithColumn:2 row:1],
                [[SBPoint alloc] initWithColumn:0 row:0],
                nil];

        location = [[NSMutableDictionary alloc] initWithObjects:locations
                                                        forKeys:[north arrayByAddingObjectsFromArray:south]];
        
        grid = [[SBGrid alloc] init];
        for (id p in location) {
            [grid setPiece:p atPoint:[location objectForKey:p]];
        }

        movesLeft = [[NSMutableDictionary alloc] initWithCapacity:location.count];
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

- (NSUInteger)movesLeftForPiece:(SBPiece *)piece {
    return [[movesLeft objectForKey:piece] unsignedIntegerValue];
}

@end
