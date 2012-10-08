//
//  SBRootViewController.m
//  Phage
//
//  Created by Stig Brautaset on 16/08/2012.
//
//

#import "SBRootViewController.h"
#import "SBMatch.h"
#import "SBPlayer.h"
#import "PhageModel.h"
#import "SBMatchViewController.h"
#import "SBCreateMatchViewController.h"
#import "SBAnalytics.h"

@interface SBRootViewController () < SBMatchViewControllerDelegate, SBCreateMatchViewControllerDelegate >
@property (strong, nonatomic) NSDateFormatter *formatter;
@property (strong, nonatomic) NSArray *sections;
@property (strong, nonatomic) NSArray *titles;
@property (strong, nonatomic) NSArray *checkpoints;
@property (strong, nonatomic) SBMatch *currentMatch;
@property (strong, nonatomic) SBMatchService *matchService;
@property (nonatomic) BOOL shouldShowMostRecentlyCreatedActiveMatch;
@end

@implementation SBRootViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.matchService = [SBMatchService matchService];

    self.formatter = [[NSDateFormatter alloc] init];
    self.formatter.dateStyle = NSDateFormatterMediumStyle;
    self.formatter.timeStyle = NSDateFormatterShortStyle;
    self.formatter.doesRelativeDateFormatting = YES;

    self.titles = @[
        NSLocalizedString(@"Active Matches", @"Table Vie Group Title"),
        NSLocalizedString(@"Finished Matches", @"Table View Group Title")
    ];

    self.checkpoints = @[
        @"LOAD_ACTIVE_MATCH",
        @"LOAD_FINISHED_MATCH"
    ];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;

    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;

}

- (void)reloadSections {
    self.sections = @[
        [self.matchService activeMatches],
        [self.matchService inactiveMatches]
    ];
    [self.tableView reloadData];
}

- (void)viewWillAppear:(BOOL)animated {
    [self reloadSections];
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];

    if (self.shouldShowMostRecentlyCreatedActiveMatch) {
        self.shouldShowMostRecentlyCreatedActiveMatch = NO;
        [self showMostRecentlyCreatedActiveMatch];


    } else if (![[self.matchService allMatches] count]) {
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        SBPlayer *one = [SBPlayer playerWithAlias:[defaults objectForKey:PLAYER_ONE_ALIAS] human:YES];
        SBPlayer *two = [SBPlayer playerWithAlias:[defaults objectForKey:SGT_PEPPER_ALIAS] human:NO];
        [self.matchService saveMatch: [SBMatch matchWithPlayerOne:one two:two]];
        [self reloadSections];
        [self showMostRecentlyCreatedActiveMatch];
    }
}

#pragma mark - Segues

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"showMatch"]) {

        NSIndexPath *path = [self.tableView indexPathForSelectedRow];
        self.currentMatch = [[self.sections objectAtIndex:path.section] objectAtIndex:path.row];
        [segue.destinationViewController setMatch:self.currentMatch];
        [segue.destinationViewController setDelegate:self];

        [SBAnalytics logEvent:[self.checkpoints objectAtIndex:path.section]];

    } else if ([segue.identifier isEqualToString:@"showAdd"]) {
        [segue.destinationViewController setDelegate:self];
        [SBAnalytics logEvent:@"SHOW_CREATE"];

    } else if ([segue.identifier isEqualToString:@"showSettings"]) {
        [SBAnalytics logEvent:@"SHOW_SETTINGS"];

    }
}

#pragma mark - Table view data source

- (NSString*)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return [self.titles objectAtIndex:section];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [[self.sections lastObject] count] ? self.sections.count : 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [[self.sections objectAtIndex:section] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"MatchCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];

    SBMatch *match = [[self.sections objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    NSString *fmt = NSLocalizedString(@"%@ vs %@", @"Match Lookup Label Text - player1 vs player2");

    cell.textLabel.text = [NSString stringWithFormat:fmt, match.playerOne.alias, match.playerTwo.alias];
    cell.detailTextLabel.text = [self.formatter stringFromDate:match.lastUpdated];

    return cell;
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }
}
*/

#pragma mark - Match View Controller Delegate

- (void)matchViewController:(SBMatchViewController *)matchViewController didChangeMatch:(SBMatch *)match {
    [self.matchService saveMatch:match];
}

- (void)matchViewController:(SBMatchViewController *)matchViewController didDeleteMatch:(SBMatch *)match {
    [self.matchService deleteMatch:match];
    [self reloadSections];

    [self.navigationController popViewControllerAnimated:YES];
}


#pragma mark - Create Match View Controller Delegate

- (void)createMatchViewController:(SBCreateMatchViewController *)controller didCreateMatch:(SBMatch *)match {
    [self.matchService saveMatch:match];

    self.shouldShowMostRecentlyCreatedActiveMatch = YES;

    [self.navigationController popViewControllerAnimated:YES];

    [SBAnalytics logEvent:@"CREATE_MATCH" withParameters:@{
        @"PLAYER1": match.playerOne.isHuman ? @"HUMAN" : @"SGT_PEPPER",
        @"PLAYER2": match.playerTwo.isHuman ? @"HUMAN" : @"SGT_PEPPER"
    }];

}

- (void)showMostRecentlyCreatedActiveMatch {
    NSIndexPath *path = [NSIndexPath indexPathForRow:0 inSection:0];
    [self.tableView selectRowAtIndexPath:path animated:YES scrollPosition:UITableViewScrollPositionTop];

    [self performSelector:@selector(performSegueWithIdentifier:) withObject:@"showMatch" afterDelay:0.5];
}

- (void)performSegueWithIdentifier:(NSString*)identifier {
    [self performSegueWithIdentifier:identifier sender:nil];
}

@end
