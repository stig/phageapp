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

@end