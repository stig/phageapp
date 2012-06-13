//
//  Created by stig on 02/05/2012.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import "SBTurnBasedMatchHelper.h"
#import "SBTurnBasedParticipant.h"

@interface SBTurnBasedMatchHelper ()
@property(strong) id<SBTurnBasedMatch> currentMatch;
@end


@implementation SBTurnBasedMatchHelper
@synthesize delegate = _delegate;
@synthesize currentMatch = _currentMatch;
@synthesize adapter = _adapter;


- (BOOL)isCurrentMatch:(id <SBTurnBasedMatch>)match {
    return [match isEqual:self.currentMatch];
}

- (BOOL)isLocalPlayerTurn:(id <SBTurnBasedMatch>)match {
    return [match.currentParticipant isEqual:match.localParticipant];
}

#pragma mark Methods implemented in Strategy

- (void)findMatch {
    [self.adapter findMatch];
}

#pragma mark Methods called by Adapters

- (void)handleDidFindMatch:(id <SBTurnBasedMatch>)match {
    TFLog(@"%s match = %@", __PRETTY_FUNCTION__, match);

    self.currentMatch = match;

    if (nil == match.matchState) {
        // It's a new game!
        [self.delegate enterNewGame:match];

    } else if ([self isLocalPlayerTurn:match]) {
        // It's your turn!
        [self.delegate takeTurn:match];

    } else {
        // It's not your turn, just display the game state.
        [self.delegate layoutMatch:match];
    }
}

- (void)handlePlayerQuitForMatch:(id <SBTurnBasedMatch>)match {
    TFLog(@"%s match = %@", __PRETTY_FUNCTION__, match);

    // Assumes 2-player game..
    id<SBTurnBasedParticipant> next = [self.delegate nextParticipantForMatch:match];
    next.matchOutcome = GKTurnBasedMatchOutcomeWon;

    [match participantQuitInTurnWithOutcome:GKTurnBasedMatchOutcomeQuit
                            nextParticipant:next
                                  matchState:match.matchState
                          completionHandler:^(NSError *error) {
                              if (error) {
                                  TFLog(@"%s error = %@", __PRETTY_FUNCTION__, error);
                                  // TODO: used while developing; disable before release
                                  [match removeWithCompletionHandler:nil];
                              }
                          }];
}

- (void)handleTurnEventForMatch:(id <SBTurnBasedMatch>)match {
    TFLog(@"%s match = %@", __PRETTY_FUNCTION__, match);

    if ([self isCurrentMatch:match]) {
        // it's the current match..

        if ([self isLocalPlayerTurn:match]) {
            // ..and it's our turn now
            [self.delegate takeTurn:match];
        } else {
            // ..but it's someone else's turn
            [self.delegate layoutMatch:match];
        }
    } else {
        if ([self isLocalPlayerTurn:match]) {
            // it's not the current match and it's our turn now
            [self.delegate sendTitle:@"Attention: Your Turn!"
                              notice:@"It is now your turn in another game."
                            forMatch:match];
        } else {
            // it's the not current match, and it's someone else's turn
        }
    }
}

- (void)handleMatchEnded:(id <SBTurnBasedMatch>)match {
    TFLog(@"%s match = %@", __PRETTY_FUNCTION__, match);

    if ([self isCurrentMatch:match]) {
        [self.delegate receiveEndGame:match];
    } else {
        [self.delegate sendTitle:@"Game Over!"
                          notice:@"One of your other games has ended."
                        forMatch:match];
    }
}

- (id <SBTurnBasedParticipant>)nextParticipantForMatch:(id <SBTurnBasedMatch>)match {
    return [self.delegate nextParticipantForMatch:match];
}


@end