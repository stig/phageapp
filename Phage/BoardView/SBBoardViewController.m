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
#import "SBBoardViewReadonlyState.h"
#import "SBBoardViewUnselectedState.h"
#import "SBBoardViewGameOverState.h"

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

    id<SBBoardViewState> newState = [self.turnBasedMatchHelper isLocalPlayerTurn:match]
            ? [SBBoardViewUnselectedState state]
            : [SBBoardViewReadonlyState state];

    [self.gridView layoutForState:[self stateForMatch:match] state:newState];
}

- (void)takeTurn:(id<SBTurnBasedMatch>)match {
    NSLog(@"-[%@ %@]", NSStringFromClass([self class]), NSStringFromSelector(_cmd));
    self.forfeitButton.enabled = YES;
    [self.gridView layoutForState:match.matchState state:[SBBoardViewUnselectedState state]];
}

- (void)layoutMatch:(id <SBTurnBasedMatch>)match {
    NSLog(@"-[%@ %@]", NSStringFromClass([self class]), NSStringFromSelector(_cmd));
    self.forfeitButton.enabled = NO;
    [self.gridView layoutForState:match.matchState state:[SBBoardViewReadonlyState state]];
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

    self.forfeitButton.enabled = NO;
    [self.gridView layoutForState:match.matchState state:[SBBoardViewGameOverState state]];

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
    NSLog(@"[%@ %s]", [self class], sel_getName(_cmd));
}

- (void)handleSingleTapWithLocation:(SBLocation *)location {
    NSLog(@"[%@ %s]", [self class], sel_getName(_cmd));
}

- (void)handleDoubleTapWithPiece:(SBPiece *)piece {
    NSLog(@"[%@ %s]", [self class], sel_getName(_cmd));
}

- (void)handleDoubleTapWithLocation:(SBLocation *)location {
    NSLog(@"[%@ %s]", [self class], sel_getName(_cmd));
}

- (BOOL)shouldLongPressStartWithPiece:(SBPiece *)piece {
    NSLog(@"[%@ %s]", [self class], sel_getName(_cmd));
    return NO;
}

- (void)longPressStartedWithPiece:(SBPiece *)piece {
    NSLog(@"[%@ %s]", [self class], sel_getName(_cmd));
}

- (BOOL)shouldLongPressStartWithLocation:(SBLocation *)location {
    NSLog(@"[%@ %s]", [self class], sel_getName(_cmd));
    return NO;
}

- (void)longPressStartedWithLocation:(SBLocation *)location {
    NSLog(@"[%@ %s]", [self class], sel_getName(_cmd));

}


@end
