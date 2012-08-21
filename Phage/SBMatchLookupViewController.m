//
//  SBMatchLookupViewController.m
//  Phage
//
//  Created by Stig Brautaset on 16/08/2012.
//
//

#import "SBMatchLookupViewController.h"
#import "SBMatch.h"
#import "SBPlayer.h"
#import "PhageModel.h"

@interface SBMatchLookupViewController () < UITableViewDataSource, UITableViewDelegate >
@property (strong, nonatomic) NSArray *sections;
@property (strong, nonatomic) NSArray *titles;
@end

@implementation SBMatchLookupViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.titles = @[
        NSLocalizedString(@"Active Matches", @"Table Vie Group Title"),
        NSLocalizedString(@"Finished Matches", @"Table View Group Title")
    ];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;

    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

    SBMatchService *service = [SBMatchService matchService];

    self.sections = @[
        [service activeMatches],
        [service inactiveMatches]
    ];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)done:(id)sender
{
    [self.delegate matchLookupViewControllerDidFinish:self];
}


#pragma mark - Table view data source

- (NSString*)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return self.titles[section];
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

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    SBMatch *match = self.sections[indexPath.section][indexPath.row];
    [self.delegate matchLookupViewController:self didFindMatch:match];
}

@end
