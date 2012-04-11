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

// Designated initializer
- (id)initWithNorth:(NSArray *)theNorth south:(NSArray *)theSouth grid:(SBGrid *)theGrid locationMap:(NSDictionary *)theLocationMap movesLeftMap:(NSDictionary *)theMovesLeftMap {
    self = [super init];
    if (self) {
        north = theNorth;
        south = theSouth;
        locationMap = theLocationMap;
        grid = theGrid;
        movesLeftMap = theMovesLeftMap;
    }
    return self;
}

- (id)init {

    NSArray *theNorth = [[NSArray alloc] initWithObjects:[[SBCirclePiece alloc] initWithPlayer:SBPlayerNorth],
                                                         [[SBSquarePiece alloc] initWithPlayer:SBPlayerNorth],
                                                         [[SBTrianglePiece alloc] initWithPlayer:SBPlayerNorth],
                                                         [[SBDiamondPiece alloc] initWithPlayer:SBPlayerNorth],
                                                         nil];

    NSArray *theSouth = [[NSArray alloc] initWithObjects:[[SBCirclePiece alloc] initWithPlayer:SBPlayerSouth],
                                                         [[SBSquarePiece alloc] initWithPlayer:SBPlayerSouth],
                                                         [[SBTrianglePiece alloc] initWithPlayer:SBPlayerSouth],
                                                         [[SBDiamondPiece alloc] initWithPlayer:SBPlayerSouth],
                                                         nil];

    NSArray *theLocations = [[NSArray alloc] initWithObjects:[[SBLocation alloc] initWithColumn:1 row:4],
                                                          [[SBLocation alloc] initWithColumn:3 row:5],
                                                          [[SBLocation alloc] initWithColumn:5 row:6],
                                                          [[SBLocation alloc] initWithColumn:7 row:7],
                                                          [[SBLocation alloc] initWithColumn:6 row:3],
                                                          [[SBLocation alloc] initWithColumn:4 row:2],
                                                          [[SBLocation alloc] initWithColumn:2 row:1],
                                                          [[SBLocation alloc] initWithColumn:0 row:0],
                                                          nil];

    NSArray *thePieces = [theNorth arrayByAddingObjectsFromArray:theSouth];

    NSDictionary *theLocationMap = [[NSDictionary alloc] initWithObjects:theLocations forKeys:thePieces];

    SBGrid *theGrid = [[SBGrid alloc] init];
    for (id p in theLocationMap)
        [theGrid setPiece:p atLocation:[theLocationMap objectForKey:p]];

    NSMutableArray *moves = [[NSMutableArray alloc] initWithCapacity:8u];
    for (SBPiece *p in thePieces)
        [moves addObject:[NSNumber numberWithUnsignedInteger:7u]];

    NSDictionary *theMovesLeft = [[NSDictionary alloc] initWithObjects:moves forKeys:thePieces];

    return [self initWithNorth:theNorth south:theSouth grid:theGrid locationMap:theLocationMap movesLeftMap:theMovesLeft];
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
    return [grid isEqualToGrid:other->grid];
}

- (NSUInteger)hash {
    return [grid hash];
}

- (NSString *)description {
    NSMutableString *desc = [[NSMutableString alloc] init];

    for (id p in north) {
        [desc appendFormat:@"%@: %@\n", p, [movesLeftMap objectForKey:p]];
    }

    [desc appendString:[grid description]];

    for (id p in south) {
        [desc appendFormat:@"%@: %@\n", p, [movesLeftMap objectForKey:p]];
    }

    return desc;
}

- (NSUInteger)movesLeftForPiece:(SBPiece *)piece {
    return [[movesLeftMap objectForKey:piece] unsignedIntegerValue];
}

- (SBLocation *)locationForPiece:(SBPiece *)piece {
    return [locationMap objectForKey:piece];
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

- (NSArray *)legalMovesForPlayer:(SBPlayer)player {
    NSMutableArray *moves = [[NSMutableArray alloc] initWithCapacity:64];

    for (SBPiece *p in player == SBPlayerNorth ? north : south) {
        [moves addObjectsFromArray:[self legalMovesForPiece:p]];
    }

    return moves;
}

- (SBState *)successorWithMove:(SBMove *)move {
    SBLocation *from = [locationMap objectForKey:move.piece];

    NSMutableDictionary *newLocations = [locationMap mutableCopy];
    [newLocations setObject:move.to forKey:move.piece];

    SBGrid *newGrid = [grid copy];
    [newGrid setPiece:[[SBMinefieldPiece alloc] init] atLocation:from];
    [newGrid setPiece:move.piece atLocation:move.to];

    NSMutableDictionary *newMovesLeft = [movesLeftMap mutableCopy];
    NSUInteger moves = [self movesLeftForPiece:move.piece];
    [newMovesLeft setObject:[NSNumber numberWithUnsignedInteger:moves - 1] forKey:move.piece];

    return [[[self class] alloc] initWithNorth:north south:south grid:newGrid locationMap:newLocations movesLeftMap:newMovesLeft];
}

@end
