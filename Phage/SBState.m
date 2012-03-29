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
#import "SBLocation.h"
#import "SBDirection.h"
#import "SBMove.h"


@implementation SBState

@synthesize north;
@synthesize south;
@synthesize playerTurn;

- (id)init {
    self = [super init];
    if (self) {
        playerTurn = NORTH;

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
                [[SBLocation alloc] initWithColumn:1 row:4],
                [[SBLocation alloc] initWithColumn:3 row:5],
                [[SBLocation alloc] initWithColumn:5 row:6],
                [[SBLocation alloc] initWithColumn:7 row:7],
                [[SBLocation alloc] initWithColumn:6 row:3],
                [[SBLocation alloc] initWithColumn:4 row:2],
                [[SBLocation alloc] initWithColumn:2 row:1],
                [[SBLocation alloc] initWithColumn:0 row:0],
                nil];

        location = [[NSMutableDictionary alloc] initWithObjects:locations
                                                        forKeys:[north arrayByAddingObjectsFromArray:south]];
        
        grid = [[SBGrid alloc] init];
        for (id p in location) {
            [grid setPiece:p atLocation:[location objectForKey:p]];
        }

        movesLeft = [[NSMutableDictionary alloc] initWithCapacity:location.count];
        for (id p in [north arrayByAddingObjectsFromArray:south]) {
            [movesLeft setObject:[NSNumber numberWithUnsignedInt:7ul] forKey:p];
        }
    }
    return self;
}

- (BOOL)isEqual:(id)other {
    if (other == self)
        return YES;
    if (!other || ![other isKindOfClass:[self class]])
        return NO;
    return [self isEqualToState:other];
}

- (BOOL)isEqualToState:(SBState *)other {
    if (self == other)
        return YES;
    if (!playerTurn == other.playerTurn)
        return NO;
    return [grid isEqualToGrid:other->grid];
}

- (NSUInteger)hash {
    return 31u * [grid hash] + playerTurn;
}


- (NSString*)description {
    NSMutableString *desc = [[NSMutableString alloc] init];
    [desc appendFormat:@"PlayerTurn: %@\n", playerTurn == NORTH ? @"North" : @"South"];

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

- (SBLocation *)locationForPiece:(SBPiece *)piece {
    return [location objectForKey:piece];
}

- (NSArray *)currentPlayerPieces {
    return NORTH == playerTurn ? north : south;
}

- (NSArray *)legalMovesForPiece:(SBPiece *)piece {
    NSMutableArray *moves = [[NSMutableArray alloc] initWithCapacity:32];

    for (SBDirection *d in [piece directions]) {
        SBLocation *loc = [self locationForPiece:piece];
        for (;;) {
            loc = [loc locationByMovingInDirection:d];

            // If this is _not_ an unoccupied, legal grid location, we've either gone outside the board
            // or hit another piece, or a previously occupied slot.
            if (![grid isUnoccupiedGridLocation:loc])
                break;

            [moves addObject:[[SBMove alloc] initWithPiece:piece to:loc]];
        }
    }

    return moves;
}

- (NSArray *)legalMoves {
    NSMutableArray *moves = [[NSMutableArray alloc] initWithCapacity:64];

    for (SBPiece *p in [self currentPlayerPieces]) {
        [moves addObjectsFromArray:[self legalMovesForPiece:p]];
    }

    return moves;
}

@end
