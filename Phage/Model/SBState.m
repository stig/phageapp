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
@property(nonatomic, strong) NSArray *pieces;
@property(nonatomic, strong) NSArray *moves;
@property(nonatomic, strong) NSMutableDictionary *pieceMap;
@property(nonatomic, strong) NSMutableDictionary *locationMap;
@property(nonatomic, strong) NSMutableDictionary *moveCountMap;
@property(nonatomic, strong) NSSet *occupied;
@end

@implementation SBState
@synthesize moveCountMap = _moveCountMap;
@synthesize occupied = _occupied;
@synthesize pieces = _pieces;
@synthesize moves = _moves;
@synthesize locationMap = _locationMap;
@synthesize pieceMap = _pieceMap;

+ (id)stateWithMoves:(NSArray *)moves {
    return [[self alloc] initWithMoves:moves];
}

- (id)initWithMoves:(NSArray*)moves {
    self = [self init];
    for (SBMove *move in moves)
        [self transformIntoSuccessorWithMove:move];
    return self;
}

+ (id)state {
    return [[self alloc] init];
}

- (id)init {
    self = [super init];
    if (!self) return nil;

    NSArray *thePieces = [NSArray arrayWithObjects:[SBCirclePiece pieceWithOwner:0],
                                                   [SBSquarePiece pieceWithOwner:0],
                                                   [SBTrianglePiece pieceWithOwner:0],
                                                   [SBDiamondPiece pieceWithOwner:0],
                                                   [SBCirclePiece pieceWithOwner:1],
                                                   [SBSquarePiece pieceWithOwner:1],
                                                   [SBTrianglePiece pieceWithOwner:1],
                                                   [SBDiamondPiece pieceWithOwner:1],
                                                   nil];

    self.pieces = [NSArray arrayWithObjects:[thePieces subarrayWithRange:NSMakeRange(0, 4)],
                                            [thePieces subarrayWithRange:NSMakeRange(4, 4)],
                                            nil];

    NSArray *theLocations = [NSArray arrayWithObjects:[SBLocation locationWithColumn:1 row:4],
                                                          [SBLocation locationWithColumn:3 row:5],
                                                          [SBLocation locationWithColumn:5 row:6],
                                                          [SBLocation locationWithColumn:7 row:7],
                                                          [SBLocation locationWithColumn:6 row:3],
                                                          [SBLocation locationWithColumn:4 row:2],
                                                          [SBLocation locationWithColumn:2 row:1],
                                                          [SBLocation locationWithColumn:0 row:0],
                                                          nil];

    self.locationMap = [NSMutableDictionary dictionaryWithObjects:theLocations forKeys:thePieces];
    self.pieceMap = [NSMutableDictionary dictionaryWithObjects:thePieces forKeys:theLocations];

    self.moveCountMap = [NSMutableDictionary dictionaryWithCapacity:thePieces.count];
    for (SBPiece *p in thePieces) {
        [self.moveCountMap setObject:[NSNumber numberWithUnsignedInteger:7u] forKey:p];
    }

    self.occupied = [NSSet set];
    self.moves = [NSArray array];

    return self;
}

#pragma mark NSCopying

- (id)copyWithZone:(NSZone*)zone {
    SBState *copy = [[[self class] alloc] initWithMoves:self.moves];
    return copy;
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

    return [self.moves isEqualToArray:other.moves];
}

- (NSUInteger)hash {
    return [self.moves hash];
}

#pragma mark description

- (BOOL)wasLocationOccupied:(SBLocation *)loc {
    return [self.occupied containsObject:loc];
}

- (BOOL)isLocationOccupied:(SBLocation*)loc {
    return nil != [self pieceForLocation:loc];
}

- (SBPiece *)pieceForLocation:(SBLocation *)loc {
    return [self.pieceMap objectForKey:loc];
}

- (NSString *)description {
    NSMutableString *desc = [[NSMutableString alloc] initWithCapacity:self.rows * self.columns * 2u];

    for (id p in [self piecesForPlayer:YES]) {
        [desc appendFormat:@"%@: %@\n", p, [self.moveCountMap objectForKey:p]];
    }

    for (int r = self.rows - 1; r >= 0; r--) {
        for (int c = 0; c < self.columns; c++) {
            SBLocation *loc = [SBLocation locationWithColumn:c row:r];

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

    for (id p in [self piecesForPlayer:NO]) {
        [desc appendFormat:@"%@: %@\n", p, [self.moveCountMap objectForKey:p]];
    }

    return desc;
}

#pragma mark model methods

- (NSNumber*)movesLeftForPiece:(SBPiece *)piece {
    return [self.moveCountMap objectForKey:piece];
}

- (SBLocation *)locationForPiece:(SBPiece *)piece {
    return [self.locationMap objectForKey:piece];
}

- (BOOL)isGridLocation:(SBLocation*)loc {
    return loc.column >= 0 && loc.column < self.columns && loc.row >= 0 && loc.row < self.rows;
}

- (void)enumerateLegalDestinationsForPiece:(SBPiece *)piece withBlock:(void (^)(SBLocation *loc, BOOL *stop))block {
    if ([[NSNumber numberWithUnsignedInteger:0] isEqualToNumber:[self movesLeftForPiece:piece]])
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

- (void)enumerateLegalMovesForPlayer:(NSUInteger)playerTurn withBlock:(void(^)(SBMove *move, BOOL *stop))block {
    for (SBPiece *piece in [self.pieces objectAtIndex:playerTurn]) {
        SBLocation *from = [self locationForPiece:piece];
        [self enumerateLegalDestinationsForPiece:piece
                                       withBlock:^(SBLocation *loc, BOOL *stop) {
                                           block([SBMove moveWithFrom:from to:loc], stop);
                                       }];
    }
}

- (void)enumerateLegalMovesWithBlock:(void(^)(SBMove *move, BOOL *stop))block {
    [self enumerateLegalMovesForPlayer:self.currentPlayer withBlock:block];
}

- (NSArray *)piecesForPlayer:(BOOL)player {
    return [self.pieces objectAtIndex:player ? 0 : 1];
}

- (BOOL)isLegalMove:(SBMove*)aMove {
    __block BOOL isLegalMove = NO;
    [self enumerateLegalMovesWithBlock:^(SBMove *move, BOOL *stop) {
        if ([aMove isEqualToMove:move]) {
            *stop = YES;
            isLegalMove = YES;
        }
    }];
    return isLegalMove;
}

- (NSUInteger)opponent {
    return 1 - [self currentPlayer];
}

- (void)transformIntoSuccessorWithMove:(SBMove*)move {
    self.occupied = [self.occupied setByAddingObject:move.from];
    self.moves = [self.moves arrayByAddingObject:move];

    SBPiece *piece = [self pieceForLocation:move.from];
    [self.locationMap setObject:move.to forKey:piece];

    [self.pieceMap removeObjectForKey:move.from];
    [self.pieceMap setObject:piece forKey:move.to];

    NSUInteger n = [[self movesLeftForPiece:piece] unsignedIntegerValue];
    [self.moveCountMap setObject:[NSNumber numberWithUnsignedInteger:n - 1] forKey:piece];
}

- (SBState *)successorWithMove:(SBMove *)move {
    SBState *copy = [self copy];
    [copy transformIntoSuccessorWithMove:move];
    return copy;
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
    [self enumerateLegalMovesForPlayer:self.opponent withBlock:^(SBMove *move, BOOL *stop) {
        isDraw = NO;
        *stop = YES;
    }];
    return isDraw;
}

- (void)enumerateLocationsUsingBlock:(void (^)(SBLocation*location))block {
    for (NSUInteger r = 0; r < self.rows; r++) {
        for (NSUInteger c = 0; c < self.columns; c++) {
            block([SBLocation locationWithColumn:c row:r]);
        }
    }
}

- (BOOL)isPlayerOne {
    return 0 == [self currentPlayer];
}

- (NSUInteger)currentPlayer {
    return self.moves.count % 2u;
}

- (NSUInteger)columns {
    return 8u;
}

- (NSUInteger)rows {
    return 8u;
}

@end
