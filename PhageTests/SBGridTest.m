//
//  SBBoardTest.m
//  Phage
//
//  Created by Stig Brautaset on 24/3/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "SBGridTest.h"
#import "SBGrid.h"
#import "SBPiece.h"
#import "SBLocation.h"

@interface Piece : SBPiece
@end

@implementation Piece
@end

static SBGrid *g;

@implementation SBGridTest

- (void)setUp {
    g = [[SBGrid alloc] init];
}

- (void)testEquals {
    STAssertEqualObjects(g, g, nil);
    
    SBGrid *b = [[SBGrid alloc] init];
    STAssertEqualObjects(g, b, nil);
    
    Piece *p = [[Piece alloc] init];
    [b setPiece:p atColumn:0 row:0];
    STAssertFalse([g isEqual:b], nil);

    [g setPiece:p atColumn:0 row:0];
    STAssertEqualObjects(g, b, nil);
}

- (void)testHash {
    SBGrid *b = [[SBGrid alloc] init];
    STAssertEquals([g hash], [b hash], nil);
}

- (void)setAndGetPiece {
    STAssertNil([g pieceAtColumn:0 row:0], nil);
    
    Piece *p = [[Piece alloc] init];
    [g setPiece:p atColumn:0 row:0];
    STAssertEquals([g pieceAtColumn:0 row:0], p, nil);
}

- (void)testDescription {
    STAssertEqualObjects([g description], @"........\n........\n........\n........\n........\n........\n........\n........\n", nil);

    [g setPiece:[[Piece alloc] init] atColumn:0 row:0];
    STAssertEqualObjects([g description], @"........\n........\n........\n........\n........\n........\n........\nE.......\n", nil);

    [g setPiece:[[Piece alloc] initWithOwner:SOUTH] atColumn:7 row:0];
    STAssertEqualObjects([g description], @"........\n........\n........\n........\n........\n........\n........\nE......e\n", nil);

    [g setPiece:[[Piece alloc] init] atColumn:7 row:7];
    STAssertEqualObjects([g description], @".......E\n........\n........\n........\n........\n........\n........\nE......e\n", nil);
    
    [g setPiece:[[Piece alloc] initWithOwner:SOUTH] atColumn:0 row:7];
    STAssertEqualObjects([g description], @"e......E\n........\n........\n........\n........\n........\n........\nE......e\n", nil);

}

- (void)testCanMoveToLocation {
    STAssertFalse([g isUnoccupiedGridLocation:[[SBLocation alloc] initWithColumn:-1 row:0]], nil);
    STAssertFalse([g isUnoccupiedGridLocation:[[SBLocation alloc] initWithColumn:0 row:8]], nil);

    SBLocation *loc = [[SBLocation alloc] initWithColumn:0 row:0];
    STAssertTrue([g isUnoccupiedGridLocation:loc], nil);
    [g setPiece:[[Piece alloc] init] atLocation:loc];
    STAssertFalse([g isUnoccupiedGridLocation:loc], nil);
}

@end
