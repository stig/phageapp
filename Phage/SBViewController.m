//
//  SBViewController.m
//  Phage
//
//  Created by Stig Brautaset on 24/3/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "SBViewController.h"
#import "SBState.h"
#import "SBMove.h"
#import "SBPlayer.h"

@implementation SBViewController

@synthesize turnBasedMatchHelper = _turnBasedMatchHelper;
@synthesize gridView = _gridView;

- (void)viewDidLoad {
    [super viewDidLoad];

    self.turnBasedMatchHelper = [[TurnBasedMatchHelper alloc] initWithPresentingViewController:self delegate:self];
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

- (SBState*)unarchiveMatchState:(GKTurnBasedMatch*)match {
    return [NSKeyedUnarchiver unarchiveObjectWithData:match.matchData];
}

- (IBAction)go {
    [self.turnBasedMatchHelper findMatch];
}

- (void)performMove:(SBMove*)move
{
    GKTurnBasedMatch *match = self.turnBasedMatchHelper.currentMatch;
    SBState *state = self.gridView.state;

    // SANITY CHECKING - check that the state from the view matches what we have in the match
    if (match.matchData.length) {
        SBState *matchState = [NSKeyedUnarchiver unarchiveObjectWithData:match.matchData];
        NSAssert([matchState isEqualToState:state], @"Match in view should match TurnBased model");
    }

    NSParameterAssert([[state legalMoves] containsObject:move]);
    SBState *newState = [state successorWithMove:move];

    GKTurnBasedParticipant *nextParticipant = [self nextParticipantForMatch:match];
    NSData *matchData = [NSKeyedArchiver archivedDataWithRootObject:newState];

    if ([newState isGameOver]) {
        if ([newState isDraw]) {
            nextParticipant.matchOutcome = GKTurnBasedMatchOutcomeTied;
            match.currentParticipant.matchOutcome = GKTurnBasedMatchOutcomeTied;

        } else if ([newState isWin]) {
            match.currentParticipant.matchOutcome = GKTurnBasedMatchOutcomeLost;
            nextParticipant.matchOutcome = GKTurnBasedMatchOutcomeWon;
            
        } else {
            NSAssert(NO, @"Should never get here...");
        }
        
        [match endMatchInTurnWithMatchData:matchData completionHandler:^(NSError *error) {
            if (error) {
                NSLog(@"%@", error);
            } else {
                [self.gridView setState:newState];
            }
        }];
        
    } else {
        [match endTurnWithNextParticipant:nextParticipant
                                matchData:matchData
                        completionHandler:^(NSError *error) {
                            if (error) {
                                NSLog(@"%@", error);
                                // statusLabel.text = @"Oops, there was a problem.  Try that again.";
                            } else {
                                [self.gridView setState:newState];
                            }
                        }];
    }
}

- (BOOL)isLocalPlayerTurn {
    GKTurnBasedMatch *match = self.turnBasedMatchHelper.currentMatch;
    return [self.turnBasedMatchHelper isLocalPlayerTurn:match];
}

#pragma mark Turn Based Match Helper Delegate

- (GKTurnBasedParticipant *)nextParticipantForMatch:(GKTurnBasedMatch *)match {
    NSUInteger currIdx = [match.participants indexOfObject:match.currentParticipant];
    NSUInteger nextIdx = (currIdx + 1) % match.participants.count;
    return [match.participants objectAtIndex:nextIdx];
}

- (void)enterNewGame:(GKTurnBasedMatch *)match {
    NSLog(@"enterNewGame");
    BOOL isNorth = [[match.participants objectAtIndex:0] isEqual:match.currentParticipant];
    SBPlayer *player = [[SBPlayer alloc] initForNorth:isNorth];
    [self.gridView setState:[[SBState alloc] initWithPlayer:player]];
}

- (void)takeTurn:(GKTurnBasedMatch *)match {
    NSLog(@"takeTurn");
    [self.gridView setState:[NSKeyedUnarchiver unarchiveObjectWithData:match.matchData]];
}

- (void)layoutMatch:(GKTurnBasedMatch *)match {
    NSLog(@"layoutMatch");
    [self.gridView setState:[NSKeyedUnarchiver unarchiveObjectWithData:match.matchData]];
}

- (void)sendTitle:(NSString*)title notice:(NSString *)notice forMatch:(GKTurnBasedMatch *)match {
    UIAlertView *av = [[UIAlertView alloc] initWithTitle:title
                                                 message:notice
                                                delegate:self
                                       cancelButtonTitle:@"Sweet!"
                                       otherButtonTitles:nil];
    [av show];
}

- (void)receiveEndGame:(GKTurnBasedMatch *)match {
    [self layoutMatch:match];
}

- (GKMatchRequest *)matchRequestWithPlayers:(NSArray *)playersToInvite {
    GKMatchRequest *request = [[GKMatchRequest alloc] init];
    request.playersToInvite = playersToInvite;
    request.maxPlayers = 2;
    request.minPlayers = 2;
    return request;
}

@end
