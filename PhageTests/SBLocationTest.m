//
//  SBPointTest.m
//  Phage
//
//  Created by Stig Brautaset on 24/3/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "SBLocationTest.h"
#import "SBLocation.h"

@implementation SBLocationTest

static SBLocation *loc;

- (void)setUp {
    loc = [[SBLocation alloc] initWithColumn:1 row:3];
}

- (void)testBasic {
    STAssertNotNil(loc, nil);
    
    STAssertEquals(loc.column, 1, nil);
    STAssertEquals(loc.row, 3, nil);
}

- (void)testEqual {
    STAssertEqualObjects(loc, loc, nil);

    SBLocation *b = [[SBLocation alloc] initWithColumn:loc.column row:loc.row];
    STAssertEqualObjects(loc, b, nil);
}

- (void)testHash {
    SBLocation *b = [[SBLocation alloc] initWithColumn:loc.column row:loc.row];
    STAssertEquals([loc hash], [b hash], nil);
}


- (void)testDescription {
    STAssertEqualObjects(@"b4", [loc description], nil);
}

@end
