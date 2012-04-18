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

@synthesize currentState = _currentState;
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

- (IBAction)go {
    [self.turnBasedMatchHelper findMatchWithMinPlayers:2 maxPlayers:2];
}

- (void)performMove:(SBMove*) move
{
    NSParameterAssert([[self.currentState legalMoves] containsObject:move]);
    SBState *newState = [self.currentState successorWithMove:move];

    GKTurnBasedMatch *match = self.turnBasedMatchHelper.currentMatch;
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
                self.currentState = newState;
                [self.gridView setState:self.currentState];
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
                                self.currentState = newState;
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
    self.currentState = [[SBState alloc] init];
    self.moveButton.enabled = YES;
    [self.gridView setState:self.currentState];
}

- (void)takeTurn:(GKTurnBasedMatch *)match {
    NSLog(@"takeTurn");
    self.currentState = [NSKeyedUnarchiver unarchiveObjectWithData:match.matchData];
    self.moveButton.enabled = YES;
    [self.gridView setState:self.currentState];
}

- (void)layoutMatch:(GKTurnBasedMatch *)match {
    NSLog(@"layoutMatch");
    self.currentState = [NSKeyedUnarchiver unarchiveObjectWithData:match.matchData];
    self.moveButton.enabled = NO;
    [self.gridView setState:self.currentState];
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
