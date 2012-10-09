//
//  SBMatchViewController.m
//  Phage
//
//  Created by Stig Brautaset on 31/07/2012.
//
//

#import <iAd/iAd.h>
#import "SBMatchViewController.h"
#import "SBAlertView.h"
#import "SBBoardView.h"
#import "MBProgressHUD.h"
#import "SBWebViewController.h"
#import "SBAnalytics.h"
#import "SBMatch.h"
#import "SBBoard.h"
#import "SBMovePicker.h"
#import "SBPlayer.h"

@interface SBMatchViewController () < SBBoardViewDelegate, UIPopoverControllerDelegate, ADBannerViewDelegate>

@property (weak, nonatomic) IBOutlet SBBoardView *board;
@property (weak, nonatomic) IBOutlet UILabel *turnLabel;
@property (weak, nonatomic) IBOutlet ADBannerView *banner;

@property (strong, nonatomic) UIPopoverController *howtoPopoverController;

@end

@implementation SBMatchViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    self.turnLabel.text = @"";
    self.banner.alpha = 0.0;

    NSString *state = nil;
    if (self.match.isGameOver) state = @"GAME_OVER";
    else if (self.match.board.moveHistory.count > 0) state = @"IN_PROCESS";
    else state = @"STARTING";
    [SBAnalytics logEvent:@"SHOW_MATCH" withParameters:@{ @"STATE": state } timed:YES];
}

- (void)viewDidAppear:(BOOL)animated {
    [self layoutMatch];
}

- (void)dealloc {
    [SBAnalytics endTimedEvent:@"SHOW_MATCH"];
}


#pragma mark - Our Methods

- (IBAction)togglePopover:(id)sender
{
    if (self.howtoPopoverController) {
        [self.howtoPopoverController dismissPopoverAnimated:YES];
        self.howtoPopoverController = nil;
    } else {
        [self performSegueWithIdentifier:@"showHowto" sender:sender];
    }
}

- (void)layoutMatch {
    [self.board layoutBoard:self.match.board];
}


// It is assumed that this will not be called if the match is finished..
- (void)performBotMove {
    SBBoard *board = [self.match.board copy];

    [MBProgressHUD showHUDAddedTo:self.board animated:YES];

    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
        [NSThread sleepForTimeInterval: ANIM_DURATION];

        id<SBMovePicker> pm = [self.match.currentPlayer movePicker];
        SBMove *move = [pm moveForState:board];

        dispatch_async(dispatch_get_main_queue(), ^{
            [MBProgressHUD hideHUDForView:self.board animated:YES];
            if ([self.match isLegalMove:move]) {
                [self performMove:move];
            }
        });
    });
}

- (void)deleteMatch {
    [[[SBAlertView alloc]
            initWithTitle:NSLocalizedString(@"Delete Match?", @"Delete dialog title") message:[self cannotUndoMessage]
               completion:^(SBAlertView *alertView, NSInteger buttonIndex) {
                   NSString *status = @"DELETE";
                   if (alertView.cancelButtonIndex != buttonIndex) {
                       [self.delegate matchViewController:self didDeleteMatch:self.match];
                   } else {
                       status = @"KEEP";
                   }
                   [SBAnalytics logEvent:@"DELETE_MATCH" withParameters:@{ @"BUTTON": status }];
               }
        cancelButtonTitle:NSLocalizedString(@"Keep", @"Delete dialog negative button")
        otherButtonTitles:NSLocalizedString(@"Delete", @"Delete dialog affirmative button"), nil] show];
}

- (void)forfeitMatch {
    [[[SBAlertView alloc]
            initWithTitle:NSLocalizedString(@"Forfeit Match?", @"Forfeit dialog title") message:[self cannotUndoMessage]
               completion:^(SBAlertView *alertView, NSInteger buttonIndex) {
                   NSString *status = @"FORFEIT";
                   if (alertView.cancelButtonIndex != buttonIndex) {
                       [self.match forfeit];
                       [self.delegate matchViewController:self didChangeMatch:self.match];
                       [self layoutMatch];
                   } else {
                       status = @"CONTINUE";
                   }
                   [SBAnalytics logEvent:@"FORFEIT_MATCH" withParameters:@{ @"BUTTON" : status }];
               }
        cancelButtonTitle:NSLocalizedString(@"Continue", @"Forfeit dialog negative button")
        otherButtonTitles:NSLocalizedString(@"Forfeit", @"Forfeit dialog affirmative button"), nil] show];
}

- (NSString *)cannotUndoMessage {
    return NSLocalizedString(@"This cannot be undone.", @"Dialog message");
}

#pragma mark - Board View Delegate

- (void)performMove:(SBMove *)move {
    [self.match performMove:move completionHandler:^(NSError *error) {
        [self.delegate matchViewController:self didChangeMatch:self.match];
        [self layoutMatch];
    }];

    if (self.match.isGameOver) {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.board animated:YES];
        hud.mode = MBProgressHUDModeText;
        [hud hide:YES afterDelay:3.0];

        NSString *outcome = nil;
        id<SBPlayer> winner = self.match.winner;
        if (nil == winner) {
            outcome = @"DRAW";
            hud.labelText = NSLocalizedString(@"It's a draw!", @"It's a draw!");
            hud.detailsLabelText = NSLocalizedString(@"How about a rematch?", @"Game over popup message - draw");
        } else {
            outcome = [self.match.playerOne isEqual:winner] ? @"PLAYER1" : @"PLAYER2";
            hud.labelText = NSLocalizedString(@"Game Over!", @"Game Over!");
            hud.detailsLabelText = [NSString stringWithFormat:NSLocalizedString(@"%@ won!", @"Game Over popup message - win"), winner.alias];
        }

        [SBAnalytics logEvent:@"FINISH_MATCH" withParameters:@{
            @"PLAYER1": NSStringFromClass(self.match.playerOne.class),
            @"PLAYER2": NSStringFromClass(self.match.playerTwo.class),
            @"RESULT": outcome
        }];

    }

}

- (BOOL)shouldAcceptUserInput {
    if (!self.match.currentPlayer.isHuman)
        return NO;
    return !self.match.isGameOver;
}

- (void)didLayoutBoard {
    if (self.match.isGameOver) {
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]
                initWithBarButtonSystemItem:UIBarButtonSystemItemTrash
                                     target:self
                                     action:@selector(deleteMatch)];

        self.navigationItem.title = NSLocalizedString(@"Game Over", @"Game Over Title");

        id<SBPlayer> winner = self.match.winner;
        if (nil == winner) {
            self.turnLabel.text = NSLocalizedString(@"This match ended in a draw", @"Game Over message");
        } else {
            self.turnLabel.text = [NSString stringWithFormat:NSLocalizedString(@"%@ won", @"Game Over message"), winner.alias];
        }

    } else {
        self.navigationItem.title = @"Match";
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]
                initWithBarButtonSystemItem:UIBarButtonSystemItemStop
                                     target:self
                                     action:@selector(forfeitMatch)];

        self.turnLabel.text = [NSString stringWithFormat:NSLocalizedString(@"Waiting for %@", @"Take Turn message"), self.match.currentPlayer.alias];
        if (self.match.currentPlayer.isHuman) {
            [self.board dimUnmoveablePieces];
            [self.board brieflyHighlightPiecesForCurrentPlayer];
        } else {
            [self performBotMove];
        }
    }
}

#pragma mark Banner View Delegate

- (void)bannerViewDidLoadAd:(ADBannerView *)banner {
    banner.alpha = 1.0;
}

- (void)bannerView:(ADBannerView *)banner didFailToReceiveAdWithError:(NSError *)error {
    banner.alpha = 0.0;
}

@end
