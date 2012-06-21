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
#import "SBPhageMatch.h"
#import "SBPlayer.h"

@interface SBBoardViewController () < UIActionSheetDelegate >
@property(strong) UIActionSheet *forfeitActionSheet;
@end

@implementation SBBoardViewController

@synthesize gridView = _gridView;
@synthesize forfeitActionSheet = _forfeitActionSheet;
@synthesize forfeitButton = _forfeitButton;
@synthesize state = _state;
@synthesize phageMatch = _phageMatch;


- (void)viewDidLoad {
    [super viewDidLoad];
    self.state = [SBBoardViewControllerStateUnselected state];
    self.state.delegate = self;
    self.state.gridView = self.gridView;
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
    id<SBPlayer> player = self.phageMatch.currentPlayer;
    NSAssert(player.isLocalHuman, @"Player should be local Human");
    self.forfeitActionSheet = [[UIActionSheet alloc] initWithTitle:@"Really forfeit match?" delegate:self cancelButtonTitle:@"No" destructiveButtonTitle:@"Yes" otherButtonTitles:nil];
    [self.forfeitActionSheet showInView:self.view];
}

- (BOOL)canCurrentPlayerMovePiece:(SBPiece *)piece {
    return [self.phageMatch canCurrentPlayerMovePiece:piece];
}

- (SBMove *)moveWithPiece:(SBPiece *)piece location:(SBLocation *)location {
    SBLocation *locationOfPiece = [self.phageMatch.board locationForPiece:piece];
    return [SBMove moveWithFrom:locationOfPiece to:location];
}

- (BOOL)canMovePiece:(SBPiece *)piece toLocation:(SBLocation *)location {
    SBMove *move = [self moveWithPiece:piece location:location];
    return [self.phageMatch isLegalMove:move];
}

- (void)movePiece:(SBPiece *)piece toLocation:(SBLocation *)location {
    TFLog(@"%s move %@ to %@", __PRETTY_FUNCTION__, piece, location);

    @synchronized (self) {
        if ([self canMovePiece:piece toLocation:location])
            [self.phageMatch performMove:[self moveWithPiece:piece location:location]];
    }

    if ([self.phageMatch isGameOver]) {
        [self transitionToState:[SBBoardViewControllerStateGameOver state]];
        id<SBPlayer> winner = self.phageMatch.winner;
        NSString *message = nil == winner ? @"It's a draw!" : [winner.alias stringByAppendingString:@" won!"];
        [[[UIAlertView alloc] initWithTitle:@"Game Over" message:message delegate:nil cancelButtonTitle:@"Great!" otherButtonTitles:nil] show];
    } else {
        [self.gridView layoutForState:self.phageMatch.board];
        [self transitionToState:[SBBoardViewControllerStateUnselected state]];
    }
}

#pragma mark UIActionSheetDelegate

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    if ([actionSheet isEqual:self.forfeitActionSheet]) {
        if ([actionSheet destructiveButtonIndex] == buttonIndex) {
            @throw @"Unimplemented";
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
    return [self.phageMatch.board locationForPiece:piece];
}

- (void)setLegalDestinationsForPiece:(SBPiece *)piece highlighted:(BOOL)highlighted {
    [self.phageMatch.board enumerateLegalDestinationsForPiece:piece withBlock:^(SBLocation *location, BOOL *stop) {
        [self.gridView setCellHighlighted:highlighted atLocation:location];
    }];
}

@end
