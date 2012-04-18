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

@implementation SBViewController

@synthesize moveButton = _moveButton;
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
    [self.turnBasedMatchHelper findMatchWithMinPlayers:2 maxPlayers:2];
}

- (SBState *)startState {
    return [[SBState alloc] init];
}

- (void)performMove:(SBMove*) move
{
    GKTurnBasedMatch *match = self.turnBasedMatchHelper.currentMatch;
    SBState *state;
    if (match.matchData.length) {
        state = [NSKeyedUnarchiver unarchiveObjectWithData:match.matchData];
    } else {
        state = [self startState];
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
                                self.moveButton.enabled = NO;
                                [self.gridView setState:newState];
                            }
                        }];
    }
}

#pragma mark Turn Based Match Helper Delegate

- (GKTurnBasedParticipant *)nextParticipantForMatch:(GKTurnBasedMatch *)match {
    NSUInteger currIdx = [match.participants indexOfObject:match.currentParticipant];
    NSUInteger nextIdx = (currIdx + 1) % match.participants.count;
    return [match.participants objectAtIndex:nextIdx];
}

- (void)enterNewGame:(GKTurnBasedMatch *)match {
    NSLog(@"enterNewGame");
    self.moveButton.enabled = YES;
    [self.gridView setState:[self startState]];
}

- (void)takeTurn:(GKTurnBasedMatch *)match {
    NSLog(@"takeTurn");
    self.moveButton.enabled = YES;
    [self.gridView setState:[NSKeyedUnarchiver unarchiveObjectWithData:match.matchData]];
}

- (void)layoutMatch:(GKTurnBasedMatch *)match {
    NSLog(@"layoutMatch");
    self.moveButton.enabled = NO;
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


@end
