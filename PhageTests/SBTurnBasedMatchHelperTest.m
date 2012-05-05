//
//  Created by s.brautaset@london.net-a-porter.com on 27/04/2012.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import <SenTestingKit/SenTestingKit.h>
#import <OCMock/OCMock.h>
#import "SBTurnBasedMatch.h"
#import "SBTurnBasedMatchHelper.h"

@interface SBTurnBasedMatchHelperTest : SenTestCase {
    SBTurnBasedMatchHelper *helper;
    id delegate;
    id adapter;
    id match;
    id otherMatch;
}
@end

@implementation SBTurnBasedMatchHelperTest

- (void)setUp {
    delegate = [OCMockObject mockForProtocol:@protocol(SBTurnBasedMatchHelperDelegate)];
    adapter = [OCMockObject mockForProtocol:@protocol(SBTurnBasedMatchAdapter)];
    match = [OCMockObject mockForProtocol:@protocol(SBTurnBasedMatch)];
    otherMatch = [OCMockObject mockForProtocol:@protocol(SBTurnBasedMatch)];

    helper = [[SBTurnBasedMatchHelper alloc] init];
    [helper setValue:delegate forKey:@"delegate"];
    [helper setValue:adapter forKey:@"adapter"];

    BOOL yes = YES;
    [[[match stub] andReturnValue:OCMOCK_VALUE(yes)] isEqual:match];

    BOOL no = NO;
    [[[match stub] andReturnValue:OCMOCK_VALUE(no)] isEqual:otherMatch];
}

- (void)tearDown {
    [delegate verify];
    [adapter verify];
    [match verify];
    [otherMatch verify];
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

#pragma mark handleDidFindMatch:

#pragma mark handlePlayerQuitForMatch:

#pragma mark Adapter methods

- (void)testFindMatch {
    [[adapter expect] findMatch];
    [helper findMatch];
}

- (void)testIsLocalPlayerTurn {
    [[adapter expect] isLocalPlayerTurn:match];
    [helper isLocalPlayerTurn:match];
}

@end