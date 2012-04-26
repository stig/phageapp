//
//  Created by s.brautaset@london.net-a-porter.com on 27/04/2012.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import <SenTestingKit/SenTestingKit.h>
#import "SBAITurnBasedParticipant.h"

@interface SBAITurnBasedParticipantTest : SenTestCase {
    SBAITurnBasedParticipant *participant;
}
@end

@implementation SBAITurnBasedParticipantTest

- (void)setUp {
    participant = [[SBAITurnBasedParticipant alloc] init];
}

- (void)test {
    STAssertNotNil(participant, nil);
}

@end