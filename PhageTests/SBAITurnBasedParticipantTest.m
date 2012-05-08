//
//  Created by s.brautaset@london.net-a-porter.com on 27/04/2012.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import <SenTestingKit/SenTestingKit.h>
#import "SBAITurnBasedParticipant.h"

@interface SBAITurnBasedParticipantTest : SenTestCase {
    SBAITurnBasedParticipant *participant;
    SBAITurnBasedParticipant *otherParticipant;
}
@end

@implementation SBAITurnBasedParticipantTest

- (void)setUp {
    participant = [[SBAITurnBasedParticipant alloc] initWithPlayerID:@"human"];
    otherParticipant = [[SBAITurnBasedParticipant alloc] initWithPlayerID:@"ai"];
}

- (void)testIsEqual {
    STAssertEqualObjects(participant, participant, nil);
    STAssertFalse([participant isEqual:otherParticipant], nil);

    SBAITurnBasedParticipant *copy = [[SBAITurnBasedParticipant alloc] initWithPlayerID:participant.playerID];
    STAssertEqualObjects(participant, copy, nil);
}


@end