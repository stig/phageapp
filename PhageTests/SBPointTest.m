//
//  SBPointTest.m
//  Phage
//
//  Created by Stig Brautaset on 24/3/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "SBPointTest.h"
#import "SBPoint.h"

@implementation SBPointTest

- (void)testBasic {
    SBPoint *point = [[SBPoint alloc] initWithColumn:1 row:3];
    STAssertNotNil(point, nil);
    
    STAssertEquals(point.column, 1, nil);
    STAssertEquals(point.row, 3, nil);
}

- (void)testEqual {
    SBPoint *a = [[SBPoint alloc] initWithColumn:1 row:3];
    STAssertEqualObjects(a, a, nil);

    SBPoint *b = [[SBPoint alloc] initWithColumn:a.column row:a.row];
    STAssertEqualObjects(a, b, nil);
}

- (void)testHash {
    SBPoint *a = [[SBPoint alloc] initWithColumn:1 row:3];    
    SBPoint *b = [[SBPoint alloc] initWithColumn:a.column row:a.row];
    STAssertEquals([a hash], [b hash], nil);    
}


@end
