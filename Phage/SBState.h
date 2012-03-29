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

@interface SBState : NSObject {

@protected
    SBGrid *grid;

@private
    NSMutableDictionary *movesLeft;
    NSMutableDictionary *location;
}

@property (strong, readonly) NSArray *north;
@property (strong, readonly) NSArray *south;
@property (readonly) SBPlayer playerTurn;

- (NSUInteger)movesLeftForPiece:(SBPiece*)piece;
- (SBLocation *)locationForPiece:(SBPiece*)piece;

- (BOOL)isEqualToState:(SBState*)state;

- (NSArray*)legalMoves;

@end
