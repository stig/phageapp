//
//  Created by stig on 26/04/2012.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import "SBGameKitTurnBasedMatch.h"
#import "SBGameKitTurnBasedParticipant.h"
#import "SBState.h"


@implementation SBGameKitTurnBasedMatch

@synthesize wrappedMatch = _wrappedMatch;

- (id)initWithMatch:(GKTurnBasedMatch *)match {
    self = [super init];
    if (self) {
        _wrappedMatch = match;
    }
    return self;
}

- (BOOL)isEqual:(id)other {
    if (other == self)
        return YES;
    if (!other || ![other isKindOfClass:[self class]])
        return NO;
    return [self isEqualToTurnBasedMatch:other];
}

- (BOOL)isEqualToTurnBasedMatch:(SBGameKitTurnBasedMatch *)other {
    if (self == other)
        return YES;
    return [self.wrappedMatch.matchID isEqualToString:other.wrappedMatch.matchID];
}


- (id <SBTurnBasedParticipant>)localParticipant {
    GKLocalPlayer *localPlayer = [GKLocalPlayer localPlayer];
    for (GKTurnBasedParticipant *part in self.wrappedMatch.participants) {
        if ([part.playerID isEqualToString:localPlayer.playerID]) {
            return [[SBGameKitTurnBasedParticipant alloc] initWithParticipant:part];
        }
    }
    @throw @"Should never get here: the local player should _always_ be one of the players in the match";
}

- (id <SBTurnBasedParticipant>)currentParticipant {
    return [[SBGameKitTurnBasedParticipant alloc] initWithParticipant:_wrappedMatch.currentParticipant];
}

- (id)matchState {
    if (_wrappedMatch.matchData.length)
        return [NSKeyedUnarchiver unarchiveObjectWithData:_wrappedMatch.matchData];
    return nil;
}

- (NSArray*)participants {
    NSMutableArray *participants = [[NSMutableArray alloc] init];
    for (GKTurnBasedParticipant *p in _wrappedMatch.participants)
        [participants addObject:[[SBGameKitTurnBasedParticipant alloc] initWithParticipant:p]];
    return participants;
}

- (void)endTurnWithNextParticipant:(id <SBTurnBasedParticipant>)nextParticipant matchState:(id)matchState completionHandler:(void (^)(NSError *))completionHandler {
    NSLog(@"-[%@ %@]", NSStringFromClass([self class]), NSStringFromSelector(_cmd));
    SBGameKitTurnBasedParticipant *next = (SBGameKitTurnBasedParticipant *) nextParticipant;
    [_wrappedMatch endTurnWithNextParticipant:next.wrappedParticipant
                                    matchData:[NSKeyedArchiver archivedDataWithRootObject:matchState]
                            completionHandler:completionHandler];
}


- (void)endMatchInTurnWithMatchState:(id)matchState completionHandler:(void (^)(NSError *))completionHandler {
    NSLog(@"-[%@ %@]", NSStringFromClass([self class]), NSStringFromSelector(_cmd));
    [_wrappedMatch endMatchInTurnWithMatchData:[NSKeyedArchiver archivedDataWithRootObject:matchState]
                             completionHandler:completionHandler];
}

- (void)removeWithCompletionHandler:(void (^)(NSError *))completionHandler {
    NSLog(@"-[%@ %@]", NSStringFromClass([self class]), NSStringFromSelector(_cmd));
    [[self wrappedMatch] removeWithCompletionHandler:completionHandler];
}


- (void)participantQuitInTurnWithOutcome:(GKTurnBasedMatchOutcome)outcome
                         nextParticipant:(id <SBTurnBasedParticipant>)participant_
                              matchState:(id)matchState
                       completionHandler:(void(^)(NSError *))block {
    NSLog(@"-[%@ %@]", NSStringFromClass([self class]), NSStringFromSelector(_cmd));

    SBGameKitTurnBasedParticipant *participant = (SBGameKitTurnBasedParticipant *)participant_;

    [[self wrappedMatch] participantQuitInTurnWithOutcome:outcome
                                          nextParticipant:[participant wrappedParticipant]
                                                matchData:[NSKeyedArchiver archivedDataWithRootObject:matchState]
                                        completionHandler:block];
}


@end