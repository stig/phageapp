//
//  SBStateTest.m
//  Phage
//
//  Created by Stig Brautaset on 25/3/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <SenTestingKit/SenTestingKit.h>
#import "SBBoard.h"
#import "SBLocation.h"
#import "SBCircle.h"
#import "SBDiamond.h"
#import "SBMove.h"

@interface SBBoardTest : SenTestCase {
    SBBoard *s;
}
@end

@implementation SBBoardTest


- (void)setUp {
    s = [SBBoard board];
}

- (void)testEquals {
    STAssertEqualObjects(s, s, nil);

    SBBoard *t = [SBBoard board];
    STAssertEqualObjects(s, t, nil);
}

- (void)testHash {
    SBBoard *t = [SBBoard board];
    STAssertEquals([s hash], [t hash], nil);
}

- (void)testDescription {
    NSArray *expected = @[@"C:7 S:7 T:7 D:7 ",
            @"c:7 s:7 t:7 d:7 ",
            @".......D",
            @".....T..",
            @"...S....",
            @".C......",
            @"......c.",
            @"....s...",
            @"..t.....",
            @"d.......",
            @""];

    STAssertEqualObjects([s description], [expected componentsJoinedByString:@"\n"], nil);
}

- (void)testLocationForPiece {
    STAssertEqualObjects(
    [SBLocation locationWithColumn:1u row:4u],
    [s locationForPiece:[SBCircle pieceWithOwner:0]],
    nil);

    STAssertEqualObjects(
    [SBLocation locationWithColumn:0u row:0u],
    [s locationForPiece:[SBDiamond pieceWithOwner:1]],
    nil);
}

- (void)testPieces {
    STAssertEquals(s.pieces.count, 2u, nil);
    for (NSArray* pp in s.pieces) {
        STAssertEquals(pp.count, 4u, nil);
        for (SBPiece *p in pp) {
            STAssertEqualObjects([s turnsLeftForPiece:p], @7u, nil);
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


- (id)lastMoveForState:(SBBoard *)state {
    __block id lastMove = nil;
    [state enumerateLegalMovesWithBlock:^(SBMove *move, BOOL *stop) {
        lastMove = move;
    }];
    return lastMove;
}

- (void)testSuccessor {
    SBBoard *s1 = [s successorWithMove:[self lastMoveForState:s]];
    STAssertNotNil(s1, nil);
    STAssertFalse([s1 isEqual:s], nil);

    NSArray *expected = @[@"C:7 S:7 T:7 D:6 ",
            @"c:7 s:7 t:7 d:7 ",
            @".......*",
            @".....T..",
            @"...S....",
            @".C......",
            @"......c.",
            @"....s...",
            @"..t.....",
            @"d......D",
            @""];

    STAssertEqualObjects([s1 description], [expected componentsJoinedByString:@"\n"], nil);
}

- (void)testSuccessor2 {
    SBBoard *s1 = [s successorWithMove:[self lastMoveForState:s]];
    SBBoard *s2 = [s1 successorWithMove:[self lastMoveForState:s1]];

    NSArray *expected = @[@"C:7 S:7 T:7 D:6 ",
            @"c:7 s:7 t:7 d:6 ",
            @"d......*",
            @".....T..",
            @"...S....",
            @".C......",
            @"......c.",
            @"....s...",
            @"..t.....",
            @"*......D",
            @""];

    STAssertEqualObjects([s2 description], [expected componentsJoinedByString:@"\n"], nil);
}

- (void)testCoding {
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:s.moveHistory];
    SBBoard *s1 = [SBBoard boardWithMoveHistory:[NSKeyedUnarchiver unarchiveObjectWithData:data]];
    STAssertEqualObjects(s1, s, nil);
}

- (void)testCodingSize {
    for (;;) {
        NSData *data = [NSJSONSerialization dataWithJSONObject:[s toPropertyList]
                                                       options:0
                                                         error:nil];
        STAssertTrue(data.length < 1024u, @"Serialised move history is less than 1K");

        NSArray *moves = [NSJSONSerialization JSONObjectWithData:data
                                                         options:0
                                                           error:nil];

        SBBoard *copy = [SBBoard boardFromPropertyList:moves];

        STAssertEqualObjects(copy, s, nil);

        SBMove *move = [self lastMoveForState:s];
        if (!move)
            break;

        s = [s successorWithMove:move];
    }
}

@end
