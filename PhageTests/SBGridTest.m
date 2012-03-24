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

@interface Piece : SBPiece
@end

@implementation Piece
@end


@implementation SBGridTest

- (void)testEquals {
    SBGrid *a = [[SBGrid alloc] init];
    STAssertEqualObjects(a, a, nil);
    
    SBGrid *b = [[SBGrid alloc] init];
    STAssertEqualObjects(a, b, nil);
    
    Piece *p = [[Piece alloc] init];
    [b setPiece:p atColumn:0 row:0];
    STAssertFalse([a isEqual:b], nil);

    [a setPiece:p atColumn:0 row:0];
    STAssertEqualObjects(a, b, nil);
}

- (void)testHash {
    SBGrid *a = [[SBGrid alloc] init];    
    SBGrid *b = [[SBGrid alloc] init];
    STAssertEquals([a hash], [b hash], nil);
}

- (void)setAndGetPiece {
    SBGrid *b = [[SBGrid alloc] init];
    STAssertNil([b pieceAtColumn:0 row:0], nil);
    
    Piece *p = [[Piece alloc] init];
    [b setPiece:p atColumn:0 row:0];
    STAssertEquals([b pieceAtColumn:0 row:0], p, nil);
}

- (void)testDescription {
    SBGrid *b = [[SBGrid alloc] init];
    STAssertEqualObjects([b description], @"........\n........\n........\n........\n........\n........\n........\n........\n", nil);

    [b setPiece:[[Piece alloc] init] atColumn:1 row:3];
    [b setPiece:[[Piece alloc] initWithOwner:SOUTH] atColumn:3 row:1];
    STAssertEqualObjects([b description], @"........\n...E....\n........\n.e......\n........\n........\n........\n........\n", nil);
}

@end
