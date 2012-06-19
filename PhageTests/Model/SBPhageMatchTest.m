//
// Created by SuperPappi on 19/06/2012.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import <SenTestingKit/SenTestingKit.h>
#import <OCMock/OCMock.h>
#import "SBPhageMatch.h"
#import "SBPlayer.h"
#import "SBPhageBoard.h"
#import "SBMove.h"
#import "SBLocation.h"

@interface SBPhageMatchTest : SenTestCase {
    SBPhageMatch *match;
    id one;
    id two;
}
@end

@implementation SBPhageMatchTest

- (void)setUp {
    one = [OCMockObject mockForProtocol:@protocol(SBPlayer)];
    two = [OCMockObject mockForProtocol:@protocol(SBPlayer)];
    match = [SBPhageMatch matchWithPlayerOne:one two:two];
}

- (void)testInit {
    STAssertNotNil(match, nil);
    STAssertEqualObjects(match.currentPlayer, one, nil);
    STAssertEqualObjects(match.board, [SBPhageBoard board], nil);
    STAssertEqualObjects([match.players objectAtIndex:0], one, nil);
    STAssertEqualObjects([match.players objectAtIndex:1], two, nil);
}

- (void)testInitWithMoveHistory {
    SBLocation *from = [SBLocation locationWithColumn:1 row:4];
    SBLocation *to = [SBLocation locationWithColumn:1 row:5];
    NSArray *history = [NSArray arrayWithObject:[SBMove moveWithFrom:from to:to]];
    match = [SBPhageMatch matchWithPlayerOne:one two:two moveHistory:history];
    STAssertNotNil(match, nil);

    STAssertEqualObjects(match.currentPlayer, two, nil);
    STAssertEqualObjects(match.board.moveHistory, history, nil);
}

- (void)testIsLegalMove {
    [match.board enumerateLegalMovesWithBlock:^void(SBMove *move, BOOL *stop) {
        STAssertTrue([match isLegalMove:move], nil);
    }];
}

- (id)lastMoveForState:(SBPhageBoard *)state {
    __block id lastMove = nil;
    [state enumerateLegalMovesWithBlock:^(SBMove *move, BOOL *stop) {
        lastMove = move;
    }];
    return lastMove;
}

- (id)firstMoveForState:(SBPhageBoard *)state {
    __block id firstMove = nil;
    [state enumerateLegalMovesWithBlock:^(SBMove *move, BOOL *stop) {
        firstMove = move;
        *stop = YES;
    }];
    return firstMove;
}

- (void)testIsGameOver_draw {
    STAssertFalse([match isGameOver], nil);

    for (;;) {
        id move = [self lastMoveForState:match.board];
        if (!move)
            break;
        [match transitionToSuccessorWithMove:move];
    }

    STAssertTrue([match isGameOver], nil);
    STAssertNil([match winner], nil);
}

- (void)testIsGameOver_winner {
    STAssertFalse([match isGameOver], nil);

    for (;;) {
        id move = [self firstMoveForState:match.board];
        if (!move)
            break;
        [match transitionToSuccessorWithMove:move];
    }

    STAssertTrue([match isGameOver], nil);
    STAssertEqualObjects([match winner], two, nil);
}



@end