//
//  SBBoardTest.m
//  Phage
//
//  Created by Stig Brautaset on 24/3/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "SBBoardTest.h"
#import "SBBoard.h"

@interface Piece : NSObject <SBPiece>
@end

@implementation Piece
@end


@implementation SBBoardTest

- (void)testEquals {
    SBBoard *a = [[SBBoard alloc] init];
    STAssertEqualObjects(a, a, nil);
    
    SBBoard *b = [[SBBoard alloc] init];
    STAssertEqualObjects(a, b, nil);
    
    Piece *p = [[Piece alloc] init];
    [b setPiece:p atColumn:0 row:0];
    STAssertFalse([a isEqual:b], nil);

    [a setPiece:p atColumn:0 row:0];
    STAssertEqualObjects(a, b, nil);
}

- (void)testHash {
    SBBoard *a = [[SBBoard alloc] init];    
    SBBoard *b = [[SBBoard alloc] init];
    STAssertEquals([a hash], [b hash], nil);
}

- (void)setAndGetPiece {
    SBBoard *b = [[SBBoard alloc] init];
    STAssertNil([b pieceAtColumn:0 row:0], nil);
    
    Piece *p = [[Piece alloc] init];
    [b setPiece:p atColumn:0 row:0];
    STAssertEquals([b pieceAtColumn:0 row:0], p, nil);
}

@end
