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

@interface SBPhageBoard : NSObject <NSCopying>

@property(nonatomic, readonly) NSUInteger currentPlayer;
@property(nonatomic, readonly) NSUInteger rows;
@property(nonatomic, readonly) NSUInteger columns;
@property(nonatomic, strong, readonly) NSArray *pieces;
@property(nonatomic, strong, readonly) NSArray *moveHistory;

+ (id)board;
+ (id)boardWithMoveHistory:(NSArray*)moveHistory;
- (id)initWithMoveHistory:(NSArray *)moveHistory;

- (NSNumber*)turnsLeftForPiece:(SBPiece*)piece;
- (SBLocation *)locationForPiece:(SBPiece*)piece;
- (SBPiece *)pieceForLocation:(SBLocation *)loc;

- (BOOL)wasLocationOccupied:(SBLocation*)loc;

- (SBPhageBoard *)successorWithMove:(SBMove *)move;

- (BOOL)isLegalMove:(SBMove*)move;

- (BOOL)isGameOver;
- (BOOL)isLoss;
- (BOOL)isDraw;

- (void)enumerateLocationsUsingBlock:(void (^)(SBLocation *location))block;
- (void)enumerateLegalMovesWithBlock:(void(^)(SBMove *move, BOOL *stop))block;
- (void)enumerateLegalDestinationsForPiece:(SBPiece*)piece withBlock:(void (^)(SBLocation *location, BOOL *stop))block;

@end