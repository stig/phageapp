//
//  SBMatchMakerViewController.m
//  Phage
//
//  Created by Stig Brautaset on 16/08/2012.
//
//

#import "SBMatchMakerViewController.h"
#import "SBMatch.h"
#import "SBPlayer.h"
#import "PhageModel.h"

@interface SBMatchMakerViewController () < UITableViewDataSource, UITableViewDelegate >
@property (strong, nonatomic) NSArray *sections;
@property (strong, nonatomic) NSArray *sectionTitles;
@end

@implementation SBMatchMakerViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

    SBMatchService *service = [SBMatchService matchService];
    NSArray *active = [service activeMatches];
    NSArray *inactive = [service inactiveMatches];

    NSMutableArray *matches = [NSMutableArray array];
    NSMutableArray *titles = [NSMutableArray array];

    if (active.count) {
        [matches addObject:active];
        [titles addObject:@"Active Matches"];
    }

    if (inactive.count) {
        [matches addObject:inactive];
        [titles addObject:@"Inactive Matches"];
    }

    self.sections = matches;
    self.sectionTitles = titles;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)done:(id)sender
{
    [self.delegate matchMakerViewControllerDidFinish:self];
}


#pragma mark - Table view data source

- (NSString*)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return self.sectionTitles[section];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.sections.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.sections[section] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"SavedMatchCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
//    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];

    SBMatch *match = self.sections[indexPath.section][indexPath.row];
    cell.textLabel.text = [NSString stringWithFormat:@"%@ vs %@", match.playerOne.alias, match.playerTwo.alias];
    cell.detailTextLabel.text = [match.lastUpdated description];

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

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    SBMatch *match = self.sections[indexPath.section][indexPath.row];
    [self.delegate matchMakerViewController:self didFindMatch:match];
}

- (IBAction)startOnePlayerMatch:(id)sender {
    SBPlayer *bot = [SBPlayer playerWithAlias:@"Sgt Pepper" human:NO];
    SBPlayer *human = [SBPlayer playerWithAlias:@"Player 1" human:YES];
    SBMatch *match = [SBMatch matchWithPlayerOne:human two:bot];
    [self.delegate matchMakerViewController:self didFindMatch:match];
}

- (IBAction)startTwoPlayerMatch:(id)sender {
    SBPlayer *human2 = [SBPlayer playerWithAlias:@"Player 2" human:NO];
    SBPlayer *human = [SBPlayer playerWithAlias:@"Player 1" human:YES];
    SBMatch *match = [SBMatch matchWithPlayerOne:human two:human2];
    [self.delegate matchMakerViewController:self didFindMatch:match];
}

@end
