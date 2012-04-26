//
//  Created by s.brautaset@london.net-a-porter.com on 27/04/2012.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import <SenTestingKit/SenTestingKit.h>
#import <OCMock/OCMock.h>
#import "SBGameKitTurnBasedParticipant.h"

@interface SBGameKitTurnBasedParticipantTest : SenTestCase {
    SBGameKitTurnBasedParticipant *participant;
    id adaptee;
}
@end

@implementation SBGameKitTurnBasedParticipantTest

- (void)setUp {
    adaptee = [OCMockObject mockForClass:[GKTurnBasedParticipant class]];
    participant = [[SBGameKitTurnBasedParticipant alloc] initWithParticipant:adaptee];
}

- (void)tearDown {
    [adaptee verify];
}

- (void)test {
    STAssertNotNil(participant, nil);
}

@end