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
#import "SBPlayer.h"
#import "GridView.h"

@implementation SBViewController

@synthesize currentState = _currentState;
@synthesize moveButton = _moveButton;
@synthesize turnBasedMatchHelper = _turnBasedMatchHelper;
@synthesize gridView = _gridView;

- (void)viewDidLoad {
    [super viewDidLoad];

    self.turnBasedMatchHelper = [[TurnBasedMatchHelper alloc] initWithPresentingViewController:self delegate:self];
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
    [self.turnBasedMatchHelper findMatchWithMinPlayers:2 maxPlayers:2];
}

- (IBAction)makeMove {
    GKTurnBasedMatch *match = self.turnBasedMatchHelper.currentMatch;

    SBPlayer *player = [match.participants indexOfObject:match.currentParticipant] == 0
            ? [[SBPlayer alloc] init]
            : [[SBPlayer alloc] initForNorth:NO];

    SBMove *move = [[[SBMovePicker alloc] init] optimalMoveForState:self.currentState withPlayer:player];
    NSAssert(move, @"Move MUST be available when we get here");
    
    SBState *newState = [self.currentState successorWithMove:move];
    
    GKTurnBasedParticipant *nextParticipant = [self nextParticipantForMatch:match];
    NSData *matchData = [NSKeyedArchiver archivedDataWithRootObject:newState];
    
    if ([newState isGameOverForPlayer:player.opponent]) {
        if ([newState isDraw]) {
            nextParticipant.matchOutcome = GKTurnBasedMatchOutcomeTied;
            match.currentParticipant.matchOutcome = GKTurnBasedMatchOutcomeTied;

        } else if ([newState isWinForPlayer:player]) {
            match.currentParticipant.matchOutcome = GKTurnBasedMatchOutcomeWon;
            nextParticipant.matchOutcome = GKTurnBasedMatchOutcomeLost;
            
        } else {
            NSAssert(NO, @"Should never get here...");
        }
        
        [match endMatchInTurnWithMatchData:matchData completionHandler:^(NSError *error) {
            if (error) {
                NSLog(@"%@", error);
            } else {
                self.currentState = newState;
                [self.gridView setNeedsDisplay];
                
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
                                [self.gridView setNeedsDisplay];
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
    [self.gridView setNeedsDisplay];
}

- (void)takeTurn:(GKTurnBasedMatch *)match {
    NSLog(@"takeTurn");
    self.currentState = [NSKeyedUnarchiver unarchiveObjectWithData:match.matchData];
    self.moveButton.enabled = YES;
    [self.gridView setNeedsDisplay];
}

- (void)layoutMatch:(GKTurnBasedMatch *)match {
    NSLog(@"layoutMatch");
    self.currentState = [NSKeyedUnarchiver unarchiveObjectWithData:match.matchData];
    self.moveButton.enabled = NO;
    [self.gridView setNeedsDisplay];
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
