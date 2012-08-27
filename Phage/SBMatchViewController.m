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
#import "SBHowtoViewController.h"
#import "SBCreateMatchViewController.h"
#import "SBSettingsViewController.h"
#import "SBBoardView.h"
#import "MBProgressHUD.h"

@interface SBMatchViewController () < SBBoardViewDelegate, SBHowtoViewControllerDelegate, UIPopoverControllerDelegate>

@property (weak, nonatomic) IBOutlet SBBoardView *board;

@property (strong, nonatomic) UIPopoverController *howtoPopoverController;

- (IBAction)trashMatch:(id)sender;

@end

@implementation SBMatchViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self layoutMatch];
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
    } else {
        return YES;
    }
}

#pragma mark - Howto View Controller

- (void)howtoViewControllerDidFinish:(SBHowtoViewController *)controller
{
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        [self dismissModalViewControllerAnimated:YES];
    } else {
        [self.howtoPopoverController dismissPopoverAnimated:YES];
        self.howtoPopoverController = nil;
    }
}

- (void)howtoControllerDidDismissPopover:(UIPopoverController *)popoverController
{
    self.howtoPopoverController = nil;
}


#pragma mark - Our Methods

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    [[segue destinationViewController] setDelegate:self];

    if ([[segue identifier] isEqualToString:@"showHowto"]) {

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

    [MBProgressHUD showHUDAddedTo:self.view animated:YES];

    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
        [NSThread sleepForTimeInterval: 2 * ANIM_DURATION];

        SBOpponentMobilityMinimisingMovePicker *pm = [[SBOpponentMobilityMinimisingMovePicker alloc] init];
        SBMove *move = [pm moveForState:board];

        dispatch_async(dispatch_get_main_queue(), ^{
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            if ([self.match isLegalMove:move]) {
                [self performMove:move];
            }
        });
    });
}

- (IBAction)trashMatch:(id)sender {
    SBAlertView *av;
    if (self.match.isGameOver) {
        av = [[SBAlertView alloc] initWithTitle:NSLocalizedString(@"Delete Match", @"Delete dialog title")
                                        message:NSLocalizedString(@"Really delete this match?", @"Delete dialog message")
                                     completion:^(SBAlertView* alertView, NSInteger buttonIndex) {
                                         if (alertView.cancelButtonIndex != buttonIndex) {
                                             [self.delegate matchViewController:self didDeleteMatch:self.match];
                                         }
                                     }
                              cancelButtonTitle:NSLocalizedString(@"Keep", @"Delete dialog negative button")
                              otherButtonTitles:NSLocalizedString(@"Delete", @"Delete dialog affirmative button"), nil];

    } else {
        av = [[SBAlertView alloc] initWithTitle:NSLocalizedString(@"Forfeit Match", @"Forfeit dialog title")
                                        message:NSLocalizedString(@"Do you really want to forfeit this match?", @"Forfeit dialog message")
                                     completion:^(SBAlertView* alertView, NSInteger buttonIndex) {
                                         if (alertView.cancelButtonIndex != buttonIndex) {
                                             [self.match forfeit];
                                             [self.delegate matchViewController:self didChangeMatch:self.match];
                                             [self layoutMatch];
                                         }
                                     }
                              cancelButtonTitle:NSLocalizedString(@"Continue", @"Forfeit dialog negative button")
                              otherButtonTitles:NSLocalizedString(@"Forfeit", @"Forfeit dialog affirmative button"), nil];
    }
    [av show];
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
        self.navigationItem.title = NSLocalizedString(@"Game Over", @"Game Over Title");

        SBPlayer *winner = self.match.winner;
        if (nil == winner) {
            self.navigationItem.prompt = NSLocalizedString(@"This match ended in a draw", @"Game Over message");
        } else {
            self.navigationItem.prompt = [NSString stringWithFormat:NSLocalizedString(@"This match was won by %@", @"Game Over message"), winner.alias];
        }

    } else {
        self.navigationItem.title = @"Match";

        if (self.match.currentPlayer.isHuman) {
            self.navigationItem.prompt = [NSString stringWithFormat:NSLocalizedString(@"%@, it is your turn!", @"Take Turn message"), self.match.currentPlayer.alias];
        } else {
            self.navigationItem.prompt = [NSString stringWithFormat:NSLocalizedString(@"Waiting for %@", @"Take Turn message"), self.match.currentPlayer.alias];
            [self performBotMove];
        }
    }
}


@end
