//
//  SBPieceTest.m
//  Phage
//
//  Created by Stig Brautaset on 25/3/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <SenTestingKit/SenTestingKit.h>
#import "SBPiece.h"
#import "SBCircle.h"
#import "SBTriangle.h"

@interface SBPieceTest : SenTestCase {
    SBPiece *a;
}
@end


@implementation SBPieceTest

- (void)setUp {
    a = [SBCircle pieceWithOwner:0];
}

- (void)testSelfEquals {
    STAssertEqualObjects(a, a, nil);
}

- (void)testSameEquals {
    SBPiece *b = [SBCircle pieceWithOwner:0];
    STAssertEqualObjects(a, b, nil);
}

- (void)testSouthNotEquals {
    SBPiece *c = [SBCircle pieceWithOwner:1];
    STAssertFalse([a isEqual:c], nil);
}

- (void)testTriangleNotEquals {
    SBPiece *d = [SBTriangle pieceWithOwner:0];
    STAssertFalse([a isEqual:d], nil);
}

- (void)testHash {
    SBPiece *b = [SBCircle pieceWithOwner:0];
    STAssertEquals([a hash], [b hash], nil);    
}

- (void)testSouthHashNotEquals {
    SBPiece *b = [SBCircle pieceWithOwner:1];
    STAssertFalse([a hash] == [b hash], nil);    
}


- (void)testTriangleHashNotEquals {
    SBPiece *b = [SBTriangle pieceWithOwner:0];
    STAssertFalse([a hash] == [b hash], nil);    
}


@end
