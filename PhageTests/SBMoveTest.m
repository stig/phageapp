//
//  SBMoveTest.m
//  Phage
//
//  Created by Stig Brautaset on 24/3/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "SBMoveTest.h"
#import "SBLocation.h"
#import "SBMove.h"
#import "SBCirclePiece.h"

static SBPiece *a;
static SBLocation *b;
static SBMove *m;

@implementation SBMoveTest

- (void)setUp {
    a = [[SBCirclePiece alloc] init];
    b = [[SBLocation alloc] initWithColumn:2 row:4];
    m = [[SBMove alloc] initWithPiece:a to:b];
}

- (void)testBasic {
    STAssertNotNil(m, nil);
    
    STAssertEqualObjects(m.piece, a, nil);
    STAssertEqualObjects(m.to, b, nil);
}

- (void)testEqual {
    STAssertEqualObjects(m, m, nil);
    
    SBMove *g = [[SBMove alloc] initWithPiece:m.piece to:m.to];
    STAssertEqualObjects(m, g, nil);
}

- (void)testHash {
    SBMove *g = [[SBMove alloc] initWithPiece:m.piece to:m.to];
    STAssertEquals([m hash], [g hash], nil);
}


@end
