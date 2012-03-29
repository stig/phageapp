//
//  SBState.h
//  Phage
//
//  Created by Stig Brautaset on 25/3/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SBPiece.h"

@class SBGrid;
@class SBLocation;
@class SBMove;

@interface SBState : NSObject {

@private
    SBGrid *grid;
    NSDictionary *movesLeft;
    NSDictionary *location;
}

@property (strong, readonly) NSArray *north;
@property (strong, readonly) NSArray *south;
@property (readonly) SBPlayer playerTurn;

- (NSUInteger)movesLeftForPiece:(SBPiece*)piece;
- (SBLocation *)locationForPiece:(SBPiece*)piece;

- (BOOL)isEqualToState:(SBState*)state;

- (NSArray*)legalMoves;

- (SBState *)successorWithMove:(SBMove *)move;

@end
