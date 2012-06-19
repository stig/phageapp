//
//  SBViewController.m
//  Phage
//
//  Created by Stig Brautaset on 24/3/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "SBBoardViewController.h"
#import "SBPhageBoard.h"
#import "SBMove.h"
#import "SBTurnBasedParticipant.h"
#import "PhageModelHelper.h"
#import "SBBoardViewControllerStateUnselected.h"
#import "SBBoardViewControllerStateReadonly.h"
#import "SBBoardViewControllerStateGameOver.h"
#import "SBLocation.h"

@interface SBBoardViewController () < UIActionSheetDelegate >
@property(strong) UIActionSheet *forfeitActionSheet;
- (SBPhageBoard *)currentState;
- (SBPhageBoard *)stateForMatch:(id<SBTurnBasedMatch>)match;
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

- (SBPhageBoard *)stateForMatch:(id<SBTurnBasedMatch>)match {
    if (nil == match.matchState) {
        return [SBPhageBoard board];
    }
    return match.matchState;
}

- (SBPhageBoard *)currentState {
    return [self stateForMatch:self.turnBasedMatchHelper.currentMatch];
}

- (IBAction)forfeit {
    NSAssert([self.turnBasedMatchHelper isLocalPlayerTurn:self.turnBasedMatchHelper.currentMatch], @"Should be localPlayerTurn");
    self.forfeitActionSheet = [[UIActionSheet alloc] initWithTitle:@"Really forfeit match?" delegate:self cancelButtonTitle:@"No" destructiveButtonTitle:@"Yes" otherButtonTitles:nil];
    [self.forfeitActionSheet showInView:self.view];
}

- (BOOL)canCurrentPlayerMovePiece:(SBPiece *)piece {
    SBPhageBoard *state = [self currentState];
    NSUInteger playerTurn = state.currentPlayer;
    NSArray *pieces = [state.pieces objectAtIndex:playerTurn];
    return [pieces containsObject:piece];
}

- (BOOL)canMovePiece:(SBPiece *)piece toLocation:(SBLocation *)location {
    SBPhageBoard *state = [self currentState];
    SBLocation *from = [state locationForPiece:piece];
    SBMove *move = [SBMove moveWithFrom:from to:location];
    return [state isLegalMove:move];
}

- (void)movePiece:(SBPiece *)piece toLocation:(SBLocation *)location {
    TFLog(@"%s move %@ to %@", __PRETTY_FUNCTION__, piece, location);

    SBPhageBoard *state = [self currentState];
    SBLocation *from = [state locationForPiece:piece];
    SBMove *move = [SBMove moveWithFrom:from to:location];
    NSParameterAssert([state isLegalMove:move]);

    SBPhageBoard *newState = [state successorWithMove:move];

    [self.modelHelper endTurnOrMatch:self.turnBasedMatchHelper.currentMatch withMatchState:newState completionHandler:^(NSError *error) {
        if (error) TFLog(@"There was an error performing the move: %@", error);
    }];
}

#pragma mark Turn Based Match Helper Delegate

- (id<SBTurnBasedParticipant>)nextParticipantForMatch:(id<SBTurnBasedMatch>)match {
    return [self.modelHelper nextParticipantForMatch:match];
}

- (void)enterNewGame:(id<SBTurnBasedMatch>)match {
    self.forfeitButton.enabled = NO;

    id state = [self.turnBasedMatchHelper isLocalPlayerTurn:match]
            ? [SBBoardViewControllerStateUnselected state]
            : [SBBoardViewControllerStateReadonly state];

    [self transitionToState:state];
    [self.gridView layoutForState:[self stateForMatch:match]];
}

- (void)takeTurn:(id<SBTurnBasedMatch>)match {
    self.forfeitButton.enabled = YES;
    [self transitionToState:[SBBoardViewControllerStateUnselected state]];
    [self.gridView layoutForState:match.matchState];
}

- (void)layoutMatch:(id <SBTurnBasedMatch>)match {
    self.forfeitButton.enabled = NO;
    [self transitionToState:[SBBoardViewControllerStateReadonly state]];
    [self.gridView layoutForState:match.matchState];
}

- (void)sendTitle:(NSString*)title notice:(NSString *)notice forMatch:(id<SBTurnBasedMatch>)match {

    UIAlertView *av = [[UIAlertView alloc] initWithTitle:title
                                                 message:notice
                                                delegate:self
                                       cancelButtonTitle:@"Sweet!"
                                       otherButtonTitles:nil];
    [av show];
}

- (void)receiveEndGame:(id<SBTurnBasedMatch>)match {

    [self transitionToState:[SBBoardViewControllerStateGameOver state]];

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
    @synchronized (self) {
        state.delegate = self.state.delegate;
        state.gridView = self.state.gridView;
        self.state = state;
        [self.state transitionIn];
    }
}

- (SBLocation *)locationOfPiece:(SBPiece *)piece {
    return [[self currentState] locationForPiece:piece];
}

- (void)setLegalDestinationsForPiece:(SBPiece *)piece highlighted:(BOOL)highlighted {
    SBPhageBoard *state = self.currentState;
    [state enumerateLegalDestinationsForPiece:piece withBlock:^(SBLocation *location, BOOL *stop) {
        [self.gridView setCellHighlighted:highlighted atLocation:location];
    }];
}

@end
