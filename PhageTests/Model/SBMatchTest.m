//
// Created by SuperPappi on 19/06/2012.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import <SenTestingKit/SenTestingKit.h>
#import <OCMock/OCMock.h>
#import "SBMatch.h"
#import "SBPlayer.h"
#import "SBBoard.h"
#import "SBMove.h"

@interface SBMatchTest : SenTestCase {
    SBMatch *match;
    id board;
    id one;
    id two;
}
@end

@implementation SBMatchTest

- (void)setUp {
    one = [OCMockObject mockForProtocol:@protocol(SBPlayer)];
    two = [OCMockObject mockForProtocol:@protocol(SBPlayer)];
    board = [OCMockObject mockForClass:[SBBoard class]];
    match = [SBMatch matchWithPlayerOne:one two:two board:board];
}

- (void)tearDown {
    [one verify];
    [two verify];
    [board verify];
}

- (void)testPlayers {
    STAssertEqualObjects(match.playerOne, one, nil);
    STAssertEqualObjects(match.playerTwo, two, nil);
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
    SBPlayerOutcome lost = SBPlayerOutcomeLost;

    [[[one expect] andReturnValue:OCMOCK_VALUE(lost)] outcome];
    STAssertTrue([match isGameOver], nil);
}

- (void)testIsGameOver_false {
    SBPlayerOutcome none = SBPlayerOutcomeNone;
    [[[one expect] andReturnValue:OCMOCK_VALUE(none)] outcome];
    [[[two expect] andReturnValue:OCMOCK_VALUE(none)] outcome];
    STAssertFalse([match isGameOver], nil);
}

- (void)testWinner_one {
    SBPlayerOutcome won = SBPlayerOutcomeWon;
    [[[one expect] andReturnValue:OCMOCK_VALUE(won)] outcome];
    STAssertEqualObjects([match winner], one, nil);
}

- (void)testWinner_two {
    SBPlayerOutcome lost = SBPlayerOutcomeLost;
    [[[one expect] andReturnValue:OCMOCK_VALUE(lost)] outcome];
    SBPlayerOutcome won = SBPlayerOutcomeWon;
    [[[two expect] andReturnValue:OCMOCK_VALUE(won)] outcome];
    STAssertEqualObjects([match winner], two, nil);
}

- (void)testWinner_draw {
    SBPlayerOutcome tied = SBPlayerOutcomeTied;
    [[[one expect] andReturnValue:OCMOCK_VALUE(tied)] outcome];
    [[[two expect] andReturnValue:OCMOCK_VALUE(tied)] outcome];
    STAssertNil([match winner], nil);
}

- (void)testPerformMove {
    id move = [OCMockObject mockForClass:[SBMove class]];
    id successor = [OCMockObject niceMockForClass:[SBBoard class]];
    [[[board stub] andReturn:successor] successorWithMove:move];

    BOOL yes = YES;
    [[[board expect] andReturnValue:OCMOCK_VALUE(yes)] isLegalMove:move];

    [match performMove:move completionHandler:nil];

    STAssertEqualObjects(match.board, successor, nil);
}

- (void)testPerformMoveRunsCompletionHandler {
    id move = [OCMockObject mockForClass:[SBMove class]];
    id successor = [OCMockObject niceMockForClass:[SBBoard class]];
    [[[board stub] andReturn:successor] successorWithMove:move];

    BOOL yes = YES;
    [[[board expect] andReturnValue:OCMOCK_VALUE(yes)] isLegalMove:move];

    __block BOOL ranHandler = NO;
    [match performMove:move completionHandler:^(NSError *error) {
        ranHandler = YES;
        STAssertNil(error, nil);
    }];

    STAssertTrue(ranHandler, nil);
}

- (void)testPerformMoveRunsCompletionHandler_error {
    id move = [OCMockObject mockForClass:[SBMove class]];
    id successor = [OCMockObject niceMockForClass:[SBBoard class]];
    [[[board stub] andReturn:successor] successorWithMove:move];

    BOOL no = NO;
    [[[board expect] andReturnValue:OCMOCK_VALUE(no)] isLegalMove:move];

    __block BOOL ranHandler = NO;
    [match performMove:move completionHandler:^(NSError *error) {
        ranHandler = YES;
        STAssertNotNil(error, nil);
    }];

    STAssertTrue(ranHandler, nil);
}

- (void)testPerformMoveSetsLastUpdated {
    id move = [OCMockObject mockForClass:[SBMove class]];
    id successor = [OCMockObject niceMockForClass:[SBBoard class]];
    [[[board stub] andReturn:successor] successorWithMove:move];

    STAssertNil(match.lastUpdated, nil);

    BOOL yes = YES;
    [[[board expect] andReturnValue:OCMOCK_VALUE(yes)] isLegalMove:move];

    [match performMove:move completionHandler:nil];

    STAssertEqualsWithAccuracy([match.lastUpdated timeIntervalSinceNow], 0.0, 1.0, nil);
}

- (void)testPerformMoveDoesNotSetPlayerOutcomeWhenGameNotOver {
    id move = [OCMockObject mockForClass:[SBMove class]];
    id successor = [OCMockObject niceMockForClass:[SBBoard class]];
    [[[successor stub] andReturn:successor] successorWithMove:move];
    [[[board stub] andReturn:successor] successorWithMove:move];

    BOOL yes = YES;
    [[[board expect] andReturnValue:OCMOCK_VALUE(yes)] isLegalMove:move];

    [match performMove:move completionHandler:nil];

    // -tearDown verifies no interactions on players..
}

- (void)testPerformMoveSetsPlayerOutcomeWhenGameOver {
    BOOL no = NO;
    BOOL yes = YES;
    NSUInteger index = 0;

    id successor = [OCMockObject mockForClass:[SBBoard class]];
    [[[successor expect] andReturnValue:OCMOCK_VALUE(yes)] isGameOver];
    [[[successor expect] andReturnValue:OCMOCK_VALUE(index)] currentPlayerIndex];
    [[[successor expect] andReturnValue:OCMOCK_VALUE(index)] currentPlayerIndex];
    [[[successor expect] andReturnValue:OCMOCK_VALUE(no)] isDraw];

    id move = [OCMockObject mockForClass:[SBMove class]];
    [[[board stub] andReturn:successor] successorWithMove:move];

    [[one expect] setOutcome:SBPlayerOutcomeLost];
    [[two expect] setOutcome:SBPlayerOutcomeWon];

    [[[board expect] andReturnValue:OCMOCK_VALUE(yes)] isLegalMove:move];

    [match performMove:move completionHandler:nil];
}

- (void)testPerformMoveSetsPlayerOutcomeTiedWhenGameOver {
    BOOL yes = YES;
    NSUInteger index = 0;

    id successor = [OCMockObject mockForClass:[SBBoard class]];
    [[[successor expect] andReturnValue:OCMOCK_VALUE(yes)] isGameOver];
    [[[successor expect] andReturnValue:OCMOCK_VALUE(index)] currentPlayerIndex];
    [[[successor expect] andReturnValue:OCMOCK_VALUE(index)] currentPlayerIndex];
    [[[successor expect] andReturnValue:OCMOCK_VALUE(yes)] isDraw];

    id move = [OCMockObject mockForClass:[SBMove class]];
    [[[board stub] andReturn:successor] successorWithMove:move];

    [[one expect] setOutcome:SBPlayerOutcomeTied];
    [[two expect] setOutcome:SBPlayerOutcomeTied];

    [[[board expect] andReturnValue:OCMOCK_VALUE(yes)] isLegalMove:move];

    [match performMove:move completionHandler:nil];
}

- (void)testForfeit {
    NSUInteger index = 0;
    [[[board expect] andReturnValue:OCMOCK_VALUE(index)] currentPlayerIndex];
    [[[board expect] andReturnValue:OCMOCK_VALUE(index)] currentPlayerIndex];
    [[one expect] setOutcome:SBPlayerOutcomeQuit];
    [[two expect] setOutcome:SBPlayerOutcomeWon];

    STAssertNil(match.lastUpdated, nil);

    [match forfeit];

    STAssertEqualsWithAccuracy([match.lastUpdated timeIntervalSinceNow], 0.0, 1.0, nil);
}


- (void)testCanCurrentPlayerMovePiece_false {
    // Can't figure out how to do this with a mocked board; create a new match using a real board
    match = [SBMatch matchWithPlayerOne:one two:two];

    // get one of the opponent's pieces
    id piece = [[match.board.pieces objectAtIndex:1] objectAtIndex:0];

    STAssertFalse([match canCurrentPlayerMovePiece:piece], nil);
}

- (void)testCanCurrentPlayerMovePiece_true {
    // Can't figure out how to do this with a mocked board; create a new match using a real board
    match = [SBMatch matchWithPlayerOne:one two:two];

    // Get one of our own pieces
    id piece = [[match.board.pieces objectAtIndex:0] objectAtIndex:0];

    STAssertTrue([match canCurrentPlayerMovePiece:piece], nil);
}

@end