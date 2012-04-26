//
//  Created by s.brautaset@london.net-a-porter.com on 27/04/2012.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import <SenTestingKit/SenTestingKit.h>
#import "SBAITurnBasedMatch.h"

@interface SBAITurnBasedMatchTest : SenTestCase {
    SBAITurnBasedMatch *match;
}
@end

@implementation SBAITurnBasedMatchTest

- (void)setUp {
    match = [[SBAITurnBasedMatch alloc] init];
}

- (void)test {
    STAssertNotNil(match, nil);
}

@end