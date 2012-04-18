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
@class SBPlayer;

@interface SBState : NSObject <NSCoding> {

@private
    SBPlayer *_player;
    NSSet *_occupied;
    NSDictionary *_movesLeft;
    NSDictionary *_pieceLocations;
}

@property(readonly) SBPlayer *player;
@property(readonly) NSUInteger rows;
@property(readonly) NSUInteger columns;
@property(strong, readonly) NSArray *north;
@property(strong, readonly) NSArray *south;

- (NSUInteger)movesLeftForPiece:(SBPiece*)piece;
- (SBLocation *)locationForPiece:(SBPiece*)piece;
- (NSArray*)moveLocationsForPiece:(SBPiece*)piece;

- (BOOL)isEqualToState:(SBState*)state;

- (NSArray *)piecesForPlayer:(SBPlayer*)player;

- (NSArray *)legalMoves;
- (SBState *)successorWithMove:(SBMove *)move;

- (BOOL)isGameOver;
- (BOOL)isWin;
- (BOOL)isDraw;

- (void)enumerateLocationsUsingBlock:(void (^)(SBLocation *location))block;
- (BOOL)isPreviouslyOccupied:(SBLocation *)loc;

@end
