//
//  Created by s.brautaset@london.net-a-porter.com on 27/04/2012.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import "SBAITurnBasedMatch.h"


@implementation SBAITurnBasedMatch

@synthesize matchState = _matchState;
@synthesize currentParticipant = _currentParticipant;
@synthesize participants = _participants;

- (void)endTurnWithNextParticipant:(id <SBTurnBasedParticipant>)nextParticipant matchState:(id)matchState completionHandler:(void (^)(NSError *))completionHandler {
    //To change the template use AppCode | Preferences | File Templates.

}

- (void)endMatchInTurnWithMatchState:(id)matchState completionHandler:(void (^)(NSError *))completionHandler {
    //To change the template use AppCode | Preferences | File Templates.

}


@end