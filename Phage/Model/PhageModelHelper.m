//
// Created by SuperPappi on 12/05/2012.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import "PhageModelHelper.h"
#import "SBTurnBasedMatch.h"
#import "SBState.h"
#import "SBTurnBasedParticipant.h"


@implementation PhageModelHelper

- (id<SBTurnBasedParticipant>)nextParticipantForMatch:(id<SBTurnBasedMatch>)match {
    NSUInteger currIdx = [match.participants indexOfObject:match.currentParticipant];
    NSUInteger nextIdx = (currIdx + 1) % match.participants.count;
    return [match.participants objectAtIndex:nextIdx];
}

- (void)endTurnOrMatch:(id <SBTurnBasedMatch>)match withMatchState:(SBState *)successor completionHandler:(void(^)(NSError *))completionHandler {
    NSLog(@"[%@ %s]", [self class], sel_getName(_cmd));

    id<SBTurnBasedParticipant> opponent = [self nextParticipantForMatch:match];

    if ([successor isGameOver]) {
        if ([successor isDraw]) {
            opponent.matchOutcome = GKTurnBasedMatchOutcomeTied;
            match.currentParticipant.matchOutcome = GKTurnBasedMatchOutcomeTied;

        } else if ([successor isLoss]) {
            match.currentParticipant.matchOutcome = GKTurnBasedMatchOutcomeWon;
            opponent.matchOutcome = GKTurnBasedMatchOutcomeLost;

        } else {
            @throw @"Should never get here";
        }

        [match endMatchInTurnWithMatchState:successor completionHandler:^(NSError *error) {
            if (completionHandler) completionHandler(error);
        }];

    } else {
        [match endTurnWithNextParticipant:opponent
                               matchState:successor
                        completionHandler:^(NSError *error) {
                            if (completionHandler) completionHandler(error);
                        }];
    }
}


@end