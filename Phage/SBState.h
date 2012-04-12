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
    NSSet *_occupied;
    NSDictionary *_moves;
    NSDictionary *_locations;
}

@property (strong, readonly) NSArray *north;
@property (strong, readonly) NSArray *south;

- (NSUInteger)movesLeftForPiece:(SBPiece*)piece;
- (SBLocation *)locationForPiece:(SBPiece*)piece;

- (BOOL)isEqualToState:(SBState*)state;

- (NSArray *)legalMovesForPlayer:(SBPlayer)player;

- (SBState *)successorWithMove:(SBMove *)move;

@end