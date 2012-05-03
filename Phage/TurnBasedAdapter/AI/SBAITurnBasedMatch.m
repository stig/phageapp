//
//  Created by s.brautaset@london.net-a-porter.com on 27/04/2012.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import "SBAITurnBasedMatch.h"
#import "SBTurnBasedParticipant.h"

@interface SBAITurnBasedMatch () {
    NSUInteger _idx;
    id<SBAITurnBasedMatchDelegate> _delegate;
}
@end

@implementation SBAITurnBasedMatch

@synthesize matchState = _matchState;
@synthesize participants = _participants;

- (id)initWithMatchState:(id)matchState participants:(NSArray *)participants delegate:(id<SBAITurnBasedMatchDelegate>)delegate {
    self = [super init];
    if (self) {
        _matchState = matchState;
        _participants = participants;
        _delegate = delegate;
    }
    return self;
}

- (id<SBTurnBasedParticipant>)currentParticipant {
    return [self.participants objectAtIndex:_idx];
}

- (void)endTurnWithNextParticipant:(id <SBTurnBasedParticipant>)nextParticipant matchState:(id)matchState completionHandler:(void (^)(NSError *))completionHandler {
    NSLog(@"-[%@ %@]", NSStringFromClass([self class]), NSStringFromSelector(_cmd));
    _idx = [self.participants indexOfObject:nextParticipant];
    _matchState = matchState;
    completionHandler(nil);
}

- (void)endMatchInTurnWithMatchState:(id)matchState completionHandler:(void (^)(NSError *))completionHandler {
    NSLog(@"-[%@ %@]", NSStringFromClass([self class]), NSStringFromSelector(_cmd));
    [self doesNotRecognizeSelector:_cmd]; // TODO implement me
}

- (void)participantQuitInTurnWithOutcome:(GKTurnBasedMatchOutcome)outcome nextParticipant:(id <SBTurnBasedParticipant>)participant matchState:(id)matchState completionHandler:(void (^)(NSError *))block {
    NSLog(@"-[%@ %@]", NSStringFromClass([self class]), NSStringFromSelector(_cmd));
    [self doesNotRecognizeSelector:_cmd]; // TODO implement me
}

- (void)removeWithCompletionHandler:(void (^)(NSError *))completionHandler {
    NSLog(@"-[%@ %@]", NSStringFromClass([self class]), NSStringFromSelector(_cmd));
    [self doesNotRecognizeSelector:_cmd]; // TODO implement me
}

@end