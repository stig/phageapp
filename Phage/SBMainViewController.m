//
//  SBMainViewController.m
//  Phage
//
//  Created by Stig Brautaset on 31/07/2012.
//
//

#import "SBMainViewController.h"
#import "PhageModel.h"
#import "SBAlertView.h"
#import "SBHowtoViewController.h"
#import "SBMatchMakerViewController.h"
#import "SBMatchLookupViewController.h"
#import "SBBoardView.h"
#import "MBProgressHUD.h"

@interface SBMainViewController () < SBBoardViewDelegate, SBMatchLookupViewControllerDelegate, SBMatchMakerViewControllerDelegate, SBHowtoViewControllerDelegate, UIPopoverControllerDelegate>

@property (weak, nonatomic) IBOutlet SBBoardView *board;
@property (weak, nonatomic) IBOutlet UILabel *playerOne;
@property (weak, nonatomic) IBOutlet UILabel *playerTwo;
@property (weak, nonatomic) IBOutlet UILabel *message;

@property (strong, nonatomic) SBMatchService *matchService;
@property (strong, nonatomic) UIPopoverController *howtoPopoverController;
@property (strong, nonatomic) SBMatch *match;

- (IBAction)trashMatch:(id)sender;

@end

@implementation SBMainViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    self.matchService = [SBMatchService matchService];
}

- (void)viewDidAppear:(BOOL)animated {
    // Called any time the view appears
    [self ensureMatch];
}

- (void)viewDidUnload
{
    [self setPlayerOne:nil];
    [self setPlayerTwo:nil];
    [self setMessage:nil];
    [self setBoard:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
    } else {
        return YES;
    }
}

#pragma mark - Match Lookup View Controller


- (void)matchLookupViewControllerDidFinish:(SBMatchLookupViewController *)controller {
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        [self dismissModalViewControllerAnimated:YES];
    }
}

- (void)matchLookupViewController:(SBMatchLookupViewController *)controller didFindMatch:(SBMatch *)match {
    [self matchLookupViewControllerDidFinish:controller];
    [self.matchService saveMatch:self.match];
    self.match = match;
}


#pragma mark - Match Maker View Controller

- (void)matchMakerViewController:(SBMatchMakerViewController *)controller didFindMatch:(SBMatch *)match {
    [self matchMakerViewControllerDidFinish:controller];
    [self.matchService saveMatch:self.match];
    self.match = match;
}


- (void)matchMakerViewControllerDidFinish:(SBMatchMakerViewController *)controller
{
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        [self dismissModalViewControllerAnimated:YES];
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
    if ([[segue identifier] isEqualToString:@"showHowto"]) {
        [[segue destinationViewController] setDelegate:self];

        if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
            UIPopoverController *popoverController = [(UIStoryboardPopoverSegue *)segue popoverController];
            self.howtoPopoverController = popoverController;
            popoverController.delegate = self;
        }

    } else if ([[segue identifier] isEqualToString:@"showMatchMaker"]) {
        [[segue destinationViewController] setDelegate:self];

    } else if ([[segue identifier] isEqualToString:@"showMatchLookup"]) {
        [[segue destinationViewController] setDelegate:self];

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

- (void)ensureMatch {
    if (nil == self.match) {
        NSArray *savedMatches = [self.matchService activeMatches];
        if (savedMatches.count > 0) {
            self.match = [savedMatches objectAtIndex:0];

        } else {
            SBPlayer *bot = [SBPlayer playerWithAlias:NSLocalizedString(@"Sgt Pepper", @"Default AI Name") human:NO];
            SBPlayer *human = [SBPlayer playerWithAlias:NSLocalizedString(@"Player 1", @"Default Human Name") human:YES];
            self.match = [SBMatch matchWithPlayerOne:human two:bot];
        }
    }
}

- (void)setMatch:(SBMatch*)match {
    _match = match;
    self.playerOne.text = self.match.playerOne.alias;
    self.playerTwo.text = self.match.playerTwo.alias;
    [self layoutMatch];
}

- (void)layoutMatch {
    [self.board layoutBoard:self.match.board];
}


// It is assumed that this will not be called if the match is finished..
- (void)performBotMove {
    SBBoard *board = [self.match.board copy];

    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.dimBackground = YES;

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
                                             [self.matchService deleteMatch:self.match];
                                             self.match = nil;
                                             [self performSelector:@selector(ensureMatch) withObject:nil
                                                        afterDelay:0.0];
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
                                             [self.matchService saveMatch:self.match];
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
        [self.matchService saveMatch:self.match];
        [self layoutMatch];
    }];

    if (self.match.isGameOver) [TestFlight passCheckpoint:@"GAME_OVER"];

}

- (BOOL)shouldAcceptUserInput {
    return self.match.currentPlayer.isHuman;
}

- (void)didLayoutBoard {
    if (self.match.isGameOver) {
        SBPlayer *winner = self.match.winner;
        if (nil == winner) {
            self.message.text = NSLocalizedString(@"This match ended in a draw", @"Game Over message");
        } else {
            self.message.text = [NSString stringWithFormat:NSLocalizedString(@"This match was won by %@", @"Game Over message"), winner.alias];
        }
    } else if (self.match.currentPlayer.isHuman) {
        self.message.text = [NSString stringWithFormat:NSLocalizedString(@"%@, it is your turn!", @"Take Turn message"), self.match.currentPlayer.alias];
    } else {
        self.message.text = [NSString stringWithFormat:NSLocalizedString(@"Waiting for %@", @"Take Turn message"), self.match.currentPlayer.alias];
        [self performBotMove];
    }
}


@end
