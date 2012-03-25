//
//  SBState.m
//  Phage
//
//  Created by Stig Brautaset on 25/3/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "SBState.h"
#import "SBGrid.h"
#import "SBPiece.h"
#import "SBCirclePiece.h"
#import "SBDiamondPiece.h"
#import "SBSquarePiece.h"
#import "SBTrianglePiece.h"
#import "SBPoint.h"


@implementation SBState

@synthesize grid = _grid;

- (id)init {
    self = [super init];
    if (self) {
        _grid = [[SBGrid alloc] init];
        
        [_grid setPiece:[[SBCirclePiece alloc]   initWithOwner:NORTH] atColumn:1 row:4];
        [_grid setPiece:[[SBSquarePiece alloc]   initWithOwner:NORTH] atColumn:3 row:5];
        [_grid setPiece:[[SBTrianglePiece alloc] initWithOwner:NORTH] atColumn:5 row:6];
        [_grid setPiece:[[SBDiamondPiece alloc]  initWithOwner:NORTH] atColumn:7 row:7];

        [_grid setPiece:[[SBCirclePiece alloc]   initWithOwner:SOUTH] atColumn:6 row:3];
        [_grid setPiece:[[SBSquarePiece alloc]   initWithOwner:SOUTH] atColumn:4 row:2];
        [_grid setPiece:[[SBTrianglePiece alloc] initWithOwner:SOUTH] atColumn:2 row:1];
        [_grid setPiece:[[SBDiamondPiece alloc]  initWithOwner:SOUTH] atColumn:0 row:0];
    }
    return self;
}

- (NSString*)description {
    // hack for now...
    return [_grid description];
}


@end
