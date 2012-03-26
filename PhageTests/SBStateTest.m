//
//  SBStateTest.m
//  Phage
//
//  Created by Stig Brautaset on 25/3/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "SBStateTest.h"
#import "SBSTate.h"
#import "SBLocation.h"
#import "SBCirclePiece.h"
#import "SBDiamondPiece.h"

@implementation SBStateTest

static SBState *s;

- (void)setUp {
    s = [[SBState alloc] init];
}

- (void)testDescription {
    NSArray *expected = [[NSArray alloc] initWithObjects:
            @"PlayerTurn: North",
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

- (void)testLocationForPiece {
    STAssertEqualObjects(
    [[SBLocation alloc] initWithColumn:1u row:4u],
    [s locationForPiece:[[SBCirclePiece alloc] init]],
    nil);

    STAssertEqualObjects(
    [[SBLocation alloc] initWithColumn:0u row:0u],
    [s locationForPiece:[[SBDiamondPiece alloc] initWithOwner:SOUTH]],
    nil);
}

- (void)testNorthPieces {
    STAssertEquals(s.north.count, 4u, nil);
    for (id p in s.north) {
        STAssertEquals([s movesLeftForPiece:p], 7u, nil);
    }
}

- (void)testSouthPieces {
    STAssertEquals(s.south.count, 4u, nil);
    for (id p in s.south) {
        STAssertEquals([s movesLeftForPiece:p], 7u, nil);
    }
}


@end
