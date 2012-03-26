//
//  SBStateTest.m
//  Phage
//
//  Created by Stig Brautaset on 25/3/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "SBStateTest.h"
#import "SBSTate.h"

@implementation SBStateTest

static SBState *s;

- (void)setUp {
    s = [[SBState alloc] init];
}

- (void)testDescription {
    NSArray *expected = [[NSArray alloc] initWithObjects:
                         @"C: 7",
                         @"S: 7",
                         @"T: 7",
                         @"D: 7",
                         @".......D",
                         @".....T..",
                         @"...S....",
                         @".C......",
                         @"......c.",
                         @"....s...",
                         @"..t.....",
                         @"d.......",
                         @"c: 7",
                         @"s: 7",
                         @"t: 7",
                         @"d: 7",
                         @"",
                         nil];

    STAssertEqualObjects([s description], [expected componentsJoinedByString:@"\n"], nil);
}

- (void)testNorthPieces {
    STAssertEquals(s.north.count, 4u, nil);
    for (id p in s.north) {
        STAssertEquals([s movesLeft:p], 7u, nil);
    }
}

- (void)testSouthPieces {
    STAssertEquals(s.south.count, 4u, nil);
    for (id p in s.south) {
        STAssertEquals([s movesLeft:p], 7u, nil);
    }
}



@end
