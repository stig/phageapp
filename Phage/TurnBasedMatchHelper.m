//
//  Created by stig on 13/04/2012.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import "TurnBasedMatchHelper.h"


@implementation TurnBasedMatchHelper

@synthesize currentMatch = _currentMatch;

- (id)initWithPresentingViewController:(UIViewController *)vc delegate:(id <TurnBasedMatchHelperDelegate>)delegate {
    self = [super init];
    if (self) {
        _presentingViewController = vc;
        _delegate = delegate;

        [GKTurnBasedEventHandler sharedTurnBasedEventHandler].delegate = self;
    }
    return self;
}


#pragma mark Methods

- (void)findMatchWithMinPlayers:(NSUInteger)minPlayers maxPlayers:(NSUInteger)maxPlayers {
    GKMatchRequest *request = [[GKMatchRequest alloc] init];
    request.minPlayers = minPlayers;
    request.maxPlayers = maxPlayers;

    GKTurnBasedMatchmakerViewController *vc = [[GKTurnBasedMatchmakerViewController alloc] initWithMatchRequest:request];
    vc.turnBasedMatchmakerDelegate = self;
    vc.showExistingMatches = YES;

    [_presentingViewController presentModalViewController:vc animated:YES];
}

- (BOOL)isCurrentMatch:(GKTurnBasedMatch *)match {
    return [match.matchID isEqualToString:self.currentMatch.matchID];
}

- (BOOL)isLocalPlayerTurn:(GKTurnBasedMatch *)match {
    return [match.currentParticipant.playerID isEqualToString:[GKLocalPlayer localPlayer].playerID];
}

#pragma mark Turn Based Matchmaker View Controller Delegate

// The user has cancelled
- (void)turnBasedMatchmakerViewControllerWasCancelled:(GKTurnBasedMatchmakerViewController *)viewController {
    NSLog(@"User cancelled");
    [viewController dismissModalViewControllerAnimated:YES];
}

// Matchmaking has failed with an error
- (void)turnBasedMatchmakerViewController:(GKTurnBasedMatchmakerViewController *)viewController didFailWithError:(NSError *)error {
    NSLog(@"didFailWithError: %@", error);
    [viewController dismissModalViewControllerAnimated:YES];
}

// A turned-based match has been found, the game should start
- (void)turnBasedMatchmakerViewController:(GKTurnBasedMatchmakerViewController *)viewController didFindMatch:(GKTurnBasedMatch *)match {
    [viewController dismissModalViewControllerAnimated:YES];
    NSLog(@"A Match has been found!: %@", match);

    _currentMatch = match;

    GKTurnBasedParticipant *firstParticipant = [match.participants objectAtIndex:0];

    if (firstParticipant.lastTurnDate == NULL) {
        // It's a new game!
        [_delegate enterNewGame:match];
    } else {
        if ([match.currentParticipant.playerID isEqualToString:[GKLocalPlayer localPlayer].playerID]) {
            // It's your turn!
            [_delegate takeTurn:match];
        } else {
            // It's not your turn, just display the game state.
            [_delegate layoutMatch:match];
        }
    }
}

// Called when a users chooses to quit a match and that player has the current turn.  The developer should call playerQuitInTurnWithOutcome:nextPlayer:matchData:completionHandler: on the match passing in appropriate values.  They can also update matchOutcome for other players as appropriate.
- (void)turnBasedMatchmakerViewController:(GKTurnBasedMatchmakerViewController *)viewController playerQuitForMatch:(GKTurnBasedMatch *)match {
    NSLog(@"Player quit match: %@", match);

    GKTurnBasedParticipant *part = [_delegate nextParticipantForMatch:match];
    part.matchOutcome = GKTurnBasedMatchOutcomeWon;

    [match participantQuitInTurnWithOutcome:GKTurnBasedMatchOutcomeLost
                            nextParticipant:part
                                  matchData:match.matchData
                          completionHandler:^(NSError *error) {
                              if (error) {
                                  NSLog(@"ERROR: %@", error);
                                   // TODO: used while developing; disable before release
                                  [match removeWithCompletionHandler:nil];
                              }
                          }];

}

#pragma mark Turn Based Event Handler Delegate


- (void)handleInviteFromGameCenter:(NSArray *)playersToInvite {
    [_presentingViewController dismissModalViewControllerAnimated:YES];

    // TODO: Ask our delegate for a suitable match request object, so we can get the correct number of players, etc
    GKMatchRequest *request = [[GKMatchRequest alloc] init];
    request.playersToInvite = playersToInvite;
    request.maxPlayers = 2;
    request.minPlayers = 2;

    GKTurnBasedMatchmakerViewController *viewController = [[GKTurnBasedMatchmakerViewController alloc] initWithMatchRequest:request];
    viewController.showExistingMatches = NO;
    viewController.turnBasedMatchmakerDelegate = self;

    [_presentingViewController presentModalViewController:viewController animated:YES];
}

- (void)handleTurnEventForMatch:(GKTurnBasedMatch *)match {
    NSLog(@"Turn has happened");
    if ([self isCurrentMatch:match]) {
        // it's the current match..
        _currentMatch = match;
        if ([self isLocalPlayerTurn:match]) {
            // ..and it's our turn now
            [_delegate takeTurn:match];
        } else {
            // ..but it's someone else's turn
            [_delegate layoutMatch:match];
        }
    } else {
        if ([self isLocalPlayerTurn:match]) {
            // it's not the current match and it's our turn now
            [_delegate sendTitle:@"Attention: Your Turn!"
                          notice:@"It is now your turn in another game."
                        forMatch:match];
        } else {
            // it's the not current match, and it's someone else's turn
        }
    }
}

- (void)handleMatchEnded:(GKTurnBasedMatch *)match {
    NSLog(@"Game has ended");
    if ([self isCurrentMatch:match]) {
        [_delegate receiveEndGame:match];
    } else {
        [_delegate sendTitle:@"Game Over!"
                      notice:@"One of your other games has ended."
                    forMatch:match];
    }
}


@end