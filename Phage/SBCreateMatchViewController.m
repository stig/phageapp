//
//  SBCreateMatchViewController.m
//  Phage
//
//  Created by Stig Brautaset on 16/08/2012.
//
//

#import "SBCreateMatchViewController.h"
#import "SBMatch.h"
#import "SBPlayer.h"
#import "PhageModel.h"

@interface SBCreateMatchViewController () < UITextFieldDelegate >
@property (weak, nonatomic) IBOutlet UITextField *soloPlayer;
@property (weak, nonatomic) IBOutlet UITextField *onePlayer;
@property (weak, nonatomic) IBOutlet UITextField *twoPlayer;
@property (weak, nonatomic) IBOutlet UISegmentedControl *soloPlayerStarts;
@end

@implementation SBCreateMatchViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)done:(id)sender
{
    [self.delegate createMatchViewControllerDidFinish:self];
}

- (IBAction)startOnePlayerMatch:(id)sender {
    [TestFlight passCheckpoint:@"CREATE_ONE_PLAYER_MATCH"];

    SBPlayer *bot = [SBPlayer playerWithAlias:NSLocalizedString(@"Sgt Pepper", @"Default AI Name") human:NO];
    SBPlayer *human = [SBPlayer playerWithAlias:self.soloPlayer.text human:YES];
    SBMatch *match = 1 == self.soloPlayerStarts.selectedSegmentIndex
            ? [SBMatch matchWithPlayerOne:bot two:human]
            : [SBMatch matchWithPlayerOne:human two:bot];
    [self.delegate createMatchViewController:self didCreateMatch:match];
}

- (IBAction)startTwoPlayerMatch:(id)sender {
    [TestFlight passCheckpoint:@"CREATE_TWO_PLAYER_MATCH"];

    SBPlayer *two = [SBPlayer playerWithAlias:self.twoPlayer.text human:YES];
    SBPlayer *one = [SBPlayer playerWithAlias:self.onePlayer.text human:YES];
    SBMatch *match = [SBMatch matchWithPlayerOne:one two:two];
    [self.delegate createMatchViewController:self didCreateMatch:match];
}

- (void)viewDidUnload {
    [self setSoloPlayer:nil];
    [self setOnePlayer:nil];
    [self setTwoPlayer:nil];
    [self setSoloPlayerStarts:nil];
    [super viewDidUnload];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}


@end
