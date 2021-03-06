//
//  SBState.m
//  Phage
//
//  Created by Stig Brautaset on 25/3/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "SBBoard.h"
#import "SBCircle.h"
#import "SBDiamond.h"
#import "SBSquare.h"
#import "SBTriangle.h"
#import "SBLocation.h"
#import "SBDirection.h"
#import "SBMove.h"

@interface SBBoard ()
@property(nonatomic, strong) NSArray *pieces;
@property(nonatomic, strong) NSArray *moveHistory;
@property(nonatomic, strong) NSMutableDictionary *pieceMap;
@property(nonatomic, strong) NSMutableDictionary *locationMap;
@property(nonatomic, strong) NSMutableDictionary *pieceTurnCountMap;
@property(nonatomic, strong) NSSet *occupied;
@end

@implementation SBBoard

+ (id)boardWithMoveHistory:(NSArray *)moveHistory {
    return [[self alloc] initWithMoveHistory:moveHistory];
}

+ (id)boardFromPropertyList:(NSArray *)array {
    id (^block)(id) = ^id(id o) {
        return [SBMove moveFromPropertyList:o];
    };
    NSMutableArray *res = [NSMutableArray arrayWithCapacity:array.count];
    for (id o1 in array) {
        [res addObject:block(o1)];
    }
    return [SBBoard boardWithMoveHistory:res];
}

- (NSArray *)toPropertyList {
    id (^block)(id) = ^id(id o) {
        return [o toPropertyList];
    };
    NSMutableArray *res = [NSMutableArray arrayWithCapacity:self.moveHistory.count];
    for (id o1 in self.moveHistory) {
        [res addObject:block(o1)];
    }
    return res;
}

- (id)initWithMoveHistory:(NSArray*)moveHistory {
    self = [self init];
    for (SBMove *move in moveHistory)
        [self transformIntoSuccessorWithMove:move];
    return self;
}

+ (id)board {
    return [[self alloc] init];
}

- (id)init {
    self = [super init];
    if (!self) return nil;

    NSArray *thePieces = @[[SBCircle pieceWithOwner:0],
                                                   [SBSquare pieceWithOwner:0],
                                                   [SBTriangle pieceWithOwner:0],
                                                   [SBDiamond pieceWithOwner:0],
                                                   [SBCircle pieceWithOwner:1],
                                                   [SBSquare pieceWithOwner:1],
                                                   [SBTriangle pieceWithOwner:1],
                                                   [SBDiamond pieceWithOwner:1]];

    self.pieces = @[[thePieces subarrayWithRange:NSMakeRange(0, 4)],
                                            [thePieces subarrayWithRange:NSMakeRange(4, 4)]];

    NSArray *theLocations = @[[SBLocation locationWithColumn:1 row:4],
                                                          [SBLocation locationWithColumn:3 row:5],
                                                          [SBLocation locationWithColumn:5 row:6],
                                                          [SBLocation locationWithColumn:7 row:7],
                                                          [SBLocation locationWithColumn:6 row:3],
                                                          [SBLocation locationWithColumn:4 row:2],
                                                          [SBLocation locationWithColumn:2 row:1],
                                                          [SBLocation locationWithColumn:0 row:0]];

    self.locationMap = [NSMutableDictionary dictionaryWithObjects:theLocations forKeys:thePieces];
    self.pieceMap = [NSMutableDictionary dictionaryWithObjects:thePieces forKeys:theLocations];

    self.pieceTurnCountMap = [NSMutableDictionary dictionaryWithCapacity:thePieces.count];
    for (SBPiece *p in thePieces) {
        [self.pieceTurnCountMap setObject:@7u forKey:p];
    }

    self.occupied = [NSSet set];
    self.moveHistory = @[];

    return self;
}

#pragma mark NSCopying

- (id)copyWithZone:(NSZone*)zone {
    SBBoard *copy = [[[self class] alloc] initWithMoveHistory:self.moveHistory];
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

- (BOOL)isEqualToState:(SBBoard *)other {
    if (self == other)
        return YES;

    return [self.moveHistory isEqualToArray:other.moveHistory];
}

- (NSUInteger)hash {
    return [self.moveHistory hash];
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

    for (id pp in self.pieces) {
        for (id p in pp) {
            [desc appendFormat:@"%@:%@ ", p, [self.pieceTurnCountMap objectForKey:p]];
        }
        [desc appendString:@"\n"];
    }

    for (NSInteger r = self.rows - 1; r >= 0; r--) {
        for (NSUInteger c = 0; c < self.columns; c++) {
            SBLocation *loc = [SBLocation locationWithColumn:c row:(NSUInteger)r];

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

    return desc;
}

#pragma mark model methods

- (NSNumber*)turnsLeftForPiece:(SBPiece *)piece {
    return [self.pieceTurnCountMap objectForKey:piece];
}

- (SBLocation *)locationForPiece:(SBPiece *)piece {
    return [self.locationMap objectForKey:piece];
}

- (void)enumerateLegalDestinationsForPiece:(SBPiece *)piece withBlock:(void (^)(SBLocation *loc, BOOL *stop))block {
    if ([@0U isEqualToNumber:[self turnsLeftForPiece:piece]])
        return;

    for (SBDirection *d in piece.directions) {
        SBLocation *loc = [self locationForPiece:piece];
        for (;;) {
            loc = [loc locationByMovingInDirection:d];

            // Is the location not on the grid?
            if (!loc)
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

- (NSSet *)legalDestinationsForPiece:(SBPiece *)piece {
    NSMutableSet *legalDestinations = [NSMutableSet set];
    [self enumerateLegalDestinationsForPiece:piece withBlock:^(SBLocation *location, BOOL *stop) {
        [legalDestinations addObject:location];
    }];
    return [legalDestinations copy];
}


- (void)enumerateLegalMovesWithBlock:(void(^)(SBMove *move, BOOL *stop))block {
    [self enumerateLegalMovesForPlayer:self.currentPlayerIndex withBlock:block];
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

- (void)transformIntoSuccessorWithMove:(SBMove*)move {
    self.occupied = [self.occupied setByAddingObject:move.from];
    self.moveHistory = [self.moveHistory arrayByAddingObject:move];

    SBPiece *piece = [self pieceForLocation:move.from];
    [self.locationMap setObject:move.to forKey:piece];

    [self.pieceMap removeObjectForKey:move.from];
    [self.pieceMap setObject:piece forKey:move.to];

    NSUInteger n = [[self turnsLeftForPiece:piece] unsignedIntegerValue];
    [self.pieceTurnCountMap setObject:@(n - 1) forKey:piece];
}

- (SBBoard *)successorWithMove:(SBMove *)move {
    SBBoard *copy = [self copy];
    [copy transformIntoSuccessorWithMove:move];
    return copy;
}

- (NSArray *)legalMoves {
    __block NSMutableArray *moves = [NSMutableArray array];
    [self enumerateLegalMovesWithBlock:^(SBMove *move, BOOL *stop) {
        [moves addObject:move];
    }];
    return moves;
}

- (NSInteger)fitness {
    __block NSInteger cnt = 0;
    [self enumerateLegalMovesForPlayer:self.currentPlayerIndex withBlock:^(SBMove *move, BOOL *stop) {
        cnt++;
    }];

    [self enumerateLegalMovesForPlayer:self.otherPlayerIndex withBlock:^(SBMove *move, BOOL *stop) {
        cnt--;
    }];
    return cnt;
}


- (BOOL)isGameOver {
    __block BOOL isGameOver = YES;
    [self enumerateLegalMovesWithBlock:^(SBMove *move, BOOL *stop) {
        isGameOver = NO;
        *stop = YES;
    }];
    return isGameOver;
}

- (BOOL)isDraw {
    NSParameterAssert([self isGameOver]);

    __block BOOL canOpponentMove = NO;
    [self enumerateLegalMovesForPlayer:self.otherPlayerIndex withBlock:^(SBMove *move, BOOL *stop) {
        canOpponentMove = YES;
        *stop = YES;
    }];

    if (canOpponentMove)
        return NO;

    return 0 == self.currentPlayerIndex;
}

- (void)enumerateLocationsUsingBlock:(void (^)(SBLocation*location))block {
    for (NSUInteger r = 0; r < self.rows; r++) {
        for (NSUInteger c = 0; c < self.columns; c++) {
            block([SBLocation locationWithColumn:c row:r]);
        }
    }
}

- (NSUInteger)currentPlayerIndex {
    return self.moveHistory.count % 2u;
}

- (NSUInteger)otherPlayerIndex {
    return 1 - [self currentPlayerIndex];
}

- (NSUInteger)columns {
    return COLUMNS;
}

- (NSUInteger)rows {
    return ROWS;
}

@end
