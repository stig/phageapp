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
#import "SBBoardViewControllerUnselectedState.h"
#import "SBBoardViewControllerReadonlyState.h"
#import "SBBoardViewControllerGameOverState.h"
#import "SBLocation.h"

@interface SBBoardViewController () < UIActionSheetDelegate >
@property(strong) UIActionSheet *forfeitActionSheet;
- (SBState*)currentState;
- (SBState*)stateForMatch:(id<SBTurnBasedMatch>)match;
@end

@implementation SBBoardViewController

@synthesize turnBasedMatchHelper = _turnBasedMatchHelper;
@synthesize gridView = _gridView;
@synthesize modelHelper = _modelHelper;
@synthesize forfeitActionSheet = _forfeitActionSheet;
@synthesize forfeitButton = _forfeitButton;
@synthesize state = _state;


- (void)viewDidLoad {
    [super viewDidLoad];
    self.modelHelper = [[PhageModelHelper alloc] init];
    self.state = [SBBoardViewControllerState state];
    self.state.delegate = self;
    self.state.gridView = self.gridView;
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

- (SBState*)stateForMatch:(id<SBTurnBasedMatch>)match {
    if (nil == match.matchState) {
        BOOL player = [match.localParticipant isEqual:match.currentParticipant];
        return [[SBState alloc] initWithPlayer:player];
    }
    return match.matchState;
}

- (SBState*)currentState {
    return [self stateForMatch:self.turnBasedMatchHelper.currentMatch];
}

- (IBAction)forfeit {
    NSAssert([self.turnBasedMatchHelper isLocalPlayerTurn:self.turnBasedMatchHelper.currentMatch], @"Should be localPlayerTurn");
    self.forfeitActionSheet = [[UIActionSheet alloc] initWithTitle:@"Really forfeit match?" delegate:self cancelButtonTitle:@"No" destructiveButtonTitle:@"Yes" otherButtonTitles:nil];
    [self.forfeitActionSheet showInView:self.view];
}

- (BOOL)canCurrentPlayerMovePiece:(SBPiece *)piece {
    SBState *state = [self currentState];
    return [[state piecesForPlayer:state.isPlayerOne] containsObject:piece];
}

- (BOOL)canMovePiece:(SBPiece *)piece toLocation:(SBLocation *)location {
    SBMove *move = [SBMove moveWithPiece:piece to:location];
    return [[self currentState] isLegalMove:move];
}

- (void)movePiece:(SBPiece *)piece toLocation:(SBLocation *)location {
    NSLog(@"[%@ %s]", [self class], sel_getName(_cmd));

    SBMove *move = [SBMove moveWithPiece:piece to:location];
    SBState *state = [self currentState];
    NSParameterAssert([state isLegalMove:move]);

    SBState *newState = [state successorWithMove:move];

    [self.modelHelper endTurnOrMatch:self.turnBasedMatchHelper.currentMatch withMatchState:newState completionHandler:^(NSError *error) {
        if (error) NSLog(@"There was an error performing the move: %@", error);
    }];
}

#pragma mark Turn Based Match Helper Delegate

- (id<SBTurnBasedParticipant>)nextParticipantForMatch:(id<SBTurnBasedMatch>)match {
    return [self.modelHelper nextParticipantForMatch:match];
}

- (void)enterNewGame:(id<SBTurnBasedMatch>)match {
    NSLog(@"-[%@ %@]", NSStringFromClass([self class]), NSStringFromSelector(_cmd));
    self.forfeitButton.enabled = NO;

    id state = [self.turnBasedMatchHelper isLocalPlayerTurn:match]
            ? [SBBoardViewControllerUnselectedState state]
            : [SBBoardViewControllerReadonlyState state];
    [self transitionToState:state];

    [self.gridView layoutForState:[self stateForMatch:match]];
}

- (void)takeTurn:(id<SBTurnBasedMatch>)match {
    NSLog(@"-[%@ %@]", NSStringFromClass([self class]), NSStringFromSelector(_cmd));
    self.forfeitButton.enabled = YES;
    [self transitionToState:[SBBoardViewControllerUnselectedState state]];
    [self.gridView layoutForState:match.matchState];
}

- (void)layoutMatch:(id <SBTurnBasedMatch>)match {
    NSLog(@"-[%@ %@]", NSStringFromClass([self class]), NSStringFromSelector(_cmd));
    self.forfeitButton.enabled = NO;
    [self transitionToState:[SBBoardViewControllerReadonlyState state]];
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

    [self transitionToState:[SBBoardViewControllerGameOverState state]];

    self.forfeitButton.enabled = NO;
    [self.gridView layoutForState:match.matchState];

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

#pragma mark Board View Delegate

- (void)handleSingleTapWithPiece:(SBPiece *)piece {
    [self.state handleSingleTapWithPiece:piece];
}

- (void)handleSingleTapWithLocation:(SBLocation *)location {
    [self.state handleSingleTapWithLocation:location];
}

- (void)handleDoubleTapWithPiece:(SBPiece *)piece {
    [self.state handleDoubleTapWithPiece:piece];
}

- (void)handleDoubleTapWithLocation:(SBLocation *)location {
    [self.state handleDoubleTapWithLocation:location];
}

- (BOOL)shouldLongPressStartWithPiece:(SBPiece *)piece {
    return [self.state shouldLongPressStartWithPiece:piece];
}

- (void)longPressStartedWithPiece:(SBPiece *)piece atLocation:(SBLocation *)location {
    [self.state longPressStartedWithPiece:piece atLocation:location];
}

- (void)longPressEndedAtLocation:(SBLocation *)location {
    [self.state longPressEndedAtLocation:location];
}

#pragma mark Board View Controller State Delegate

- (void)transitionToState:(SBBoardViewControllerState *)state {
    state.delegate = self.state.delegate;
    state.gridView = self.state.gridView;
    self.state = state;
    [self.state transitionIn];
}

- (SBLocation *)locationOfPiece:(SBPiece *)piece {
    return [[self currentState] locationForPiece:piece];
}

- (void)setLegalDestinationsForPiece:(SBPiece *)piece highlighted:(BOOL)highlighted {
    SBState *state = self.currentState;
    [state enumerateLegalDestinationsForPiece:piece withBlock:^(SBLocation *location, BOOL *stop) {
        [self.gridView setCellHighlighted:highlighted atLocation:location];
    }];
}

@end
