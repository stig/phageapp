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

- (id<SBPiece>)pieceAtColumn:(NSInteger)c row:(NSInteger)r;
- (id<SBPiece>)pieceAtPoint:(SBPoint*)point;


@end
