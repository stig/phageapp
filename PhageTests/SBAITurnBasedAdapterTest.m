//
//  Created by s.brautaset@london.net-a-porter.com on 27/04/2012.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import <SenTestingKit/SenTestingKit.h>
#import <OCMock/OCMock.h>
#import "SBAITurnBasedAdapter.h"

@interface SBAITurnBasedAdapterTest : SenTestCase {
    SBAITurnBasedAdapter *helper;
    id delegate;
    id match;
}
@end

@implementation SBAITurnBasedAdapterTest

- (void)setUp {
    delegate = [OCMockObject mockForProtocol:@protocol(SBTurnBasedMatchHelperDelegate)];
    match = [OCMockObject mockForProtocol:@protocol(SBTurnBasedMatch)];

    helper = [[SBAITurnBasedAdapter alloc] init];
    helper.delegate = delegate;
}

- (void)tearDown {
    [delegate verify];
    [match verify];
}

#pragma mark nextParticipantForMatch:

- (void)testNextParticipantForMatch {
    [[delegate expect] nextParticipantForMatch:match];
    [helper nextParticipantForMatch:match];
}

@end