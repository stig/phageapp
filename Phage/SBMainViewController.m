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



@interface SBMainViewController () <SBFlipsideViewControllerDelegate, UIPopoverControllerDelegate>

@property (weak, nonatomic) IBOutlet UIView *board;
@property (weak, nonatomic) IBOutlet UILabel *playerOne;
@property (weak, nonatomic) IBOutlet UILabel *playerTwo;
@property (weak, nonatomic) IBOutlet UILabel *message;

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

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"showAlternate"]) {
        [[segue destinationViewController] setDelegate:self];
        
        if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
            UIPopoverController *popoverController = [(UIStoryboardPopoverSegue *)segue popoverController];
            self.flipsidePopoverController = popoverController;
            popoverController.delegate = self;
        }
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

- (SBMatch *)matchWithBotNamed:(NSString *)botName andHumanNamed:(NSString *)playerName {
    SBPlayer *bot = [SBPlayer playerWithAlias:botName];
    bot.localHuman = NO;

    SBPlayer *human = [SBPlayer playerWithAlias:playerName];
    human.localHuman = YES;

    return [SBMatch matchWithPlayerOne:human two:bot];
}

- (void)ensureMatch {
    if (nil == self.match) {
        NSArray *savedMatches = [[SBMatchService new] activeMatches];
        if (savedMatches.count > 0) {
            self.match = [savedMatches objectAtIndex:0];

        } else {
            self.match = [self matchWithBotNamed:@"Sgt Pepper" andHumanNamed:@"Player 1"];
            SBAlertView *av = [[SBAlertView alloc]
                    initWithTitle:NSLocalizedString(@"NEW_1P_MATCH_ALERT.TITLE", @"I created a match for you...")
                          message:NSLocalizedString(@"NEW_1P_MATCH_ALERT.MESSAGE", @"I created a match for you...")
                       completion:nil cancelButtonTitle:NSLocalizedString(@"NEW_1P_MATCH_ALERT.BUTTON", @"Okay")
                otherButtonTitles:nil];
            [av show];
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
    if (self.match.isGameOver) {
        SBPlayer *winner = self.match.winner;
        if (nil == winner) {
            self.message.text = @"This match ended in a draw";
        } else {
            self.message.text = [NSString stringWithFormat:@"This match was won by %@", winner.alias];
        }
    } else {
        self.message.text = [self.match.currentPlayer.alias stringByAppendingFormat:@", it is your turn!"];
    }
}

- (IBAction)trashMatch:(id)sender {
    SBAlertView *av;
    if (self.match.isGameOver) {
        av = [[SBAlertView alloc] initWithTitle:@"Delete Match"
                                        message:@"Really delete this match?"
                                     completion:^(NSInteger buttonIndex) {
                                         [[SBMatchService new] deleteMatch:self.match];
                                         self.match = nil;
                                         [self performSelector:@selector(ensureMatch) withObject:nil afterDelay:0.5];
                                     }
                              cancelButtonTitle:@"Yes"
                              otherButtonTitles:@"No", nil];

    } else {
        av = [[SBAlertView alloc] initWithTitle:@"Forfeit Match"
                                                     message:@"Do you really want to forfeit this match?"
                                                  completion:^(NSInteger buttonIndex) {
                                                      if (0 == buttonIndex) {
                                                          [self.match forfeit];
                                                          [[SBMatchService new] saveMatch:self.match];
                                                          [self layoutMatch];
                                                      }
                                                  }
                                           cancelButtonTitle:@"Yes"
                                           otherButtonTitles:@"No", nil];
    }
    [av show];
}

@end
