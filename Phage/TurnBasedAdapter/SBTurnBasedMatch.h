//
//  Created by stig on 26/04/2012.
//
// To change the template use AppCode | Preferences | File Templates.
//


@protocol SBTurnBasedParticipant;

@protocol SBTurnBasedMatch < NSObject >

@property(readonly) id matchState;
@property(readonly) id<SBTurnBasedParticipant> currentParticipant;
@property(readonly) NSArray *participants;


- (void)participantQuitInTurnWithOutcome:(GKTurnBasedMatchOutcome)outcome
                         nextParticipant:(id<SBTurnBasedParticipant>)participant
                              matchState:(id)matchState
                       completionHandler:(void(^)(NSError*))block;

- (void)endTurnWithNextParticipant:(id<SBTurnBasedParticipant>)nextParticipant matchState:(id)matchState completionHandler:(void(^)(NSError *error))completionHandler;
- (void)endMatchInTurnWithMatchState:(id)matchState completionHandler:(void(^)(NSError *error))completionHandler;

- (void)removeWithCompletionHandler:(void(^)(NSError *))completionHandler;
@end