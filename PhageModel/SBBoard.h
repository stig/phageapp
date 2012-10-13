//
//  SBState.h
//  Phage
//
//  Created by Stig Brautaset on 25/3/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SBPiece.h"
#import "Scrutor.h"

@class SBLocation;
@class SBMove;

@interface SBBoard : NSObject <NSCopying, SBGameTreeNode >

@property(nonatomic, readonly) NSUInteger rows;
@property(nonatomic, readonly) NSUInteger columns;
@property(nonatomic, strong, readonly) NSArray *pieces;
@property(nonatomic, strong, readonly) NSArray *moveHistory;

+ (id)board;
+ (id)boardWithMoveHistory:(NSArray*)moveHistory;

+ (id)boardFromPropertyList:(NSArray *)array;
- (id)toPropertyList;

- (NSNumber*)turnsLeftForPiece:(SBPiece*)piece;
- (SBLocation *)locationForPiece:(SBPiece*)piece;
- (SBPiece *)pieceForLocation:(SBLocation *)loc;

- (BOOL)wasLocationOccupied:(SBLocation*)loc;

- (SBBoard *)successorWithMove:(SBMove *)move;

- (BOOL)isLegalMove:(SBMove*)move;

- (BOOL)isGameOver;

- (BOOL)isDraw;

- (void)enumerateLocationsUsingBlock:(void (^)(SBLocation *location))block;

- (NSUInteger)currentPlayerIndex;
- (NSUInteger)otherPlayerIndex;

- (void)enumerateLegalMovesWithBlock:(void(^)(SBMove *move, BOOL *stop))block;
- (void)enumerateLegalDestinationsForPiece:(SBPiece*)piece withBlock:(void (^)(SBLocation *location, BOOL *stop))block;

- (NSSet*)legalDestinationsForPiece:(SBPiece*)piece;

@end
