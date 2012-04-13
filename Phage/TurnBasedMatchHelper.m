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
    }
    return self;
}

- (void)findMatchWithMinPlayers:(NSUInteger)minPlayers maxPlayers:(NSUInteger)maxPlayers {
    GKMatchRequest *request = [[GKMatchRequest alloc] init];
    request.minPlayers = minPlayers;
    request.maxPlayers = maxPlayers;

    GKTurnBasedMatchmakerViewController *vc = [[GKTurnBasedMatchmakerViewController alloc] initWithMatchRequest:request];
    vc.turnBasedMatchmakerDelegate = self;
    vc.showExistingMatches = YES;

    [_presentingViewController presentModalViewController:vc animated:YES];
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
                              if (error)
                                  NSLog(@"ERROR: %@", error);
                          }];

}


@end