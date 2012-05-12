//
//  Created by s.brautaset@london.net-a-porter.com on 27/04/2012.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import "SBAITurnBasedMatch.h"
#import "SBTurnBasedParticipant.h"
#import "SBTurnBasedMatchHelper.h"

@interface SBAITurnBasedMatch () {
    NSUInteger _idx;
}
@end

@implementation SBAITurnBasedMatch

@synthesize delegate = _delegate;
@synthesize matchState = _matchState;
@synthesize participants = _participants;
@synthesize localParticipant = _localParticipant;

- (id<SBTurnBasedParticipant>)currentParticipant {
    return [self.participants objectAtIndex:_idx];
}

- (void)endTurnWithNextParticipant:(id <SBTurnBasedParticipant>)nextParticipant matchState:(id)matchState completionHandler:(void (^)(NSError *))completionHandler {
    NSLog(@"[%@ %s]", [self class], sel_getName(_cmd));
    _idx = [self.participants indexOfObject:nextParticipant];
    self.matchState = matchState;
    completionHandler(nil);
    [self.delegate handleTurnEventForMatch:self];
}

- (void)endMatchInTurnWithMatchState:(id)matchState completionHandler:(void (^)(NSError *))completionHandler {
    NSLog(@"[%@ %s]", [self class], sel_getName(_cmd));
    self.matchState = matchState;
    completionHandler(nil);
    [self.delegate handleMatchEnded:self];
}

- (void)participantQuitInTurnWithOutcome:(GKTurnBasedMatchOutcome)outcome nextParticipant:(id <SBTurnBasedParticipant>)participant matchState:(id)matchState completionHandler:(void (^)(NSError *))block {
    NSLog(@"[%@ %s]", [self class], sel_getName(_cmd));
    [self doesNotRecognizeSelector:_cmd]; // TODO implement me
}

- (void)removeWithCompletionHandler:(void (^)(NSError *))completionHandler {
    NSLog(@"[%@ %s]", [self class], sel_getName(_cmd));
    [self doesNotRecognizeSelector:_cmd]; // TODO implement me
}

@end