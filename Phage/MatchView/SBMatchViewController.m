//
//  SBViewController.m
//  Phage
//
//  Created by Stig Brautaset on 24/3/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "SBMatchViewController.h"
#import "SBBoard.h"
#import "SBMove.h"
#import "SBMatchViewControllerStateUnselected.h"
#import "SBMatchViewControllerStateReadonly.h"
#import "SBMatchViewControllerStateGameOver.h"
#import "SBLocation.h"
#import "SBMatch.h"
#import "SBPlayer.h"

@interface SBMatchViewController () < UIActionSheetDelegate >
@property(strong) UIActionSheet *forfeitActionSheet;
@end

@implementation SBMatchViewController

@synthesize gridView = _gridView;
@synthesize forfeitActionSheet = _forfeitActionSheet;
@synthesize forfeitButton = _forfeitButton;
@synthesize state = _state;
@synthesize match = _match;
@synthesize checkPointBaseName = _checkPointBaseName;


- (void)viewDidLoad {
    [super viewDidLoad];
    self.state = [SBMatchViewControllerStateUnselected state];
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
    id<SBPlayer> player = self.match.currentPlayer;
    NSAssert(player.isLocalHuman, @"Player should be local Human");
    self.forfeitActionSheet = [[UIActionSheet alloc] initWithTitle:@"Really forfeit match?" delegate:self cancelButtonTitle:@"No" destructiveButtonTitle:@"Yes" otherButtonTitles:nil];
    [self.forfeitActionSheet showInView:self.view];
}

- (BOOL)canCurrentPlayerMovePiece:(SBPiece *)piece {
    return [self.match canCurrentPlayerMovePiece:piece];
}

- (SBMove *)moveWithPiece:(SBPiece *)piece location:(SBLocation *)location {
    SBLocation *locationOfPiece = [self.match.board locationForPiece:piece];
    return [SBMove moveWithFrom:locationOfPiece to:location];
}

- (BOOL)canMovePiece:(SBPiece *)piece toLocation:(SBLocation *)location {
    SBMove *move = [self moveWithPiece:piece location:location];
    return [self.match isLegalMove:move];
}

- (void)handleNotifyGameOver {
    id<SBPlayer> winner = self.match.winner;
    NSString *message = nil == winner ? @"It's a draw!" : [winner.alias stringByAppendingString:@" won!"];
    [[[UIAlertView alloc] initWithTitle:@"Game Over" message:message delegate:nil cancelButtonTitle:@"Great!" otherButtonTitles:nil] show];
}

- (void)movePiece:(SBPiece *)piece toLocation:(SBLocation *)location {
    SBMove *move = [self moveWithPiece:piece location:location];
    TFLog(@"%s move: %@", __PRETTY_FUNCTION__, move);
    [self.match performMove:move completionHandler:^void(NSError *error) {
        if (error) {
            TFLog(@"%s move: %@ failed to apply to board: %@", __PRETTY_FUNCTION__, move, self.match.board);
            return;
        }

        [self.gridView movePiece:piece toLocation:location];
        [self.gridView setLocation:move.from blocked:YES];
        [self.gridView putDownPiece:piece];

        if ([self.match isGameOver]) {
            [self transitionToState:[SBMatchViewControllerStateGameOver state]];
            [self handleNotifyGameOver];
            [TestFlight passCheckpoint:[@"FINISHED_" stringByAppendingString:self.checkPointBaseName]];
        } else {
            [self transitionToState:[SBMatchViewControllerStateUnselected state]];
        }
    }];
}

#pragma mark UIActionSheetDelegate

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    if ([actionSheet isEqual:self.forfeitActionSheet]) {
        if ([actionSheet destructiveButtonIndex] == buttonIndex) {
            [self.match forfeit];
            [self transitionToState:[SBMatchViewControllerStateGameOver state]];
            [self handleNotifyGameOver];
            [TestFlight passCheckpoint:[@"FORFEITED_" stringByAppendingString:self.checkPointBaseName]];

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

- (void)transitionToState:(SBMatchViewControllerState *)state {
    @synchronized (self) {
        state.delegate = self.state.delegate;
        state.gridView = self.state.gridView;
        self.state = state;
        [self.state transitionIn];
    }
}

- (SBLocation *)locationOfPiece:(SBPiece *)piece {
    return [self.match.board locationForPiece:piece];
}

- (void)setLegalDestinationsForPiece:(SBPiece *)piece highlighted:(BOOL)highlighted {
    [self.match.board enumerateLegalDestinationsForPiece:piece withBlock:^(SBLocation *location, BOOL *stop) {
        [self.gridView setCellHighlighted:highlighted atLocation:location];
    }];
}

@end
