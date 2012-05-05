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

@interface SBState ()
@property (readonly) NSDictionary *pieceLocations;
@property (readonly) NSDictionary *movesLeft;
@property (readonly) NSSet *occupied;
@end

@implementation SBState

@synthesize isPlayerOne = _isPlayerOne;
@synthesize playerOnePieces = _playerOnePieces;
@synthesize playerTwoPieces = _playerTwoPieces;
@synthesize pieceLocations = _pieceLocations;
@synthesize movesLeft = _movesLeft;
@synthesize occupied = _occupied;

// Designated initializer
- (id)initWithPlayerOneTurn:(BOOL)thePlayer playerOnePieces:(NSArray *)theNorth playerTwoPieces:(NSArray *)theSouth locations:(NSDictionary *)theLocationMap movesLeft:(NSDictionary *)theMovesLeftMap occupied:(NSSet *)theOccupiedSet {
    self = [super init];
    if (self) {
        _isPlayerOne = thePlayer;
        _playerOnePieces = theNorth;
        _playerTwoPieces = theSouth;
        _pieceLocations = theLocationMap;
        _movesLeft = theMovesLeftMap;
        _occupied = theOccupiedSet;
    }
    return self;
}

- (id)initWithPlayer:(BOOL)thePlayer
{

    NSArray *theNorth = [[NSArray alloc] initWithObjects:[[SBCirclePiece alloc] initWithPlayerOne:YES],
                                                         [[SBSquarePiece alloc] initWithPlayerOne:YES],
                                                         [[SBTrianglePiece alloc] initWithPlayerOne:YES],
                                                         [[SBDiamondPiece alloc] initWithPlayerOne:YES],
                                                         nil];

    NSArray *theSouth = [[NSArray alloc] initWithObjects:[[SBCirclePiece alloc] initWithPlayerOne:NO],
                                                         [[SBSquarePiece alloc] initWithPlayerOne:NO],
                                                         [[SBTrianglePiece alloc] initWithPlayerOne:NO],
                                                         [[SBDiamondPiece alloc] initWithPlayerOne:NO],
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

    return [self initWithPlayerOneTurn:thePlayer playerOnePieces:theNorth playerTwoPieces:theSouth locations:theLocationMap movesLeft:theMovesLeft occupied:occupiedLocSet];
}

- (id)init {
    return [self initWithPlayer:YES];
}

#pragma mark NSCoding

- (void)encodeWithCoder:(NSCoder *)coder {
    [coder encodeBool:_isPlayerOne forKey:@"SBPlayerOne"];
    [coder encodeObject:_playerOnePieces forKey:@"SBNorth"];
    [coder encodeObject:_playerTwoPieces forKey:@"SBSouth"];
    [coder encodeObject:_pieceLocations forKey:@"SBLocations"];
    [coder encodeObject:_movesLeft forKey:@"SBMoves"];
    [coder encodeObject:_occupied forKey:@"SBOccupied"];
}

- (id)initWithCoder:(NSCoder *)coder {
    return [self initWithPlayerOneTurn:[coder decodeBoolForKey:@"SBPlayerOne"]
                       playerOnePieces:[coder decodeObjectForKey:@"SBNorth"]
                       playerTwoPieces:[coder decodeObjectForKey:@"SBSouth"]
                             locations:[coder decodeObjectForKey:@"SBLocations"]
                             movesLeft:[coder decodeObjectForKey:@"SBMoves"]
                              occupied:[coder decodeObjectForKey:@"SBOccupied"]];
}

#pragma mark Hashable

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

    return [_pieceLocations isEqualToDictionary:other.pieceLocations] &&
            _isPlayerOne == other.isPlayerOne &&
            [_movesLeft isEqualToDictionary:other.movesLeft] &&
            [_occupied isEqualToSet:other.occupied];
}

- (NSUInteger)hash {
    NSUInteger hash = [_pieceLocations hash];
    hash = hash * 31u + _isPlayerOne;
    hash = hash * 31u + [_movesLeft hash];
    hash = hash * 31u + [_occupied hash];
    return hash;
}

#pragma mark description

- (NSString *)description {
    NSMutableString *desc = [[NSMutableString alloc] initWithCapacity:self.rows * self.columns * 2u];

    for (id p in _playerOnePieces) {
        [desc appendFormat:@"%@: %@\n", p, [_movesLeft objectForKey:p]];
    }

    NSMutableDictionary *map = [[NSMutableDictionary alloc] init];
    for (SBPiece *p in _pieceLocations) {
        SBLocation *loc = [_pieceLocations objectForKey:p];
        [map setObject:p forKey:loc];
    }

    for (int r = self.rows - 1; r >= 0; r--) {
        for (int c = 0; c < self.columns; c++) {
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

    for (id p in _playerTwoPieces) {
        [desc appendFormat:@"%@: %@\n", p, [_movesLeft objectForKey:p]];
    }

    return desc;
}

#pragma mark model methods

- (NSUInteger)movesLeftForPiece:(SBPiece *)piece {
    return [[_movesLeft objectForKey:piece] unsignedIntegerValue];
}

- (SBLocation *)locationForPiece:(SBPiece *)piece {
    return [_pieceLocations objectForKey:piece];
}

- (BOOL)isGridLocation:(SBLocation*)loc {
    return loc.column >= 0 && loc.column < self.columns && loc.row >= 0 && loc.row < self.rows;
}

// TODO: this should not return true for locations which has a piece currently
- (BOOL)isPreviouslyOccupied:(SBLocation *)loc {
    return [_occupied containsObject:loc];
}

- (NSArray *)moveLocationsForPiece:(SBPiece *)piece {
    if (![[_movesLeft objectForKey:piece] unsignedIntegerValue])
        return [[NSArray alloc] init];

    NSMutableArray *locations = [[NSMutableArray alloc] initWithCapacity:32];
    for (SBDirection *d in [piece directions]) {
        SBLocation *loc = [self locationForPiece:piece];
        for (; ;) {
            loc = [loc locationByMovingInDirection:d];

            // Is the location not on the grid? Or already occupied?
            if (![self isGridLocation:loc] || [self isPreviouslyOccupied:loc])
                break;

            [locations addObject:loc];
        }
    }
    return locations;
}

- (NSArray *)legalMovesForPiece:(SBPiece *)piece {
    NSArray *locations = [self moveLocationsForPiece:piece];
    NSMutableArray *moves = [[NSMutableArray alloc] initWithCapacity:locations.count];
    for (SBLocation *loc in locations)
        [moves addObject:[[SBMove alloc] initWithPiece:piece to:loc]];
    return moves;
}

- (NSArray *)piecesForPlayer:(BOOL)player {
    return player ? _playerOnePieces : _playerTwoPieces;
}

- (NSArray *)legalMoves {
    NSMutableArray *moves = [[NSMutableArray alloc] initWithCapacity:64u];
    for (SBPiece *p in [self piecesForPlayer:_isPlayerOne])
        [moves addObjectsFromArray:[self legalMovesForPiece:p]];
    return moves;
}

- (BOOL)opponent {
    return !_isPlayerOne;
}

- (SBState *)successorWithMove:(SBMove *)move {
    NSSet *newOccupiedSet = [_occupied setByAddingObject:move.to];

    NSMutableDictionary *newLocations = [_pieceLocations mutableCopy];
    [newLocations setObject:move.to forKey:move.piece];

    NSMutableDictionary *newMovesLeft = [_movesLeft mutableCopy];
    NSUInteger moves = [self movesLeftForPiece:move.piece];
    [newMovesLeft setObject:[NSNumber numberWithUnsignedInteger:moves - 1] forKey:move.piece];

    return [[[self class] alloc] initWithPlayerOneTurn:self.opponent playerOnePieces:_playerOnePieces playerTwoPieces:_playerTwoPieces locations:[newLocations copy] movesLeft:[newMovesLeft copy] occupied:newOccupiedSet];
}

- (BOOL)isGameOver {
    return [self legalMoves].count == 0u;
}

- (NSInteger)result
{
    NSUInteger playerMoveCount = 0;
    for (SBPiece *p in [self piecesForPlayer:_isPlayerOne])
        playerMoveCount += [[_movesLeft objectForKey:p] unsignedIntegerValue];
    
    NSUInteger opponentMoveCount = 0;
    for (SBPiece *p in [self piecesForPlayer:self.opponent])
        opponentMoveCount += [[_movesLeft objectForKey:p] unsignedIntegerValue];

    // Number of moves _left_ should be less for the winning player
    return opponentMoveCount - playerMoveCount;
}

- (BOOL)isWin {
    return [self result] > 0;
}

- (BOOL)isDraw {
    return 0 == [self result];
}

- (void)enumerateLocationsUsingBlock:(void (^)(SBLocation*location))block
{
    for (NSUInteger r = 0; r < self.rows; r++) {
        for (NSUInteger c = 0; c < self.columns; c++) {
            block([[SBLocation alloc] initWithColumn:c row:r]);
        }
    }
}

- (NSUInteger)columns {
    return 8u;
}

- (NSUInteger)rows {
    return 8u;
}

@end