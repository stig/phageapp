//
//  Created by stig on 26/04/2012.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import "SBGameKitTurnBasedAdapter.h"
#import "SBGameKitTurnBasedMatch.h"

@implementation SBGameKitTurnBasedAdapter

@synthesize delegate = _delegate;
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

#pragma mark Turn Based Matchmaker View Controller Delegate

// The user has cancelled
- (void)turnBasedMatchmakerViewControllerWasCancelled:(GKTurnBasedMatchmakerViewController *)viewController {
    [viewController dismissModalViewControllerAnimated:YES];
}

// Matchmaking has failed with an error
- (void)turnBasedMatchmakerViewController:(GKTurnBasedMatchmakerViewController *)viewController didFailWithError:(NSError *)error {
    [viewController dismissModalViewControllerAnimated:YES];
}

// A turned-based match has been found, the game should start
- (void)turnBasedMatchmakerViewController:(GKTurnBasedMatchmakerViewController *)viewController didFindMatch:(GKTurnBasedMatch *)match {
    [viewController dismissModalViewControllerAnimated:YES];

    [_delegate handleDidFindMatch:[self wrap:match]];
}

// Called when a users chooses to quit a match and that player has the current turn.
// The developer should call playerQuitInTurnWithOutcome:nextPlayer:matchData:completionHandler: on the match passing in appropriate values.
// They can also update matchOutcome for other players as appropriate.
- (void)turnBasedMatchmakerViewController:(GKTurnBasedMatchmakerViewController *)viewController playerQuitForMatch:(GKTurnBasedMatch *)match {
    [self.delegate handlePlayerQuitForMatch:[self wrap:match]];
}

#pragma mark Turn Based Event Handler Delegate

- (void)handleInviteFromGameCenter:(NSArray *)playersToInvite {
    TFLog(@"%s playersToInvite = %@", __PRETTY_FUNCTION__, playersToInvite);

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
    [self.delegate handleTurnEventForMatch:[self wrap:match_]];
}

- (void)handleMatchEnded:(GKTurnBasedMatch *)match_ {
    [self.delegate handleMatchEnded:[self wrap:match_]];
}


@end