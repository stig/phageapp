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

@implementation SBState {

@private
    BOOL _isPlayerOne;
    NSSet *_occupied;
    NSDictionary *_movesLeft;
    NSDictionary *_pieceLocations;

    NSMutableDictionary *_isLegalMove;
}

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

    NSSet *occupiedLocSet = [[NSSet alloc] init];

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
    // This hackery is necessary because we used to write the current locations of pieces to GameCenter.
    // TODO remove this hackery when all games have been upgraded to not require it
    NSDictionary *locations = [coder decodeObjectForKey:@"SBLocations"];
    NSSet *pieceLocations = [[NSSet alloc] initWithArray:locations.allValues];

    NSSet *occupied = [coder decodeObjectForKey:@"SBOccupied"];
    occupied = [occupied objectsPassingTest:^(id obj, BOOL *stop) {
        return (BOOL)![pieceLocations containsObject:obj];
    }];

    return [self initWithPlayerOneTurn:[coder decodeBoolForKey:@"SBPlayerOne"]
                       playerOnePieces:[coder decodeObjectForKey:@"SBNorth"]
                       playerTwoPieces:[coder decodeObjectForKey:@"SBSouth"]
                             locations:locations
                             movesLeft:[coder decodeObjectForKey:@"SBMoves"]
                              occupied:occupied];
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

- (BOOL)wasLocationOccupied:(SBLocation *)loc {
    return [_occupied containsObject:loc];
}

- (BOOL)isLocationOccupied:(SBLocation*)loc {
    return nil != [self pieceForLocation:loc];
}

- (SBPiece *)pieceForLocation:(SBLocation *)loc {
    return [[_pieceLocations keysOfEntriesPassingTest:^(id key, id val, BOOL *stop) {
        if ([loc isEqualToLocation:val]) {
            *stop = YES;
            return YES;
        }
        return NO;
    }] anyObject];
}

- (NSString *)description {
    NSMutableString *desc = [[NSMutableString alloc] initWithCapacity:self.rows * self.columns * 2u];

    for (id p in _playerOnePieces) {
        [desc appendFormat:@"%@: %@\n", p, [_movesLeft objectForKey:p]];
    }

    for (int r = self.rows - 1; r >= 0; r--) {
        for (int c = 0; c < self.columns; c++) {
            SBLocation *loc = [[SBLocation alloc] initWithColumn:c row:r];

            SBPiece *p = [self pieceForLocation:loc];
            if (p) {
                [desc appendString:[p description]];
            } else if ([self wasLocationOccupied:loc]) {
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

- (void)enumerateLegalDestinationsForPiece:(SBPiece *)piece withBlock:(void (^)(SBLocation *loc, BOOL *stop))block {
    if (![self movesLeftForPiece:piece])
        return;

    for (SBDirection *d in piece.directions) {
        SBLocation *loc = [self locationForPiece:piece];
        for (;;) {
            loc = [loc locationByMovingInDirection:d];

            // Is the location not on the grid?
            if (![self isGridLocation:loc])
                break;

            // Or was already occupied?
            if ([self wasLocationOccupied:loc])
                break;

            // Or perchance is _still_ occupied?
            if ([self isLocationOccupied:loc])
                break;

            BOOL stop = NO;
            block(loc, &stop);
            if (stop) return;
        }
    }

}

- (void)enumerateLegalMovesForPlayerOne:(BOOL)one withBlock:(void(^)(SBMove *move, BOOL *stop))block {
    for (SBPiece *piece in [self piecesForPlayer:one]) {
        [self enumerateLegalDestinationsForPiece:piece
                                       withBlock:^(SBLocation *loc, BOOL *stop) {
                                           block([[SBMove alloc] initWithPiece:piece to:loc], stop);
                                       }];
    }
}

- (void)enumerateLegalMovesWithBlock:(void(^)(SBMove *move, BOOL *stop))block {
    [self enumerateLegalMovesForPlayerOne:self.isPlayerOne withBlock:block];
}

- (NSArray *)piecesForPlayer:(BOOL)player {
    return player ? _playerOnePieces : _playerTwoPieces;
}

- (BOOL)isLegalMove:(SBMove*)aMove {
    if (!_isLegalMove) {
        _isLegalMove = [NSMutableDictionary dictionary];
        [self enumerateLegalMovesWithBlock:^(SBMove *move, BOOL *stop) {
            NSMutableSet *dst = [_isLegalMove objectForKey:move.piece];
            if (!dst) {
                dst = [NSMutableSet set];
                [_isLegalMove setObject:dst forKey:move.piece];
            }
            [dst addObject:move.to];
        }];
    }
    return [[_isLegalMove objectForKey:aMove.piece] containsObject:aMove.to];
}

- (BOOL)opponent {
    return !_isPlayerOne;
}

- (SBState *)successorWithMove:(SBMove *)move {
    NSSet *newOccupiedSet = [_occupied setByAddingObject:[self locationForPiece:move.piece]];

    NSMutableDictionary *newLocations = [_pieceLocations mutableCopy];
    [newLocations setObject:move.to forKey:move.piece];

    NSMutableDictionary *newMovesLeft = [_movesLeft mutableCopy];
    NSUInteger moves = [self movesLeftForPiece:move.piece];
    [newMovesLeft setObject:[NSNumber numberWithUnsignedInteger:moves - 1] forKey:move.piece];

    return [[[self class] alloc] initWithPlayerOneTurn:self.opponent playerOnePieces:_playerOnePieces playerTwoPieces:_playerTwoPieces locations:[newLocations copy] movesLeft:[newMovesLeft copy] occupied:newOccupiedSet];
}

- (BOOL)isGameOver {
    __block BOOL isGameOver = YES;
    [self enumerateLegalMovesWithBlock:^(SBMove *move, BOOL *stop) {
        isGameOver = NO;
        *stop = YES;
    }];
    return isGameOver;
}

// The game is over when the current player can't perform any moves.
// Therefore the current player cannot be the winner; they can only achieve draw or loss.
- (BOOL)isLoss {
    NSParameterAssert([self isGameOver]);
    return ![self isDraw];
}

- (BOOL)isDraw {
    NSParameterAssert([self isGameOver]);
    __block BOOL isDraw = YES;
    [self enumerateLegalMovesForPlayerOne:self.opponent withBlock:^(SBMove *move, BOOL *stop) {
        isDraw = NO;
        *stop = YES;
    }];
    return isDraw;
}

- (void)enumerateLocationsUsingBlock:(void (^)(SBLocation*location))block {
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
