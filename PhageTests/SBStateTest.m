//
//  SBStateTest.m
//  Phage
//
//  Created by Stig Brautaset on 25/3/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "SBStateTest.h"
#import "SBState.h"
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
    [s locationForPiece:[[SBDiamondPiece alloc] initWithPlayerOne:NO]],
    nil);
}

- (void)testNorthPieces {
    STAssertEquals(s.playerOnePieces.count, 4u, nil);
    for (id p in s.playerOnePieces) {
        STAssertEquals([s movesLeftForPiece:p], 7u, nil);
    }
}

- (void)testSouthPieces {
    STAssertEquals(s.playerTwoPieces.count, 4u, nil);
    for (id p in s.playerTwoPieces) {
        STAssertEquals([s movesLeftForPiece:p], 7u, nil);
    }
}

- (void)testLegalMoves {
    NSArray *moves = [s legalMoves];
    STAssertEquals(moves.count, 61u, nil);
}

- (void)testSuccessor {
    NSArray *moves = [s legalMoves];
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
    SBState *s1 = [s successorWithMove:[[s legalMoves] lastObject]];
    SBState *s2 = [s1 successorWithMove:[[s1 legalMoves] lastObject]];

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
    BOOL player = YES;
    for (;;) {
        NSData *data = [NSKeyedArchiver archivedDataWithRootObject:s];
        STAssertTrue(data.length < 3096u, @"Serialised state is less than 3K");

        SBMove *move = [[s legalMoves] lastObject];
        if (!move)
            break;

        player = YES == player ? NO : YES;
        s = [s successorWithMove:move];
    }
}

- (void)testIsGameOver {
    STAssertFalse([s isGameOver], nil);
    STAssertThrows([s isLoss], nil);
    STAssertThrows([s isDraw], nil);

    for (;;) {
        NSArray *moves = [s legalMoves];
        if (!moves.count)
            break;
        s = [s successorWithMove:[moves lastObject]];
    }

    STAssertTrue(s.isPlayerOne, nil);
    STAssertTrue([s isGameOver], nil);
    STAssertFalse([s isLoss], nil);
    STAssertTrue([s isDraw], nil);
}

@end
