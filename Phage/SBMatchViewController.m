//
//  SBMatchViewController.m
//  Phage
//
//  Created by Stig Brautaset on 31/07/2012.
//
//

#import "SBMatchViewController.h"
#import "PhageModel.h"
#import "SBAlertView.h"
#import "SBBoardView.h"
#import "MBProgressHUD.h"
#import "SBWebViewController.h"

@interface SBMatchViewController () < SBBoardViewDelegate, UIPopoverControllerDelegate>

@property (weak, nonatomic) IBOutlet SBBoardView *board;
@property (weak, nonatomic) IBOutlet UILabel *turnLabel;

@property (strong, nonatomic) UIPopoverController *howtoPopoverController;

@end

@implementation SBMatchViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.turnLabel.text = @"";
}

- (void)viewDidAppear:(BOOL)animated {
    [self layoutMatch];
}


#pragma mark - Our Methods

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"showHowto"]) {
        [segue.destinationViewController setDocumentName:@"HowToPlay.html"];
        [TestFlight passCheckpoint:@"SHOW_HOWTO"];


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
    [[[SBAlertView alloc] initWithTitle:NSLocalizedString(@"Delete Match?", @"Delete dialog title")
                                message:NSLocalizedString(@"This cannot be undone.", @"Delete dialog message")
                             completion:^(SBAlertView *alertView, NSInteger buttonIndex) {
                                 if (alertView.cancelButtonIndex != buttonIndex) {
                                     [self.delegate matchViewController:self didDeleteMatch:self.match];
                                 }
                             }
                      cancelButtonTitle:NSLocalizedString(@"Keep", @"Delete dialog negative button")
                      otherButtonTitles:NSLocalizedString(@"Delete", @"Delete dialog affirmative button"), nil] show];
}

- (void)forfeitMatch {
    [[[SBAlertView alloc] initWithTitle:NSLocalizedString(@"Forfeit Match?", @"Forfeit dialog title")
                          message:NSLocalizedString(@"This cannot be undone.", @"Forfeit dialog message")
                             completion:^(SBAlertView *alertView, NSInteger buttonIndex) {
                                 if (alertView.cancelButtonIndex != buttonIndex) {
                                     [self.match forfeit];
                                     [self.delegate matchViewController:self didChangeMatch:self.match];
                                     [self layoutMatch];
                                 }
                             }
                      cancelButtonTitle:NSLocalizedString(@"Continue", @"Forfeit dialog negative button")
                      otherButtonTitles:NSLocalizedString(@"Forfeit", @"Forfeit dialog affirmative button"), nil] show];
}

#pragma mark - Board View Delegate

- (void)performMove:(SBMove *)move {
    [self.match performMove:move completionHandler:^(NSError *error) {
        [self.delegate matchViewController:self didChangeMatch:self.match];
        [self layoutMatch];
    }];

    if (self.match.isGameOver) [TestFlight passCheckpoint:@"GAME_OVER"];

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

        self.turnLabel.text = [NSString stringWithFormat:NSLocalizedString(@"Waiting for %@...", @"Take Turn message"), self.match.currentPlayer.alias];
        if (self.match.currentPlayer.isHuman) {
            [self.board brieflyHighlightPiecesForCurrentPlayer];
        } else {
            [self performBotMove];
        }
    }
}

@end
