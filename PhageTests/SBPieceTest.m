//
//  SBPieceTest.m
//  Phage
//
//  Created by Stig Brautaset on 25/3/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "SBPieceTest.h"
#import "SBPiece.h"
#import "SBCirclePiece.h"
#import "SBDiamondPiece.h"
#import "SBSquarePiece.h"
#import "SBTrianglePiece.h"

SBPiece *a;

@implementation SBPieceTest

- (void)setUp {
    a = [[SBCirclePiece alloc] init];
}

- (void)testSelfEquals {
    STAssertEqualObjects(a, a, nil);
}

- (void)testSameEquals {
    SBPiece *b = [[SBCirclePiece alloc] init];
    STAssertEqualObjects(a, b, nil);
}

- (void)testSouthNotEquals {
    SBPiece *c = [[SBCirclePiece alloc] initWithPlayer:SBPlayerSouth];
    STAssertFalse([a isEqual:c], nil);
}

- (void)testTriangleNotEquals {
    SBPiece *d = [[SBTrianglePiece alloc] init];
    STAssertFalse([a isEqual:d], nil);
}

- (void)testHash {
    SBPiece *b = [[SBCirclePiece alloc] init];
    STAssertEquals([a hash], [b hash], nil);    
}

- (void)testSouthHashNotEquals {
    SBPiece *b = [[SBCirclePiece alloc] initWithPlayer:SBPlayerSouth];
    STAssertFalse([a hash] == [b hash], nil);    
}


- (void)testTriangleHashNotEquals {
    SBPiece *b = [[SBTrianglePiece alloc] init];
    STAssertFalse([a hash] == [b hash], nil);    
}


@end
