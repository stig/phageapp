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

@interface SBState : NSObject <NSCoding> {

@private
    BOOL _isPlayerOne;
    NSSet *_occupied;
    NSDictionary *_movesLeft;
    NSDictionary *_pieceLocations;
}

@property(readonly) BOOL isPlayerOne;
@property(readonly) NSUInteger rows;
@property(readonly) NSUInteger columns;
@property(strong, readonly) NSArray *playerOnePieces;
@property(strong, readonly) NSArray *playerTwoPieces;

- (id)initWithPlayer:(BOOL)thePlayer;

- (NSUInteger)movesLeftForPiece:(SBPiece*)piece;
- (SBLocation *)locationForPiece:(SBPiece*)piece;
- (SBPiece *)pieceForLocation:(SBLocation *)loc;
- (NSArray*)moveLocationsForPiece:(SBPiece*)piece;

- (BOOL)isEqualToState:(SBState*)state;

- (NSArray *)piecesForPlayer:(BOOL)player;

- (BOOL)wasLocationOccupied:(SBLocation*)loc;

- (NSArray *)legalMoves;
- (SBState *)successorWithMove:(SBMove *)move;

- (BOOL)isGameOver;
- (BOOL)isWin;
- (BOOL)isDraw;

- (void)enumerateLocationsUsingBlock:(void (^)(SBLocation *location))block;

@end
