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

@implementation SBViewController

@synthesize currentState = _currentState;
@synthesize textView = _textView;
@synthesize moveButton = _moveButton;
@synthesize turnBasedMatchHelper = _turnBasedMatchHelper;

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

    SBPlayer player = [match.participants indexOfObject:match.currentParticipant] == 0
            ? SBPlayerNorth
            : SBPlayerSouth;

    SBMove *move = [[[SBMovePicker alloc] init] optimalMoveForState:self.currentState withPlayer:player];

    if (move) {
        SBState *newState = [self.currentState successorWithMove:move];

        [match endTurnWithNextParticipant:[self nextParticipantForMatch:match]
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

#pragma mark Turn Based Match Helper Delegate

- (GKTurnBasedParticipant *)nextParticipantForMatch:(GKTurnBasedMatch *)match {
    NSUInteger currIdx = [match.participants indexOfObject:match.currentParticipant];
    NSUInteger nextIdx = (currIdx + 1) % match.participants.count;
    return [match.participants objectAtIndex:nextIdx];
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

- (void)sendNotice:(NSString *)notice forMatch:(GKTurnBasedMatch *)match {
    UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"Another game needs your attention!"
                                                 message:notice
                                                delegate:self
                                       cancelButtonTitle:@"Sweet!"
                                       otherButtonTitles:nil];
    [av show];
}

- (void)recieveEndGame:(GKTurnBasedMatch *)match {
    [self layoutMatch:match];
}

@end
