//
//  SBStateTest.m
//  Phage
//
//  Created by Stig Brautaset on 25/3/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <SenTestingKit/SenTestingKit.h>
#import "SBState.h"
#import "SBLocation.h"
#import "SBCirclePiece.h"
#import "SBDiamondPiece.h"
#import "SBMove.h"

@interface SBStateTest : SenTestCase {
    SBState *s;
}
@end

@implementation SBStateTest


- (void)setUp {
    s = [SBState state];
}

- (void)testEquals {
    STAssertEqualObjects(s, s, nil);

    SBState *t = [SBState state];
    STAssertEqualObjects(s, t, nil);
}

- (void)testHash {
    SBState *t = [SBState state];
    STAssertEquals([s hash], [t hash], nil);
}

- (void)testDescription {
    NSArray *expected = [NSArray arrayWithObjects:
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
    [SBLocation locationWithColumn:1u row:4u],
    [s locationForPiece:[SBCirclePiece pieceWithOwner:0]],
    nil);

    STAssertEqualObjects(
    [SBLocation locationWithColumn:0u row:0u],
    [s locationForPiece:[SBDiamondPiece pieceWithOwner:1]],
    nil);
}

- (void)testPieces {
    STAssertEquals(s.pieces.count, 2u, nil);
    for (NSArray* pp in s.pieces) {
        STAssertEquals(pp.count, 4u, nil);
        for (SBPiece *p in pp) {
            STAssertEquals([s movesLeftForPiece:p], 7u, nil);
        }
    }
}

- (void)testLegalMoves {
    __block NSUInteger count = 0;
    [s enumerateLegalMovesWithBlock:^(SBMove *move, BOOL *stop) {
        count++;
    }];

    STAssertEquals(count, 61u, nil);
}


- (id)lastMoveForState:(SBState *)state {
    __block id lastMove = nil;
    [state enumerateLegalMovesWithBlock:^(SBMove *move, BOOL *stop) {
        lastMove = move;
    }];
    return lastMove;
}

- (void)testSuccessor {
    SBState *s1 = [s successorWithMove:[self lastMoveForState:s]];
    STAssertNotNil(s1, nil);
    STAssertFalse([s1 isEqual:s], nil);

    NSArray *expected = [NSArray arrayWithObjects:
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
    SBState *s1 = [s successorWithMove:[self lastMoveForState:s]];
    SBState *s2 = [s1 successorWithMove:[self lastMoveForState:s1]];

    NSArray *expected = [NSArray arrayWithObjects:
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

- (void)testIsGameOver {
    STAssertFalse([s isGameOver], nil);
    STAssertThrows([s isLoss], nil);
    STAssertThrows([s isDraw], nil);

    for (;;) {
        id move = [self lastMoveForState:s];
        if (!move)
            break;
        s = [s successorWithMove:move];
    }

    STAssertEquals(s.currentPlayer, 0u, nil);
    STAssertTrue([s isGameOver], nil);
    STAssertFalse([s isLoss], nil);
    STAssertTrue([s isDraw], nil);
}

@end
