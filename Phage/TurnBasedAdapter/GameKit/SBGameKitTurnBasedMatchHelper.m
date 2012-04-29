//
//  Created by stig on 26/04/2012.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import "SBGameKitTurnBasedMatchHelper.h"
#import "SBGameKitTurnBasedMatch.h"
#import "SBGameKitTurnBasedParticipant.h"

@interface SBGameKitTurnBasedMatchHelper ()
@property(strong) SBGameKitTurnBasedMatch *currentMatch;
@end

@implementation SBGameKitTurnBasedMatchHelper

@synthesize delegate = _delegate;
@synthesize currentMatch = _currentMatch;
@synthesize presentingViewController = _presentingViewController;

- (id)init {
    self = [super init];
    if (self) {
        [GKTurnBasedEventHandler sharedTurnBasedEventHandler].delegate = self;
    }
    return self;
}

- (void)dealloc {
    [GKTurnBasedEventHandler sharedTurnBasedEventHandler].delegate = nil;
}

#pragma mark Private

- (SBGameKitTurnBasedMatch *)wrap:(GKTurnBasedMatch *)match {
    return [[SBGameKitTurnBasedMatch alloc] initWithMatch:match];
}

#pragma mark Methods

- (void)findMatch {
    GKMatchRequest *request = [[GKMatchRequest alloc] init];
    request.maxPlayers = 2;
    request.minPlayers = 2;

    GKTurnBasedMatchmakerViewController *vc = [[GKTurnBasedMatchmakerViewController alloc] initWithMatchRequest:request];
    vc.turnBasedMatchmakerDelegate = self;
    vc.showExistingMatches = YES;

    [self.presentingViewController presentModalViewController:vc animated:YES];
}

- (BOOL)isCurrentMatch:(id<SBTurnBasedMatch>)match {
    return [self.currentMatch isEqual:match];
}

- (BOOL)isLocalPlayerTurn:(id<SBTurnBasedMatch>)match {
    SBGameKitTurnBasedMatch *adapter = (SBGameKitTurnBasedMatch *)match;
    NSString *const localPlayerID = [GKLocalPlayer localPlayer].playerID;
    return [adapter.wrappedMatch.currentParticipant.playerID isEqualToString:localPlayerID];
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

    self.currentMatch = [self wrap:match];

    if (0 == [match.matchData length]) {
        // It's a new game!
        [self.delegate enterNewGame:self.currentMatch];

    } else {
        if ([self isLocalPlayerTurn:self.currentMatch]) {
            // It's your turn!
            [self.delegate takeTurn:self.currentMatch];
        } else {
            // It's not your turn, just display the game state.
            [self.delegate layoutMatch:self.currentMatch];
        }
    }
}

// Called when a users chooses to quit a match and that player has the current turn.  The developer should call playerQuitInTurnWithOutcome:nextPlayer:matchData:completionHandler: on the match passing in appropriate values.  They can also update matchOutcome for other players as appropriate.
- (void)turnBasedMatchmakerViewController:(GKTurnBasedMatchmakerViewController *)viewController playerQuitForMatch:(GKTurnBasedMatch *)match {
    NSLog(@"Player quit match: %@", match);

    SBGameKitTurnBasedParticipant *part = (SBGameKitTurnBasedParticipant *) [self.delegate nextParticipantForMatch:[self wrap:match]];
    part.matchOutcome = GKTurnBasedMatchOutcomeWon;

    [match participantQuitInTurnWithOutcome:GKTurnBasedMatchOutcomeLost
                            nextParticipant:part.wrappedParticipant
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

    GKMatchRequest *request = [[GKMatchRequest alloc] init];
    request.playersToInvite = playersToInvite;
    request.maxPlayers = 2;
    request.minPlayers = 2;

    GKTurnBasedMatchmakerViewController *viewController = [[GKTurnBasedMatchmakerViewController alloc] initWithMatchRequest:request];
    viewController.showExistingMatches = NO;
    viewController.turnBasedMatchmakerDelegate = self;

    [_presentingViewController presentModalViewController:viewController animated:YES];
}

- (void)handleTurnEventForMatch:(GKTurnBasedMatch *)match_ {
    NSLog(@"Turn has happened");
    SBGameKitTurnBasedMatch *match = [self wrap:match_];

    if ([self isCurrentMatch:match]) {
        // it's the current match..
        self.currentMatch = match;

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

- (void)handleMatchEnded:(GKTurnBasedMatch *)match_ {
    NSLog(@"Game has ended");
    SBGameKitTurnBasedMatch *match = [self wrap:match_];

    if ([self isCurrentMatch:match]) {
        [self.delegate receiveEndGame:match];
    } else {
        [self.delegate sendTitle:@"Game Over!"
                      notice:@"One of your other games has ended."
                    forMatch:match];
    }
}


@end