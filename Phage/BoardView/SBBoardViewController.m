//
//  SBViewController.m
//  Phage
//
//  Created by Stig Brautaset on 24/3/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "SBBoardViewController.h"
#import "SBState.h"
#import "SBMove.h"
#import "SBTurnBasedParticipant.h"
#import "PhageModelHelper.h"

@interface SBBoardViewController () < UIActionSheetDelegate >
@property(strong) UIActionSheet *forfeitActionSheet;
@end

@implementation SBBoardViewController

@synthesize turnBasedMatchHelper = _turnBasedMatchHelper;
@synthesize gridView = _gridView;
@synthesize modelHelper = _modelHelper;
@synthesize forfeitActionSheet = _forfeitActionSheet;


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

- (IBAction)forfeit {
    if ([self.turnBasedMatchHelper isLocalPlayerTurn:self.turnBasedMatchHelper.currentMatch]) {
        self.forfeitActionSheet = [[UIActionSheet alloc] initWithTitle:@"Really forfeit match?" delegate:self cancelButtonTitle:@"No" destructiveButtonTitle:@"Yes" otherButtonTitles:nil];
        [self.forfeitActionSheet showInView:self.view];
    } else {
        [[[UIAlertView alloc] initWithTitle:@"Wait for your turn" message:@"You can only forfeit when it is your turn." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
    }
}

- (BOOL)canCurrentPlayerMovePiece:(SBPiece *)piece {
    SBState *state = self.turnBasedMatchHelper.currentMatch.matchState;
    return [[state piecesForPlayer:state.isPlayerOne] containsObject:piece];
}

- (BOOL)canMovePiece:(SBPiece *)piece toLocation:(SBLocation *)location {
    SBMove *move = [SBMove moveWithPiece:piece to:location];
    SBState *state = self.turnBasedMatchHelper.currentMatch.matchState;
    return [state isLegalMove:move];
}

- (void)movePiece:(SBPiece *)piece toLocation:(SBLocation *)location {
    NSLog(@"[%@ %s]", [self class], sel_getName(_cmd));

    SBMove *move = [SBMove moveWithPiece:piece to:location];

    id<SBTurnBasedMatch>match = self.turnBasedMatchHelper.currentMatch;
    SBState *state = match.matchState;

    NSParameterAssert([state isLegalMove:move]);
    SBState *newState = [state successorWithMove:move];

    [self.modelHelper endTurnOrMatch:match withMatchState:newState completionHandler:^(NSError *error) {
        if (!error) [self.gridView layoutForState:newState];
    }];
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
    [self.gridView layoutForState:[[SBState alloc] initWithPlayer:player]];
}

- (void)takeTurn:(id<SBTurnBasedMatch>)match {
    NSLog(@"-[%@ %@]", NSStringFromClass([self class]), NSStringFromSelector(_cmd));
    [self.gridView layoutForState:match.matchState];
}

- (void)layoutMatch:(id <SBTurnBasedMatch>)match {
    NSLog(@"-[%@ %@]", NSStringFromClass([self class]), NSStringFromSelector(_cmd));
    [self.gridView layoutForState:match.matchState];
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

    NSString *message;

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

#pragma mark UIActionSheetDelegate

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    if ([actionSheet isEqual:self.forfeitActionSheet]) {
        if ([actionSheet destructiveButtonIndex] == buttonIndex) {
            [self.modelHelper forfeitMatch:self.turnBasedMatchHelper.currentMatch inTurnWithCompletionHandler:^(NSError *error) {}];
        }
        self.forfeitActionSheet = nil;
    }
}

@end
