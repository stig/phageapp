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
    NSSet *_occupied;
    NSDictionary *_moves;
    NSDictionary *_locations;
}

@property(readonly) NSUInteger rows;
@property(readonly) NSUInteger columns;
@property(strong, readonly) NSArray *north;
@property(strong, readonly) NSArray *south;

- (NSUInteger)movesLeftForPiece:(SBPiece*)piece;
- (SBLocation *)locationForPiece:(SBPiece*)piece;

- (BOOL)isEqualToState:(SBState*)state;

- (NSArray *)piecesForPlayer:(SBPlayer*)player;
- (NSArray *)legalMovesForPlayer:(SBPlayer*)player;
- (SBState *)successorWithMove:(SBMove *)move;

- (BOOL)isGameOverForPlayer:(SBPlayer*)player;
- (BOOL)isWinForPlayer:(SBPlayer*)player;
- (BOOL)isDraw;

@end
