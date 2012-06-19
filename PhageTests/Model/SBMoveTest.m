//
//  SBMoveTest.m
//  Phage
//
//  Created by Stig Brautaset on 24/3/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <SenTestingKit/SenTestingKit.h>
#import "SBLocation.h"
#import "SBMove.h"
#import "SBCircle.h"

@interface SBMoveTest : SenTestCase {
    SBLocation *a;
    SBLocation *b;
    SBMove *m;
}
@end


@implementation SBMoveTest

- (void)setUp {
    a = [SBLocation locationWithColumn:1 row:4];
    b = [SBLocation locationWithColumn:2 row:4];
    m = [SBMove moveWithFrom:a to:b];
}

- (void)testBasic {
    STAssertNotNil(m, nil);

    STAssertEqualObjects(m.from, a, nil);
    STAssertEqualObjects(m.to, b, nil);
}

- (void)testEqual {
    STAssertEqualObjects(m, m, nil);

    SBMove *g = [SBMove moveWithFrom:a to:b];
    STAssertEqualObjects(m, g, nil);
}

- (void)testHash {
    SBMove *g = [SBMove moveWithFrom:a to:b];
    STAssertEquals([m hash], [g hash], nil);
}


@end
