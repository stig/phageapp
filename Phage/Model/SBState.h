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

@interface SBState : NSObject <NSCoding>

@property(readonly) BOOL isPlayerOne;
@property(readonly) NSUInteger rows;
@property(readonly) NSUInteger columns;
@property(strong, readonly) NSArray *playerOnePieces;
@property(strong, readonly) NSArray *playerTwoPieces;

- (id)initWithPlayer:(BOOL)thePlayer;

- (NSUInteger)movesLeftForPiece:(SBPiece*)piece;
- (SBLocation *)locationForPiece:(SBPiece*)piece;
- (SBPiece *)pieceForLocation:(SBLocation *)loc;

- (BOOL)isEqualToState:(SBState*)state;

- (NSArray *)piecesForPlayer:(BOOL)player;

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
