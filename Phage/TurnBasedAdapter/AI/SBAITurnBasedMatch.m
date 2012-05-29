//
//  Created by s.brautaset@london.net-a-porter.com on 27/04/2012.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import "SBAITurnBasedMatch.h"
#import "SBTurnBasedParticipant.h"

@implementation SBAITurnBasedMatch

@synthesize delegate = _delegate;
@synthesize matchState = _matchState;
@synthesize participants = _participants;
@synthesize localParticipant = _localParticipant;
@synthesize currentParticipant = _currentParticipant;
@synthesize status = _status;

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:self.currentParticipant forKey:@"SBCurrentParticipant"];
    [aCoder encodeObject:self.localParticipant forKey:@"SBLocalParticipant"];
    [aCoder encodeObject:self.participants forKey:@"SBParticipants"];
    [aCoder encodeObject:self.matchState forKey:@"SBMatchState"];
    [aCoder encodeInteger:self.status forKey:@"SBStatus"];
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super init];
    if (self) {
        self.currentParticipant = [aDecoder decodeObjectForKey:@"SBCurrentParticipant"];
        self.localParticipant = [aDecoder decodeObjectForKey:@"SBLocalParticipant"];
        self.participants = [aDecoder decodeObjectForKey:@"SBParticipants"];
        self.matchState = [aDecoder decodeObjectForKey:@"SBMatchState"];
        self.status = [aDecoder decodeIntegerForKey:@"SBStatus"];
    }
    return self;
}


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