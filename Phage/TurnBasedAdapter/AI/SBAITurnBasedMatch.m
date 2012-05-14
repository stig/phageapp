//
//  Created by s.brautaset@london.net-a-porter.com on 27/04/2012.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import "SBAITurnBasedMatch.h"
#import "SBTurnBasedParticipant.h"
#import "SBTurnBasedMatchHelper.h"

@implementation SBAITurnBasedMatch

@synthesize delegate = _delegate;
@synthesize matchState = _matchState;
@synthesize participants = _participants;
@synthesize localParticipant = _localParticipant;
@synthesize currentParticipant = _currentParticipant;
@synthesize status = _status;


- (void)endTurnWithNextParticipant:(id <SBTurnBasedParticipant>)nextParticipant matchState:(id)matchState completionHandler:(void (^)(NSError *))completionHandler {
    NSLog(@"[%@ %s]", [self class], sel_getName(_cmd));
    self.currentParticipant = nextParticipant;
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

- (void)participantQuitInTurnWithOutcome:(GKTurnBasedMatchOutcome)outcome nextParticipant:(id <SBTurnBasedParticipant>)participant matchState:(id)matchState completionHandler:(void (^)(NSError *))completionHandler {
    NSLog(@"[%@ %s]", [self class], sel_getName(_cmd));
    self.matchState = matchState;
    self.currentParticipant.matchOutcome = outcome;
    participant.matchOutcome = GKTurnBasedMatchOutcomeWon;
    self.status = GKTurnBasedMatchStatusEnded;
    completionHandler(nil);
    [self.delegate handleMatchEnded:self];
}

- (void)removeWithCompletionHandler:(void (^)(NSError *))completionHandler {
    NSLog(@"[%@ %s]", [self class], sel_getName(_cmd));
    [self doesNotRecognizeSelector:_cmd]; // TODO implement me
}

@end