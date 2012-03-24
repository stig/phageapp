//
//  SBBoard.h
//  Phage
//
//  Created by Stig Brautaset on 24/3/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@class SBPoint;
@class SBPiece;

#define BOARDSIZE 8

@interface SBBoard : NSObject  {

@private
    id grid[BOARDSIZE][BOARDSIZE];
}

// isEqual: delegates to this
- (BOOL)isEqualToBoard:(SBBoard*)board;

- (void)setPiece:(SBPiece*)piece atColumn:(NSInteger)c row:(NSInteger)r;
- (void)setPiece:(SBPiece*)piece atPoint:(SBPoint*)point;

- (SBPiece *)pieceAtColumn:(NSInteger)c row:(NSInteger)r;
- (SBPiece *)pieceAtPoint:(SBPoint*)point;


@end
