//
//  SBState.m
//  Phage
//
//  Created by Stig Brautaset on 25/3/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "SBState.h"
#import "SBCirclePiece.h"
#import "SBDiamondPiece.h"
#import "SBSquarePiece.h"
#import "SBTrianglePiece.h"
#import "SBLocation.h"
#import "SBDirection.h"
#import "SBMove.h"

#define GRIDSIZE 8

@interface SBState ()
@property (readonly) NSDictionary *locationMap;
@property (readonly) NSDictionary *movesLeftMap;
@property (readonly) NSSet *occupiedSet;
@end

@implementation SBState

@synthesize north;
@synthesize south;
@synthesize locationMap;
@synthesize movesLeftMap;
@synthesize occupiedSet;

// Designated initializer
- (id)initWithNorth:(NSArray *)theNorth south:(NSArray *)theSouth locationMap:(NSDictionary *)theLocationMap movesLeftMap:(NSDictionary *)theMovesLeftMap occupiedSet:(NSSet *)theOccupiedSet {
    self = [super init];
    if (self) {
        north = theNorth;
        south = theSouth;
        locationMap = theLocationMap;
        movesLeftMap = theMovesLeftMap;
        occupiedSet = theOccupiedSet;
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

    NSMutableArray *moves = [[NSMutableArray alloc] initWithCapacity:8u];
    for (SBPiece *p in thePieces)
        [moves addObject:[NSNumber numberWithUnsignedInteger:7u]];

    NSDictionary *theMovesLeft = [[NSDictionary alloc] initWithObjects:moves forKeys:thePieces];

    NSSet *occupiedLocSet = [[NSSet alloc] initWithArray:theLocations];

    return [self initWithNorth:theNorth south:theSouth locationMap:theLocationMap movesLeftMap:theMovesLeft occupiedSet:occupiedLocSet];
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

    return [locationMap isEqualToDictionary:other.locationMap] &&
            [movesLeftMap isEqualToDictionary:other.movesLeftMap] &&
            [occupiedSet isEqualToSet:other.occupiedSet];
}

- (NSUInteger)hash {
    NSUInteger hash = [locationMap hash];
    hash = hash * 31u + [movesLeftMap hash];
    hash = hash * 31u + [occupiedSet hash];
    return hash;
}

- (NSString *)description {
    NSMutableString *desc = [[NSMutableString alloc] initWithCapacity:GRIDSIZE * GRIDSIZE * 2u];

    for (id p in north) {
        [desc appendFormat:@"%@: %@\n", p, [movesLeftMap objectForKey:p]];
    }

    NSMutableDictionary *map = [[NSMutableDictionary alloc] init];
    for (SBPiece *p in locationMap) {
        SBLocation *loc = [locationMap objectForKey:p];
        [map setObject:p forKey:loc];
    }

    for (int r = GRIDSIZE - 1; r >= 0; r--) {
        for (int c = 0; c < GRIDSIZE; c++) {
            SBLocation *loc = [[SBLocation alloc] initWithColumn:c row:r];

            SBPiece *p = [map objectForKey:loc];
            if (p) {
                [desc appendString:[p description]];
            } else if ([occupiedSet containsObject:loc]) {
                [desc appendString:@"*"];
            } else {
                [desc appendString:@"."];
            }
        }
        [desc appendString:@"\n"];
    }

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

- (BOOL)isGridLocation:(SBLocation*)loc {
    return loc.column >= 0 && loc.column < GRIDSIZE && loc.row >= 0 && loc.row < GRIDSIZE;
}

- (NSArray *)legalMovesForPiece:(SBPiece *)piece {
    NSMutableArray *moves = [[NSMutableArray alloc] initWithCapacity:32];

    for (SBDirection *d in [piece directions]) {
        SBLocation *loc = [self locationForPiece:piece];
        for (; ;) {
            loc = [loc locationByMovingInDirection:d];

            // Is the location not on the grid? Or already occupied?
            if (![self isGridLocation:loc] || [occupiedSet containsObject:loc])
                break;

            [moves addObject:[[SBMove alloc] initWithPiece:piece to:loc]];
        }
    }

    return moves;
}

- (NSArray *)legalMovesForPlayer:(SBPlayer)player {
    NSMutableArray *moves = [[NSMutableArray alloc] initWithCapacity:64u];

    for (SBPiece *p in player == SBPlayerNorth ? north : south) {
        [moves addObjectsFromArray:[self legalMovesForPiece:p]];
    }

    return moves;
}

- (SBState *)successorWithMove:(SBMove *)move {
    NSSet *newOccupiedSet = [occupiedSet setByAddingObject:move.to];

    NSMutableDictionary *newLocations = [locationMap mutableCopy];
    [newLocations setObject:move.to forKey:move.piece];

    NSMutableDictionary *newMovesLeft = [movesLeftMap mutableCopy];
    NSUInteger moves = [self movesLeftForPiece:move.piece];
    [newMovesLeft setObject:[NSNumber numberWithUnsignedInteger:moves - 1] forKey:move.piece];

    return [[[self class] alloc] initWithNorth:north south:south locationMap:[newLocations copy] movesLeftMap:[newMovesLeft copy] occupiedSet:newOccupiedSet];
}

@end
