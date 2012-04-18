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
#import "SBPlayer.h"

@implementation SBStateTest

static SBState *s;
static SBPlayer *SBPlayerNorth;
static SBPlayer *SBPlayerSouth;

- (void)setUp {
    s = [[SBState alloc] init];
    SBPlayerNorth = [[SBPlayer alloc] init];
    SBPlayerSouth = [SBPlayerNorth opponent];
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
    SBPlayer *player = SBPlayerNorth;
    for (;;) {
        NSData *data = [NSKeyedArchiver archivedDataWithRootObject:s];
        STAssertTrue(data.length < 3096u, @"Serialised state is less than 3K");

        SBMove *move = [[s legalMoves] lastObject];
        if (!move)
            break;

        player = SBPlayerNorth == player ? SBPlayerSouth : SBPlayerNorth;
        s = [s successorWithMove:move];
    }
}

- (void)testIsGameOver {
    STAssertFalse([s isGameOver], nil);

    SBPlayer *player = s.player;
    while (![s isGameOver]) {
        SBMove *m = [[s legalMoves] lastObject];
        s = [s successorWithMove:m];
        player = [player opponent];
    }
    
    STAssertTrue([s isGameOver], nil);
}

- (void)testIsWin {
    STAssertFalse([s isWin], nil);
    s = [s successorWithMove:[[s legalMoves] lastObject]];
    STAssertFalse([s isWin], nil);

}

- (void)testIsDraw {
    STAssertTrue([s isDraw], nil);
    s = [s successorWithMove:[[s legalMoves] lastObject]];
    STAssertFalse([s isDraw], nil);
}

@end
