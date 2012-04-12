//
//  SBViewController.m
//  Phage
//
//  Created by Stig Brautaset on 24/3/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "SBViewController.h"
#import "SBState.h"
#import "SBMovePicker.h"
#import "SBMove.h"

@interface SBViewController ()

@end

@implementation SBViewController

@synthesize currentMatch = _currentMatch;
@synthesize currentState = _currentState;
@synthesize textView = _textView;
@synthesize moveButton = _moveButton;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
    } else {
        return YES;
    }
}

#pragma mark Actions

- (IBAction)go {
    GKMatchRequest *request = [[GKMatchRequest alloc] init];
    request.minPlayers = 2;
    request.maxPlayers = 2;

    GKTurnBasedMatchmakerViewController *vc = [[GKTurnBasedMatchmakerViewController alloc] initWithMatchRequest:request];
    vc.turnBasedMatchmakerDelegate = self;
    vc.showExistingMatches = YES;

    [self presentModalViewController:vc animated:YES];
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

- (void)enterNewGame:(GKTurnBasedMatch *)match1 {
    NSLog(@"enterNewGame");
    self.currentState = [[SBState alloc] init];
    self.textView.text = [self.currentState description];
    self.moveButton.enabled = YES;
}

- (void)takeTurn:(GKTurnBasedMatch *)match1 {
    NSLog(@"takeTurn");
    self.currentState = [NSKeyedUnarchiver unarchiveObjectWithData:match1.matchData];
    self.textView.text = [self.currentState description];
    self.moveButton.enabled = YES;
}

- (void)layoutMatch:(GKTurnBasedMatch *)match1 {
    NSLog(@"layoutMatch");
    self.currentState = [NSKeyedUnarchiver unarchiveObjectWithData:match1.matchData];
    self.textView.text = [self.currentState description];
    self.moveButton.enabled = NO;
}

// A turned-based match has been found, the game should start
- (void)turnBasedMatchmakerViewController:(GKTurnBasedMatchmakerViewController *)viewController didFindMatch:(GKTurnBasedMatch *)match {
    [viewController dismissModalViewControllerAnimated:YES];
    NSLog(@"A Match has been found!: %@", match);

    self.currentMatch = match;

    // TODO: Should launch a game; handle these cases
    // 1a) Set up initial game in turn
    // 1b) Set up game in turn
    // 2) Set up game out of turn (for view only)

    GKTurnBasedParticipant *firstParticipant = [match.participants objectAtIndex:0];

    if (firstParticipant.lastTurnDate == NULL) {
        // It's a new game!
        [self enterNewGame:match];
    } else {
        if ([match.currentParticipant.playerID isEqualToString:[GKLocalPlayer localPlayer].playerID]) {
            // It's your turn!
            [self takeTurn:match];
        } else {
            // It's not your turn, just display the game state.
            [self layoutMatch:match];
        }
    }
}

- (GKTurnBasedParticipant *)nextParticipantForMatch:(GKTurnBasedMatch *)match {
    NSUInteger currIdx = [match.participants indexOfObject:match.currentParticipant];
    NSUInteger nextIdx = (currIdx + 1) % match.participants.count;
    return [match.participants objectAtIndex:nextIdx];
}

// Called when a users chooses to quit a match and that player has the current turn.  The developer should call playerQuitInTurnWithOutcome:nextPlayer:matchData:completionHandler: on the match passing in appropriate values.  They can also update matchOutcome for other players as appropriate.
- (void)turnBasedMatchmakerViewController:(GKTurnBasedMatchmakerViewController *)viewController playerQuitForMatch:(GKTurnBasedMatch *)match {
    NSLog(@"Player quit match: %@", match);

    GKTurnBasedParticipant *part = [self nextParticipantForMatch:match];
    part.matchOutcome = GKTurnBasedMatchOutcomeWon;

    [match participantQuitInTurnWithOutcome:GKTurnBasedMatchOutcomeLost
                            nextParticipant:part
                                  matchData:match.matchData
                          completionHandler:^(NSError *error) {
                              if (error)
                                  NSLog(@"ERROR: %@", error);
                          }];

}

- (IBAction)makeMove {
    SBPlayer player = [self.currentMatch.participants indexOfObject:self.currentMatch.currentParticipant] == 0
            ? SBPlayerNorth
            : SBPlayerSouth;

    SBMove *move = [[[SBMovePicker alloc] init] optimalMoveForState:self.currentState withPlayer:player];

    if (move) {
        SBState *newState = [self.currentState successorWithMove:move];

        [self.currentMatch endTurnWithNextParticipant:[self nextParticipantForMatch:self.currentMatch]
                                            matchData:[NSKeyedArchiver archivedDataWithRootObject:newState]
                                    completionHandler:^(NSError *error) {
                                        if (error) {
                                            NSLog(@"%@", error);
                                            // statusLabel.text = @"Oops, there was a problem.  Try that again.";
                                        } else {
                                            self.currentState = newState;
                                            self.textView.text = [newState description];
                                            self.moveButton.enabled = NO;
                                        }
                                    }];

    }
}

@end
