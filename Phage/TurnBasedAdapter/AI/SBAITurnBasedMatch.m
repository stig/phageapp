//
//  Created by s.brautaset@london.net-a-porter.com on 27/04/2012.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import "SBAITurnBasedMatch.h"
#import "SBTurnBasedParticipant.h"

@interface SBAITurnBasedMatch () {
    NSUInteger _idx;
}
@end

@implementation SBAITurnBasedMatch

@synthesize matchState = _matchState;
@synthesize participants = _participants;

- (id)initWithMatchState:(id)matchState participants:(NSArray *)participants {
    self = [super init];
    if (self) {
        _matchState = matchState;
        _participants = participants;
    }
    return self;
}

- (id<SBTurnBasedParticipant>)currentParticipant {
    return [self.participants objectAtIndex:_idx];
}

- (void)endTurnWithNextParticipant:(id <SBTurnBasedParticipant>)nextParticipant matchState:(id)matchState completionHandler:(void (^)(NSError *))completionHandler {
    _idx = [self.participants indexOfObject:nextParticipant];
    _matchState = matchState;
    completionHandler(nil);
}

- (void)endMatchInTurnWithMatchState:(id)matchState completionHandler:(void (^)(NSError *))completionHandler {

    // TODO Implement me
}


@end