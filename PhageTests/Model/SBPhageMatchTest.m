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

@interface SBPhageMatchTest : SenTestCase {
    SBPhageMatch *match;
    id board;
    id one;
    id two;
}
@end

@implementation SBPhageMatchTest

- (void)setUp {
    one = [OCMockObject mockForProtocol:@protocol(SBPlayer)];
    two = [OCMockObject mockForProtocol:@protocol(SBPlayer)];
    board = [OCMockObject mockForClass:[SBPhageBoard class]];
    match = [SBPhageMatch matchWithPlayerOne:one two:two board:board];
}

- (void)tearDown {
    [one verify];
    [two verify];
    [board verify];
}

- (void)testPlayers {
    STAssertEqualObjects([match.players objectAtIndex:0], one, nil);
    STAssertEqualObjects([match.players objectAtIndex:1], two, nil);
}

- (void)testInit {
    STAssertNotNil(match, nil);
}

- (void)testCurrentPlayer {
    NSUInteger playerIndex = 0;
    [[[board stub] andReturnValue:OCMOCK_VALUE(playerIndex)] currentPlayerIndex];
    STAssertEqualObjects(match.currentPlayer, one, nil);
}

- (void)testCurrentPlayerAfterOneMove {
    NSUInteger playerIndex = 1;
    [[[board stub] andReturnValue:OCMOCK_VALUE(playerIndex)] currentPlayerIndex];
    STAssertEqualObjects(match.currentPlayer, two, nil);
}

- (void)testIsLegalMove {
    id move = [OCMockObject mockForClass:[SBMove class]];
    [[board expect] isLegalMove:move];
    [match isLegalMove:move];
}

- (void)testIsGameOver_true {
    BOOL yes = YES;
    [[[board stub] andReturnValue:OCMOCK_VALUE(yes)] isGameOver];
    STAssertTrue([match isGameOver], nil);
}

- (void)testIsGameOver_false {
    BOOL no = NO;
    [[[board stub] andReturnValue:OCMOCK_VALUE(no)] isGameOver];
    STAssertFalse([match isGameOver], nil);
}

- (void)testWinner_one {
    BOOL no = NO;
    NSUInteger otherPlayerIndex = 0;
    [[[board stub] andReturnValue:OCMOCK_VALUE(otherPlayerIndex)] otherPlayerIndex];
    [[[board stub] andReturnValue:OCMOCK_VALUE(no)] isDraw];
    STAssertEqualObjects([match winner], one, nil);
}

- (void)testWinner_two {
    BOOL no = NO;
    NSUInteger otherPlayerIndex = 1;
    [[[board stub] andReturnValue:OCMOCK_VALUE(otherPlayerIndex)] otherPlayerIndex];
    [[[board stub] andReturnValue:OCMOCK_VALUE(no)] isDraw];
    STAssertEqualObjects([match winner], two, nil);
}

- (void)testWinner_draw {
    BOOL yes = YES;
    [[[board stub] andReturnValue:OCMOCK_VALUE(yes)] isDraw];
    STAssertNil([match winner], nil);
}

- (void)testPerformMove {
    id move = [OCMockObject mockForClass:[SBMove class]];
    id successor = [OCMockObject mockForClass:[SBPhageBoard class]];
    [[[board stub] andReturn:successor] successorWithMove:move];

    [match performMove:move];
    STAssertEqualObjects(match.board, successor, nil);
}

- (void)testCanCurrentPlayerMovePiece_false {
    // Can't figure out how to do this with a mocked board; create a new match using a real board
    match = [SBPhageMatch matchWithPlayerOne:one two:two];

    // get one of the opponent's pieces
    id piece = [[match.board.pieces objectAtIndex:1] objectAtIndex:0];

    STAssertFalse([match canCurrentPlayerMovePiece:piece], nil);
}

- (void)testCanCurrentPlayerMovePiece_true {
    // Can't figure out how to do this with a mocked board; create a new match using a real board
    match = [SBPhageMatch matchWithPlayerOne:one two:two];

    // Get one of our own pieces
    id piece = [[match.board.pieces objectAtIndex:0] objectAtIndex:0];

    STAssertTrue([match canCurrentPlayerMovePiece:piece], nil);
}

@end