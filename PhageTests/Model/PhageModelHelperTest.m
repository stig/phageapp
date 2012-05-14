//
//  Created by stig@brautaset.rog on 11/05/2012.
//


#import <SenTestingKit/SenTestingKit.h>
#import <OCMock/OCMock.h>
#import "SBTurnBasedMatch.h"
#import "PhageModelHelper.h"
#import "SBState.h"

@interface PhageModelHelperTest : SenTestCase {
    PhageModelHelper *helper;
    id match;
    id successor;
    id participant;
    id otherParticipant;
    BOOL yes, no;
}
@end

@implementation PhageModelHelperTest

- (void)setUp {
    helper = [[PhageModelHelper alloc] init];
    participant = [OCMockObject mockForProtocol:@protocol(SBTurnBasedParticipant)];
    otherParticipant = [OCMockObject mockForProtocol:@protocol(SBTurnBasedParticipant)];

    match = [OCMockObject mockForProtocol:@protocol(SBTurnBasedMatch)];
    successor = [OCMockObject mockForClass:[SBState class]];

    yes = YES;
    no = NO;
    [[[participant stub] andReturnValue:OCMOCK_VALUE(yes)] isEqual:participant];
    [[[participant stub] andReturnValue:OCMOCK_VALUE(no)] isEqual:otherParticipant];

    [[[match stub] andReturn:participant] currentParticipant];
    [[[match stub] andReturn:[NSArray arrayWithObjects:participant, otherParticipant, nil]] participants];
}

- (void)tearDown {
    [match verify];
    [successor verify];
}

#pragma mark handleMatchEnded:

- (void)testNextParticipantForMatch {
    id next = [helper nextParticipantForMatch:match];
    STAssertEquals(next, otherParticipant, nil);
}

- (void)testEndTurnOrMatchWithMatchState_isDraw {
    [[[successor stub] andReturnValue:OCMOCK_VALUE(yes)] isGameOver];
    [[[successor stub] andReturnValue:OCMOCK_VALUE(yes)] isDraw];

    [[participant expect] setMatchOutcome:GKTurnBasedMatchOutcomeTied];
    [[otherParticipant expect] setMatchOutcome:GKTurnBasedMatchOutcomeTied];
    [[match expect] endMatchInTurnWithMatchState:successor completionHandler:[OCMArg any]];

    [helper endTurnOrMatch:match withMatchState:successor];
}

- (void)testEndTurnOrMatchWithMatchState_isLoss {
    [[[successor stub] andReturnValue:OCMOCK_VALUE(yes)] isGameOver];
    [[[successor stub] andReturnValue:OCMOCK_VALUE(no)] isDraw];
    [[[successor stub] andReturnValue:OCMOCK_VALUE(yes)] isLoss];

    // This might look backwards (it tricked stigbra a while) but if the state is
    // a loss for the _opponent at the successor state_ then it is a win for the _current_ player.
    [[participant expect] setMatchOutcome:GKTurnBasedMatchOutcomeWon];
    [[otherParticipant expect] setMatchOutcome:GKTurnBasedMatchOutcomeLost];
    [[match expect] endMatchInTurnWithMatchState:successor completionHandler:[OCMArg any]];

    [helper endTurnOrMatch:match withMatchState:successor];
}

- (void)testEndTurnOrMatchWithMatchState_notGameOver {
    [[[successor stub] andReturnValue:OCMOCK_VALUE(no)] isGameOver];

    [[match expect] endTurnWithNextParticipant:otherParticipant matchState:successor completionHandler:[OCMArg any]];

    [helper endTurnOrMatch:match withMatchState:successor];
}

@end