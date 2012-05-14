//
//  Created by s.brautaset@london.net-a-porter.com on 27/04/2012.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import <SenTestingKit/SenTestingKit.h>
#import <OCMock/OCMock.h>
#import "SBTurnBasedMatch.h"
#import "SBTurnBasedMatchHelper.h"
#import "SBTurnBasedParticipant.h"

@interface SBTurnBasedMatchHelperTest : SenTestCase {
    SBTurnBasedMatchHelper *helper;
    id delegate;
    id adapter;
    id match;
    id otherMatch;
    id participant;
    id otherParticipant;
}
@end

@implementation SBTurnBasedMatchHelperTest

- (void)setUp {
    delegate = [OCMockObject mockForProtocol:@protocol(SBTurnBasedMatchHelperDelegate)];
    adapter = [OCMockObject mockForProtocol:@protocol(SBTurnBasedMatchAdapter)];
    match = [OCMockObject mockForProtocol:@protocol(SBTurnBasedMatch)];
    otherMatch = [OCMockObject mockForProtocol:@protocol(SBTurnBasedMatch)];
    participant = [OCMockObject mockForProtocol:@protocol(SBTurnBasedParticipant)];
    otherParticipant = [OCMockObject mockForProtocol:@protocol(SBTurnBasedParticipant)];

    helper = [[SBTurnBasedMatchHelper alloc] init];
    helper.delegate = delegate;
    helper.adapter = adapter;

    BOOL yes = YES;
    BOOL no = NO;

    [[[match stub] andReturnValue:OCMOCK_VALUE(yes)] isEqual:match];
    [[[match stub] andReturnValue:OCMOCK_VALUE(no)] isEqual:otherMatch];
    [[[match stub] andReturn:participant] localParticipant];
}

- (void)tearDown {
    [delegate verify];
    [adapter verify];
    [match verify];
    [otherMatch verify];
    [participant verify];
    [otherParticipant verify];
}

#pragma mark handleMatchEnded:

- (void)testHandleMatchEnded_currentMatch {
    [helper setValue:match forKey:@"currentMatch"];
    [[delegate expect] receiveEndGame:match];
    [helper handleMatchEnded:match];
}

- (void)testHandleMatchEnded_notCurrentMatch {
    [helper setValue:otherMatch forKey:@"currentMatch"];
    [[delegate expect] sendTitle:@"Game Over!" notice:@"One of your other games has ended." forMatch:match];
    [helper handleMatchEnded:match];
}

#pragma mark handleTurnEventForMatch:

- (void)testHandleTurnEventForMatch_currentMatch_localPlayerTurn {
    [[[match stub] andReturn:participant] currentParticipant];
    [helper setValue:match forKey:@"currentMatch"];
    [[delegate expect] takeTurn:match];
    [helper handleTurnEventForMatch:match];
}

- (void)testHandleTurnEventForMatch_currentMatch_otherPlayerTurn {
    [[[match stub] andReturn:otherParticipant] currentParticipant];
    [helper setValue:match forKey:@"currentMatch"];
    [[delegate expect] layoutMatch:match];
    [helper handleTurnEventForMatch:match];
}

- (void)testHandleTurnEventForMatch_otherMatch_otherPlayerTurn {
    [[[match stub] andReturn:otherParticipant] currentParticipant];
    [helper setValue:otherMatch forKey:@"currentMatch"];
    [helper handleTurnEventForMatch:match];
}

- (void)testHandleTurnEventForMatch_otherMatch_localPlayerTurn {
    [[[match stub] andReturn:participant] currentParticipant];
    [helper setValue:otherMatch forKey:@"currentMatch"];
    [[delegate expect] sendTitle:@"Attention: Your Turn!" notice:@"It is now your turn in another game." forMatch:match];
    [helper handleTurnEventForMatch:match];
}

#pragma mark handleDidFindMatch:

- (void)testHandleDidFindMatch_nilMatchState {
    [[[match stub] andReturn:nil] matchState];
    [[delegate expect] enterNewGame:match];
    STAssertNil(helper.currentMatch, nil);

    [helper handleDidFindMatch:match];
    STAssertEquals(helper.currentMatch, match, nil);
}

- (void)testHandleDidFindMatch_localPlayerTurn {
    [[[match stub] andReturn:[NSNull null]] matchState];
    [[[match stub] andReturn:participant] currentParticipant];

    [[delegate expect] takeTurn:match];
    STAssertNil(helper.currentMatch, nil);

    [helper handleDidFindMatch:match];
    STAssertEquals(helper.currentMatch, match, nil);
}

- (void)testHandleDidFindMatch_otherPlayerTurn {
    [[[match stub] andReturn:[NSNull null]] matchState];
    [[[match stub] andReturn:otherParticipant] currentParticipant];

    [[delegate expect] layoutMatch:match];
    STAssertNil(helper.currentMatch, nil);

    [helper handleDidFindMatch:match];
    STAssertEquals(helper.currentMatch, match, nil);
}

#pragma mark handlePlayerQuitForMatch:

- (void)testHandlePlayerQuitForMatch {
    [[[delegate stub] andReturn:participant] nextParticipantForMatch:match];
    [[[match stub] andReturn:[NSNull null]] matchState];

    [[participant expect] setMatchOutcome:GKTurnBasedMatchOutcomeWon];

    [[match expect] participantQuitInTurnWithOutcome:GKTurnBasedMatchOutcomeLost
                                     nextParticipant:participant
                                          matchState:[NSNull null]
                                   completionHandler:[OCMArg any]];

    [helper handlePlayerQuitForMatch:match];

}

#pragma mark nextParticipantForMatch:

- (void)testNextParticipantForMatch {
    [[delegate expect] nextParticipantForMatch:match];
    [helper nextParticipantForMatch:match];
}

#pragma mark Adapter methods

- (void)testFindMatch {
    [[adapter expect] findMatch];
    [helper findMatch];
}

- (void)testIsLocalPlayerTurn_true {
    [[[match stub] andReturn:participant] currentParticipant];
    STAssertTrue([helper isLocalPlayerTurn:match], nil);
}

- (void)testIsLocalPlayerTurn_false {
    [[[match stub] andReturn:otherParticipant] currentParticipant];
    STAssertFalse([helper isLocalPlayerTurn:match], nil);
}

@end