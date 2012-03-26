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

static SBLocation *a;
static SBLocation *b;

@implementation SBMoveTest

- (void)setUp {
    a = [[SBLocation alloc] initWithColumn:1 row:3];
    b = [[SBLocation alloc] initWithColumn:2 row:4];
}


- (void)testBasic {
    SBMove *m = [[SBMove alloc] initWithFrom:a to:b];
    STAssertNotNil(m, nil);
    
    STAssertEqualObjects(m.from, a, nil);
    STAssertEqualObjects(m.to, b, nil);
}

- (void)testEqual {
    SBMove *f = [[SBMove alloc] initWithFrom:a to:b];
    STAssertEqualObjects(f, f, nil);
    
    SBMove *g = [[SBMove alloc] initWithFrom:f.from to:f.to];
    STAssertEqualObjects(f, g, nil);
}

- (void)testHash {
    SBMove *f = [[SBMove alloc] initWithFrom:a to:b];    
    SBMove *g = [[SBMove alloc] initWithFrom:f.from to:f.to];
    STAssertEquals([f hash], [g hash], nil);    
}


@end
