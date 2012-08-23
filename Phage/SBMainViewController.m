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
#import "SBFlipsideViewController.h"
#import "SBMatchMakerViewController.h"
#import "SBMatchLookupViewController.h"
#import "SBBoardView.h"

@interface SBMainViewController () < SBBoardViewDelegate, SBMatchLookupViewControllerDelegate, SBMatchMakerViewControllerDelegate, SBFlipsideViewControllerDelegate, UIPopoverControllerDelegate>

@property (weak, nonatomic) IBOutlet SBBoardView *board;
@property (weak, nonatomic) IBOutlet UILabel *playerOne;
@property (weak, nonatomic) IBOutlet UILabel *playerTwo;
@property (weak, nonatomic) IBOutlet UILabel *message;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *spinner;

@property (strong, nonatomic) SBMatchService *matchService;
@property (strong, nonatomic) UIPopoverController *flipsidePopoverController;
@property (strong, nonatomic) SBMatch *match;

- (IBAction)trashMatch:(id)sender;

@end

@implementation SBMainViewController
@synthesize playerOne = _playerOne;
@synthesize playerTwo = _playerTwo;
@synthesize message = _message;
@synthesize match = _match;
@synthesize board = _board;

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    self.matchService = [SBMatchService matchService];
    self.spinner.hidesWhenStopped = YES;
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
    [self setSpinner:nil];
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

#pragma mark - Flipside View Controller

- (void)flipsideViewControllerDidFinish:(SBFlipsideViewController *)controller
{
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        [self dismissModalViewControllerAnimated:YES];
    } else {
        [self.flipsidePopoverController dismissPopoverAnimated:YES];
        self.flipsidePopoverController = nil;
    }
}

- (void)popoverControllerDidDismissPopover:(UIPopoverController *)popoverController
{
    self.flipsidePopoverController = nil;
}

#pragma mark - Our Methods

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"showAlternate"]) {
        [[segue destinationViewController] setDelegate:self];

        if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
            UIPopoverController *popoverController = [(UIStoryboardPopoverSegue *)segue popoverController];
            self.flipsidePopoverController = popoverController;
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
    if (self.flipsidePopoverController) {
        [self.flipsidePopoverController dismissPopoverAnimated:YES];
        self.flipsidePopoverController = nil;
    } else {
        [self performSegueWithIdentifier:@"showAlternate" sender:sender];
    }
}

- (void)ensureMatch {
    if (nil == self.match) {
        NSArray *savedMatches = [self.matchService activeMatches];
        if (savedMatches.count > 0) {
            self.match = [savedMatches objectAtIndex:0];

        } else {
            SBPlayer *bot = [SBPlayer playerWithAlias:@"Sgt Pepper" human:NO];
            SBPlayer *human = [SBPlayer playerWithAlias:@"Player 1" human:YES];
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
    [self.spinner startAnimating];

    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        NSLog(@"Sleeping a bit..");
        [NSThread sleepForTimeInterval:3.0];

        SBOpponentMobilityMinimisingMovePicker *pm = [[SBOpponentMobilityMinimisingMovePicker alloc] init];
        SBMove *move = [pm moveForState:board];

        dispatch_async(dispatch_get_main_queue(), ^{
            [self.spinner stopAnimating];
            if ([self.match isLegalMove:move]) {
                [self performMove:move];
            }
        });
    });
}

- (IBAction)trashMatch:(id)sender {
    SBAlertView *av;
    if (self.match.isGameOver) {
        av = [[SBAlertView alloc] initWithTitle:@"Delete Match"
                                        message:@"Really delete this match?"
                                     completion:^(NSInteger buttonIndex) {
                                         [self.matchService deleteMatch:self.match];
                                         self.match = nil;
                                         [self performSelector:@selector(ensureMatch) withObject:nil afterDelay:0.0];
                                     }
                              cancelButtonTitle:@"Yes"
                              otherButtonTitles:@"No", nil];

    } else {
        av = [[SBAlertView alloc] initWithTitle:@"Forfeit Match"
                                        message:@"Do you really want to forfeit this match?"
                                     completion:^(NSInteger buttonIndex) {
                                         if (0 == buttonIndex) {
                                             [self.match forfeit];
                                             [self.matchService saveMatch:self.match];
                                             [self layoutMatch];
                                         }
                                     }
                              cancelButtonTitle:@"Yes"
                              otherButtonTitles:@"No", nil];
    }
    [av show];
}

#pragma mark - Board View Delegate

- (void)performMove:(SBMove *)move {
    [self.match performMove:move completionHandler:^(NSError *error) {
        [self.matchService saveMatch:self.match];
        [self layoutMatch];
    }];
}

- (BOOL)shouldAcceptUserInput {
    return self.match.currentPlayer.isHuman;
}

- (void)didLayoutBoard {
    if (self.match.isGameOver) {
        SBPlayer *winner = self.match.winner;
        if (nil == winner) {
            self.message.text = @"This match ended in a draw";
        } else {
            self.message.text = [NSString stringWithFormat:@"This match was won by %@", winner.alias];
        }
    } else if (self.match.currentPlayer.isHuman) {
        self.message.text = [self.match.currentPlayer.alias stringByAppendingFormat:@", it is your turn!"];
    } else {
        self.message.text = [NSString stringWithFormat:@"Waiting for %@..", self.match.currentPlayer.alias];
        [self performBotMove];
    }
}


@end
