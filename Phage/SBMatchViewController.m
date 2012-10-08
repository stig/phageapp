//
//  SBMatchViewController.m
//  Phage
//
//  Created by Stig Brautaset on 31/07/2012.
//
//

#import <iAd/iAd.h>
#import "SBMatchViewController.h"
#import "PhageModel.h"
#import "SBAlertView.h"
#import "SBBoardView.h"
#import "MBProgressHUD.h"
#import "SBWebViewController.h"
#import "SBAnalytics.h"

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
}

- (void)viewDidAppear:(BOOL)animated {
    [self layoutMatch];
}


#pragma mark - Our Methods

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"showHowto"]) {
        [segue.destinationViewController setDocumentName:@"HowToPlay.html"];
        [SBAnalytics logEvent:@"SHOW_HOWTO"];

        if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
            UIPopoverController *popoverController = [(UIStoryboardPopoverSegue *)segue popoverController];
            self.howtoPopoverController = popoverController;
            popoverController.delegate = self;
        }
    }

}

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

        SBOpponentMobilityMinimisingMovePicker *pm = [[SBOpponentMobilityMinimisingMovePicker alloc] init];
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
                   if (alertView.cancelButtonIndex != buttonIndex) {
                       [self.delegate matchViewController:self didDeleteMatch:self.match];
                       [SBAnalytics logEvent:@"DELETE_MATCH"];
                   }
               }
        cancelButtonTitle:NSLocalizedString(@"Keep", @"Delete dialog negative button")
        otherButtonTitles:NSLocalizedString(@"Delete", @"Delete dialog affirmative button"), nil] show];
}

- (void)forfeitMatch {
    [[[SBAlertView alloc]
            initWithTitle:NSLocalizedString(@"Forfeit Match?", @"Forfeit dialog title") message:[self cannotUndoMessage]
               completion:^(SBAlertView *alertView, NSInteger buttonIndex) {
                   if (alertView.cancelButtonIndex != buttonIndex) {
                       [self.match forfeit];
                       [self.delegate matchViewController:self didChangeMatch:self.match];
                       [self layoutMatch];
                       [SBAnalytics logEvent:@"FORFEIT_MATCH" withParameters:@{
                           @"PLAYER1": self.match.playerOne.isHuman ? @"HUMAN" : @"SGT_PEPPER",
                           @"PLAYER2": self.match.playerTwo.isHuman ? @"HUMAN" : @"SGT_PEPPER",
                       }];
                   }
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
        SBPlayer *winner = self.match.winner;
        if (nil == winner) {
            outcome = @"DRAW";
            hud.labelText = NSLocalizedString(@"It's a draw!", @"It's a draw!");
            hud.detailsLabelText = NSLocalizedString(@"How about a rematch?", @"Game over popup message - draw");
        } else {
            outcome = [self.match.playerOne isEqual:winner] ? @"PLAYER1" : @"PLAYER2";
            hud.labelText = NSLocalizedString(@"Game Over!", @"Game Over!");
            hud.detailsLabelText = [NSString stringWithFormat:NSLocalizedString(@"%@ won!", @"Game Over popup message - win"), winner.alias];
        }

        // TODO: fix to not hardcode AI when we have multiple AIs
        [SBAnalytics logEvent:@"FINISH_MATCH" withParameters:@{
            @"PLAYER1": self.match.playerOne.isHuman ? @"HUMAN" : @"SGT_PEPPER",
            @"PLAYER2": self.match.playerTwo.isHuman ? @"HUMAN" : @"SGT_PEPPER",
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

        SBPlayer *winner = self.match.winner;
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
