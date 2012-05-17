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
#import "PhageModelHelper.h"

@implementation SBViewController

@synthesize turnBasedMatchHelper = _turnBasedMatchHelper;
@synthesize gridView = _gridView;
@synthesize modelHelper = _modelHelper;


- (void)viewDidLoad {
    [super viewDidLoad];
    self.modelHelper = [[PhageModelHelper alloc] init];
    [self.turnBasedMatchHelper findMatch];
}

- (void)viewDidUnload {
    [super viewDidUnload];
    self.modelHelper = nil;
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

    NSParameterAssert([state isLegalMove:move]);
    SBState *newState = [state successorWithMove:move];

    [self.modelHelper endTurnOrMatch:match withMatchState:newState];
}

- (BOOL)isLocalPlayerTurn {
    id<SBTurnBasedMatch> match = self.turnBasedMatchHelper.currentMatch;
    return [self.turnBasedMatchHelper isLocalPlayerTurn:match];
}

#pragma mark Turn Based Match Helper Delegate

- (id<SBTurnBasedParticipant>)nextParticipantForMatch:(id<SBTurnBasedMatch>)match {
    return [self.modelHelper nextParticipantForMatch:match];
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

    NSString *message = nil;

    switch ([[match localParticipant] matchOutcome]) {
        case GKTurnBasedMatchOutcomeWon:
            message = @"You won the match!";
            break;
        case GKTurnBasedMatchOutcomeTied:
            message = @"You managed a tie!";
            break;
        default:
            message = @"You lost the match... Better luck next time!";
    }

    [[[UIAlertView alloc] initWithTitle:@"Game Over"
                                message:message
                               delegate:self
                      cancelButtonTitle:@"OK"
                      otherButtonTitles:nil] show];

}

@end
