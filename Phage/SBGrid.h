//
//  SBBoard.h
//  Phage
//
//  Created by Stig Brautaset on 24/3/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@class SBLocation;
@class SBPiece;

#define GRIDSIZE 8

@interface SBGrid : NSObject  {

@private
    id grid[GRIDSIZE][GRIDSIZE];
}

// isEqual: delegates to this
- (BOOL)isEqualToBoard:(SBGrid*)board;

- (void)setPiece:(SBPiece*)piece atColumn:(NSInteger)c row:(NSInteger)r;
- (void)setPiece:(SBPiece*)piece atLocation:(SBLocation *)point;

- (SBPiece*)pieceAtColumn:(NSInteger)c row:(NSInteger)r;
- (SBPiece*)pieceAtLocation:(SBLocation *)point;


@end
