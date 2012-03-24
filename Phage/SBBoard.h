//
//  SBBoard.h
//  Phage
//
//  Created by Stig Brautaset on 24/3/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SBPiece.h"

@class SBPoint;

#define BOARDSIZE 8

@interface SBBoard : NSObject  {

@private
    id<SBPiece> grid[BOARDSIZE][BOARDSIZE];
}

// isEqual: delegates to this
- (BOOL)isEqualToBoard:(SBBoard*)board;

- (void)setPiece:(id<SBPiece>)piece atColumn:(NSInteger)c row:(NSInteger)r;
- (void)setPiece:(id<SBPiece>)piece atPoint:(SBPoint*)point;

- (id<SBPiece>)pieceAtColumn:(NSInteger)c row:(NSInteger)r;
- (id<SBPiece>)pieceAtPoint:(SBPoint*)point;


@end
