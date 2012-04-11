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
#import "SBMove.h"

@implementation SBStateTest

static SBState *s;

- (void)setUp {
    s = [[SBState alloc] init];
}

- (void)testEquals {
    STAssertEqualObjects(s, s, nil);

    SBState *t = [[SBState alloc] init];
    STAssertEqualObjects(s, t, nil);
}

- (void)testHash {
    SBState *t = [[SBState alloc] init];
    STAssertEquals([s hash], [t hash], nil);
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

- (void)testLocationForPiece {
    STAssertEqualObjects(
    [[SBLocation alloc] initWithColumn:1u row:4u],
    [s locationForPiece:[[SBCirclePiece alloc] init]],
    nil);

    STAssertEqualObjects(
    [[SBLocation alloc] initWithColumn:0u row:0u],
    [s locationForPiece:[[SBDiamondPiece alloc] initWithPlayer:SBPlayerSouth]],
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

- (void)testLegalMoves {
    NSArray *moves = [s legalMovesForPlayer:SBPlayerNorth];
    STAssertEquals(moves.count, 61u, nil);
}

- (void)testSuccessor {
    NSArray *moves = [s legalMovesForPlayer:SBPlayerNorth];
    SBState *s1 = [s successorWithMove:[moves lastObject]];
    STAssertNotNil(s1, nil);
    STAssertFalse([s1 isEqual:s], nil);

    NSArray *expected = [[NSArray alloc] initWithObjects:
            @"C: 7",
            @"S: 7",
            @"T: 7",
            @"D: 6",
            @".......*",
            @".....T..",
            @"...S....",
            @".C......",
            @"......c.",
            @"....s...",
            @"..t.....",
            @"d......D",
            @"c: 7",
            @"s: 7",
            @"t: 7",
            @"d: 7",
            @"",
            nil];

    STAssertEqualObjects([s1 description], [expected componentsJoinedByString:@"\n"], nil);
}

- (void)testSuccessor2 {
    SBState *s1 = [s successorWithMove:[[s legalMovesForPlayer:SBPlayerNorth] lastObject]];
    SBState *s2 = [s1 successorWithMove:[[s1 legalMovesForPlayer:SBPlayerSouth] lastObject]];

    NSArray *expected = [[NSArray alloc] initWithObjects:
            @"C: 7",
            @"S: 7",
            @"T: 7",
            @"D: 6",
            @"d......*",
            @".....T..",
            @"...S....",
            @".C......",
            @"......c.",
            @"....s...",
            @"..t.....",
            @"*......D",
            @"c: 7",
            @"s: 7",
            @"t: 7",
            @"d: 6",
            @"",
            nil];

    STAssertEqualObjects([s2 description], [expected componentsJoinedByString:@"\n"], nil);
}

- (void)testCoding {
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:s];
    SBState *s1 = [NSKeyedUnarchiver unarchiveObjectWithData:data];
    STAssertEqualObjects(s1, s, nil);
}

- (void)testCodingSize {

    SBPlayer player = SBPlayerNorth;
    for (;;) {
        NSData *data = [NSKeyedArchiver archivedDataWithRootObject:s];
        STAssertTrue(data.length < 3096u, @"Serialised state is less than 3K");

        SBMove *move = [[s legalMovesForPlayer:player] lastObject];
        if (!move)
            break;

        player = SBPlayerNorth == player ? SBPlayerSouth : SBPlayerNorth;
        s = [s successorWithMove:move];
    }
}

@end
