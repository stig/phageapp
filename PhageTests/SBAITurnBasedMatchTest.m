//
//  Created by s.brautaset@london.net-a-porter.com on 27/04/2012.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import <SenTestingKit/SenTestingKit.h>
#import <OCMock/OCMock.h>
#import "SBAITurnBasedMatch.h"
#import "SBTurnBasedParticipant.h"

@interface SBAITurnBasedMatchTest : SenTestCase {
    SBAITurnBasedMatch *match;
    id participant;
    id otherParticipant;
    id delegate;
}
@end

@implementation SBAITurnBasedMatchTest

- (void)setUp {
    delegate = [OCMockObject mockForProtocol:@protocol(SBTurnBasedMatchAdapterDelegate)];
    participant = [OCMockObject mockForProtocol:@protocol(SBTurnBasedParticipant)];
    otherParticipant = [OCMockObject mockForProtocol:@protocol(SBTurnBasedParticipant)];

    match = [[SBAITurnBasedMatch alloc] init];
    match.delegate = delegate;
    match.participants = [NSArray arrayWithObjects:participant, otherParticipant, nil];
}

- (void)testNotNil {
    STAssertNotNil(match, nil);
}

- (void)testDelegateNotNil {
    STAssertNotNil(match.delegate, nil);
}

- (void)testParticipants {
    STAssertNotNil(match.participants, nil);
    STAssertEquals(match.participants.count, 2u, nil);
    STAssertEquals([match.participants objectAtIndex:0], participant, nil);
    STAssertEquals([match.participants lastObject], otherParticipant, nil);
}

- (void)testCurrentParticipant {
    STAssertEquals(match.currentParticipant, participant, nil);
}

- (void)testEndTurnWithNextParticipant {
    [[delegate expect] handleTurnEventForMatch:match];

    __block BOOL completionHandlerWasCalled = NO;
    [match endTurnWithNextParticipant:otherParticipant matchState:@"FOOBAR" completionHandler:^(NSError *error) {
        completionHandlerWasCalled = YES;
    }];

    STAssertTrue(completionHandlerWasCalled, nil);
    STAssertEqualObjects(match.currentParticipant, otherParticipant, nil);
    STAssertEqualObjects(match.matchState, @"FOOBAR", nil);
}

- (void)testEndMatchInTurnWithMatchState {
    [[delegate expect] handleMatchEnded:match];

    __block BOOL completionHandlerWasCalled = NO;
    [match endMatchInTurnWithMatchState:@"FOOBAR" completionHandler:^(NSError *error) {
        completionHandlerWasCalled = YES;
    }];

    STAssertTrue(completionHandlerWasCalled, nil);
    STAssertEqualObjects(match.currentParticipant, participant, nil);
    STAssertEqualObjects(match.matchState, @"FOOBAR", nil);
}

@end