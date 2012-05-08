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
#import "SBTurnBasedMatch.h"
#import "SBTurnBasedParticipant.h"

@implementation SBViewController

@synthesize turnBasedMatchHelper = _turnBasedMatchHelper;
@synthesize gridView = _gridView;

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.turnBasedMatchHelper findMatch];
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
    [self.turnBasedMatchHelper findMatch];
}

- (void)performMove:(SBMove*)move {
    NSLog(@"-[%@ %@]", NSStringFromClass([self class]), NSStringFromSelector(_cmd));

    id<SBTurnBasedMatch>match = self.turnBasedMatchHelper.currentMatch;
    SBState *state = self.gridView.state;

    // SANITY CHECKING - check that the state from the view matches what we have in the match
    if (match.matchState) {
        NSAssert([match.matchState isEqualToState:state], @"Match in view should match TurnBased model");
    }

    NSParameterAssert([[state legalMoves] containsObject:move]);
    SBState *newState = [state successorWithMove:move];

    id<SBTurnBasedParticipant> nextParticipant = [self nextParticipantForMatch:match];

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
        
        [match endMatchInTurnWithMatchState:newState completionHandler:^(NSError *error) {
            if (error) {
                NSLog(@"%@", error);
            } else {
                // TODO this should not be necessary; -layoutMatch: should be called
                // at this point, should it not?
                [self.gridView setState:newState];
            }
        }];
        
    } else {
        [match endTurnWithNextParticipant:nextParticipant
                                matchState:newState
                        completionHandler:^(NSError *error) {
                            if (error) {
                                NSLog(@"%@", error);
                                // statusLabel.text = @"Oops, there was a problem.  Try that again.";
                            } else {
                                // TODO this should not be necessary; -layoutMatch should take care of it?
                                [self.gridView setState:newState];
                            }
                        }];
    }
}

- (BOOL)isLocalPlayerTurn {
    id<SBTurnBasedMatch> match = self.turnBasedMatchHelper.currentMatch;
    return [self.turnBasedMatchHelper isLocalPlayerTurn:match];
}

#pragma mark Turn Based Match Helper Delegate

- (id<SBTurnBasedParticipant>)nextParticipantForMatch:(id<SBTurnBasedMatch>)match {
    NSUInteger currIdx = [match.participants indexOfObject:match.currentParticipant];
    NSUInteger nextIdx = (currIdx + 1) % match.participants.count;
    return [match.participants objectAtIndex:nextIdx];
}

- (void)enterNewGame:(id<SBTurnBasedMatch>)match {
    NSLog(@"-[%@ %@]", NSStringFromClass([self class]), NSStringFromSelector(_cmd));
    BOOL player = [[match.participants objectAtIndex:0] isEqual:match.currentParticipant];
    [self.gridView setState:[[SBState alloc] initWithPlayer:player]];
}

- (void)takeTurn:(id<SBTurnBasedMatch>)match {
    NSLog(@"-[%@ %@]", NSStringFromClass([self class]), NSStringFromSelector(_cmd));
    [self.gridView setState:match.matchState];
}

- (void)layoutMatch:(id <SBTurnBasedMatch>)match {
    NSLog(@"-[%@ %@]", NSStringFromClass([self class]), NSStringFromSelector(_cmd));
    [self.gridView setState:match.matchState];
}

- (void)sendTitle:(NSString*)title notice:(NSString *)notice forMatch:(id<SBTurnBasedMatch>)match {
    NSLog(@"-[%@ %@]", NSStringFromClass([self class]), NSStringFromSelector(_cmd));

    UIAlertView *av = [[UIAlertView alloc] initWithTitle:title
                                                 message:notice
                                                delegate:self
                                       cancelButtonTitle:@"Sweet!"
                                       otherButtonTitles:nil];
    [av show];
}

- (void)receiveEndGame:(id<SBTurnBasedMatch>)match {
    NSLog(@"-[%@ %@]", NSStringFromClass([self class]), NSStringFromSelector(_cmd));

    [self layoutMatch:match];

    NSString *title = nil;
    NSString *message = nil;
    switch ([[match.participants objectAtIndex:0] matchOutcome]) {
        case GKTurnBasedMatchOutcomeWon:
            title = @"Congratulations!";
            message = @"You won this match!";
            break;
        case GKTurnBasedMatchOutcomeTied:
            title = @"Well done!";
            message = @"You managed a tie!";
            break;
        default:
            title = @"Game Over";
            message = @"You lost this match...";
    }

    [[[UIAlertView alloc] initWithTitle:title
                                message:message
                               delegate:self
                      cancelButtonTitle:@"OK"
                      otherButtonTitles:nil] show];

}

@end
