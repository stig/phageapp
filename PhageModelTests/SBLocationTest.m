//
//  SBPointTest.m
//  Phage
//
//  Created by Stig Brautaset on 24/3/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <SenTestingKit/SenTestingKit.h>
#import "SBLocation.h"

@interface SBLocationTest : SenTestCase {
    SBLocation *loc;
}
@end

@implementation SBLocationTest

- (void)setUp {
    loc = [SBLocation locationWithColumn:1 row:3];
}

- (void)testBasic {
    STAssertNotNil(loc, nil);
    
    STAssertEquals(loc.column, 1u, nil);
    STAssertEquals(loc.row, 3u, nil);
}

- (void)testEqual {
    STAssertEqualObjects(loc, loc, nil);

    SBLocation *b = [SBLocation locationWithColumn:loc.column row:loc.row];
    STAssertEqualObjects(loc, b, nil);
}

- (void)testHash {
    SBLocation *b = [SBLocation locationWithColumn:loc.column row:loc.row];
    STAssertEquals([loc hash], [b hash], nil);
}


- (void)testDescription {
    STAssertEqualObjects(@"b4", [loc description], nil);
}

- (void)testAsDictionary {
    SBLocation *loc2 = [SBLocation locationFromPropertyList:[loc toPropertyList]];
    STAssertEquals(loc2.column, loc.column, nil);
    STAssertEquals(loc2.row, loc.row, nil);
}

@end
