//
//  SBState.h
//  Phage
//
//  Created by Stig Brautaset on 25/3/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SBPiece.h"

@class SBLocation;
@class SBMove;

@interface SBState : NSObject <NSCopying>

@property(nonatomic, readonly) NSUInteger currentPlayer;
@property(nonatomic, readonly) NSUInteger rows;
@property(nonatomic, readonly) NSUInteger columns;
@property(nonatomic, strong, readonly) NSArray *pieces;
@property(nonatomic, strong, readonly) NSArray *moves;

+ (id)state;
+ (id)stateWithMoves:(NSArray*)moves;
- (id)initWithMoves:(NSArray *)moves;

- (NSNumber*)movesLeftForPiece:(SBPiece*)piece;
- (SBLocation *)locationForPiece:(SBPiece*)piece;
- (SBPiece *)pieceForLocation:(SBLocation *)loc;

- (BOOL)isEqualToState:(SBState*)state;

- (BOOL)wasLocationOccupied:(SBLocation*)loc;

- (SBState *)successorWithMove:(SBMove *)move;

- (BOOL)isLegalMove:(SBMove*)move;

- (BOOL)isGameOver;
- (BOOL)isLoss;
- (BOOL)isDraw;

- (void)enumerateLocationsUsingBlock:(void (^)(SBLocation *location))block;
- (void)enumerateLegalMovesWithBlock:(void(^)(SBMove *move, BOOL *stop))block;
- (void)enumerateLegalDestinationsForPiece:(SBPiece*)piece withBlock:(void (^)(SBLocation *location, BOOL *stop))block;

@end
