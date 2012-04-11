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
@property (readonly) NSDictionary *locations;
@property (readonly) NSDictionary *moves;
@property (readonly) NSSet *occupied;
@end

@implementation SBState

@synthesize north = _north;
@synthesize south = _south;
@synthesize locations = _locations;
@synthesize moves = _moves;
@synthesize occupied = _occupied;

// Designated initializer
- (id)initWithNorth:(NSArray *)theNorth south:(NSArray *)theSouth locations:(NSDictionary *)theLocationMap movesLeft:(NSDictionary *)theMovesLeftMap occupied:(NSSet *)theOccupiedSet {
    self = [super init];
    if (self) {
        _north = theNorth;
        _south = theSouth;
        _locations = theLocationMap;
        _moves = theMovesLeftMap;
        _occupied = theOccupiedSet;
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

    NSMutableArray *theMoves = [[NSMutableArray alloc] initWithCapacity:8u];
    for (SBPiece *p in thePieces)
        [theMoves addObject:[NSNumber numberWithUnsignedInteger:7u]];

    NSDictionary *theMovesLeft = [[NSDictionary alloc] initWithObjects:theMoves forKeys:thePieces];

    NSSet *occupiedLocSet = [[NSSet alloc] initWithArray:theLocations];

    return [self initWithNorth:theNorth south:theSouth locations:theLocationMap movesLeft:theMovesLeft occupied:occupiedLocSet];
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

    return [_locations isEqualToDictionary:other.locations] &&
            [_moves isEqualToDictionary:other.moves] &&
            [_occupied isEqualToSet:other.occupied];
}

- (NSUInteger)hash {
    NSUInteger hash = [_locations hash];
    hash = hash * 31u + [_moves hash];
    hash = hash * 31u + [_occupied hash];
    return hash;
}

- (NSString *)description {
    NSMutableString *desc = [[NSMutableString alloc] initWithCapacity:GRIDSIZE * GRIDSIZE * 2u];

    for (id p in _north) {
        [desc appendFormat:@"%@: %@\n", p, [_moves objectForKey:p]];
    }

    NSMutableDictionary *map = [[NSMutableDictionary alloc] init];
    for (SBPiece *p in _locations) {
        SBLocation *loc = [_locations objectForKey:p];
        [map setObject:p forKey:loc];
    }

    for (int r = GRIDSIZE - 1; r >= 0; r--) {
        for (int c = 0; c < GRIDSIZE; c++) {
            SBLocation *loc = [[SBLocation alloc] initWithColumn:c row:r];

            SBPiece *p = [map objectForKey:loc];
            if (p) {
                [desc appendString:[p description]];
            } else if ([_occupied containsObject:loc]) {
                [desc appendString:@"*"];
            } else {
                [desc appendString:@"."];
            }
        }
        [desc appendString:@"\n"];
    }

    for (id p in _south) {
        [desc appendFormat:@"%@: %@\n", p, [_moves objectForKey:p]];
    }

    return desc;
}

- (NSUInteger)movesLeftForPiece:(SBPiece *)piece {
    return [[_moves objectForKey:piece] unsignedIntegerValue];
}

- (SBLocation *)locationForPiece:(SBPiece *)piece {
    return [_locations objectForKey:piece];
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
            if (![self isGridLocation:loc] || [_occupied containsObject:loc])
                break;

            [moves addObject:[[SBMove alloc] initWithPiece:piece to:loc]];
        }
    }

    return moves;
}

- (NSArray *)legalMovesForPlayer:(SBPlayer)player {
    NSMutableArray *moves = [[NSMutableArray alloc] initWithCapacity:64u];

    for (SBPiece *p in player == SBPlayerNorth ? _north : _south) {
        [moves addObjectsFromArray:[self legalMovesForPiece:p]];
    }

    return moves;
}

- (SBState *)successorWithMove:(SBMove *)move {
    NSSet *newOccupiedSet = [_occupied setByAddingObject:move.to];

    NSMutableDictionary *newLocations = [_locations mutableCopy];
    [newLocations setObject:move.to forKey:move.piece];

    NSMutableDictionary *newMovesLeft = [_moves mutableCopy];
    NSUInteger moves = [self movesLeftForPiece:move.piece];
    [newMovesLeft setObject:[NSNumber numberWithUnsignedInteger:moves - 1] forKey:move.piece];

    return [[[self class] alloc] initWithNorth:_north south:_south locations:[newLocations copy] movesLeft:[newMovesLeft copy] occupied:newOccupiedSet];
}

@end
