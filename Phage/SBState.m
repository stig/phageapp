//
//  SBState.m
//  Phage
//
//  Created by Stig Brautaset on 25/3/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "SBState.h"
#import "SBGrid.h"
#import "SBCirclePiece.h"
#import "SBDiamondPiece.h"
#import "SBSquarePiece.h"
#import "SBTrianglePiece.h"
#import "SBLocation.h"
#import "SBDirection.h"
#import "SBMove.h"
#import "SBMinefieldPiece.h"


@implementation SBState

@synthesize north;
@synthesize south;
@synthesize playerTurn;

// Designated initializer
- (id)initWithPlayerTurn:(SBPlayer)turn_ location:(NSDictionary *)location_ grid:(SBGrid *)grid_ movesLeft:(NSDictionary *)movesLeft_ north:(NSArray *)north_ south:(NSArray *)south_ {
    self = [super init];
    if (self) {
        north = north_;
        south = south_;
        playerTurn = turn_;
        location = location_;
        grid = grid_;
        movesLeft = movesLeft_;
    }
    return self;
}

- (id)init {

    NSArray *theNorth = [[NSArray alloc] initWithObjects:[[SBCirclePiece alloc] initWithOwner:NORTH],
                                                         [[SBSquarePiece alloc] initWithOwner:NORTH],
                                                         [[SBTrianglePiece alloc] initWithOwner:NORTH],
                                                         [[SBDiamondPiece alloc] initWithOwner:NORTH],
                                                         nil];

    NSArray *theSouth = [[NSArray alloc] initWithObjects:[[SBCirclePiece alloc] initWithOwner:SOUTH],
                                                         [[SBSquarePiece alloc] initWithOwner:SOUTH],
                                                         [[SBTrianglePiece alloc] initWithOwner:SOUTH],
                                                         [[SBDiamondPiece alloc] initWithOwner:SOUTH],
                                                         nil];

    NSArray *locations = [[NSArray alloc] initWithObjects:[[SBLocation alloc] initWithColumn:1 row:4],
                                                          [[SBLocation alloc] initWithColumn:3 row:5],
                                                          [[SBLocation alloc] initWithColumn:5 row:6],
                                                          [[SBLocation alloc] initWithColumn:7 row:7],
                                                          [[SBLocation alloc] initWithColumn:6 row:3],
                                                          [[SBLocation alloc] initWithColumn:4 row:2],
                                                          [[SBLocation alloc] initWithColumn:2 row:1],
                                                          [[SBLocation alloc] initWithColumn:0 row:0],
                                                          nil];

    NSArray *pieces = [theNorth arrayByAddingObjectsFromArray:theSouth];

    NSDictionary *theLocations = [[NSDictionary alloc] initWithObjects:locations forKeys:pieces];

    SBGrid *theGrid = [[SBGrid alloc] init];
    for (id p in theLocations)
        [theGrid setPiece:p atLocation:[theLocations objectForKey:p]];

    NSMutableArray *moves = [[NSMutableArray alloc] initWithCapacity:8u];
    for (SBPiece *p in pieces)
        [moves addObject:[NSNumber numberWithUnsignedInteger:7u]];

    NSDictionary *theMovesLeft = [[NSDictionary alloc] initWithObjects:moves forKeys:pieces];

    return [self initWithPlayerTurn:NORTH
                           location:theLocations
                               grid:theGrid
                          movesLeft:theMovesLeft
                              north:theNorth
                              south:theSouth];
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

- (NSString *)description {
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
        for (; ;) {
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

- (SBState *)successorWithMove:(SBMove *)move {
    SBLocation *from = [location objectForKey:move.piece];

    NSMutableDictionary *newLocations = [location mutableCopy];
    [newLocations setObject:move.to forKey:move.piece];

    SBGrid *newGrid = [grid copy];
    [newGrid setPiece:[[SBMinefieldPiece alloc] init] atLocation:from];
    [newGrid setPiece:move.piece atLocation:move.to];

    NSMutableDictionary *newMovesLeft = [movesLeft mutableCopy];
    NSUInteger moves = [self movesLeftForPiece:move.piece];
    [newMovesLeft setObject:[NSNumber numberWithUnsignedInteger:moves - 1] forKey:move.piece];

    return [[[self class] alloc] initWithPlayerTurn:playerTurn == NORTH ? SOUTH : NORTH
                                           location:newLocations
                                               grid:newGrid
                                          movesLeft:newMovesLeft
                                              north:north
                                              south:south];
}

@end
