//
//  SBCreateMatchViewController.m
//  Phage
//
//  Created by Stig Brautaset on 16/08/2012.
//
//

#import "SBCreateMatchViewController.h"
#import "SBMatch.h"
#import "SBHuman.h"
#import "SBPlayerAliasViewController.h"
#import "SBPlayerHelper.h"
#import "SBAnalytics.h"

@interface SBCreateMatchViewController ()
@property (strong, nonatomic) NSArray *titles;
@property (strong, nonatomic) NSArray *players;
@end

@implementation SBCreateMatchViewController


- (void)viewDidLoad {
    [super viewDidLoad];

    self.titles = @[
        NSLocalizedString(@"1 Player Match", @"Create Match Table Section Title"),
        NSLocalizedString(@"2 Player Match", @"Create Match Table Section Title")
    ];

    [SBAnalytics logEvent:@"SHOW_CREATE"];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewDidAppear:animated];

    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    SBPlayerHelper *helper = [SBPlayerHelper helper];
    self.players = @[
        @[
            [helper humanWithAlias:[defaults objectForKey:PLAYER_ONE_ALIAS]],
            [helper defaultBot]
        ],
        @[
            [helper humanWithAlias:[defaults objectForKey:PLAYER_ONE_ALIAS]],
            [helper humanWithAlias:[defaults objectForKey:PLAYER_TWO_ALIAS]]
        ]
    ];

    [self.tableView reloadData];
}

#pragma mark - Data Source

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return [self.titles objectAtIndex:section];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.titles.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    UITableViewCell *cell = nil;
    NSArray *players = [self.players objectAtIndex:indexPath.section];

    if (indexPath.row < players.count) {
        cell = [tableView dequeueReusableCellWithIdentifier:@"PlayerNameCell"];

        cell.textLabel.text = !indexPath.row
            ? NSLocalizedString(@"Player 1", @"Player Number Indicator")
            : NSLocalizedString(@"Player 2", @"Player Number Indicator");

        cell.detailTextLabel.text = [players[indexPath.row] alias];

    } else {
        cell = [tableView dequeueReusableCellWithIdentifier:@"ButtonCell"];

        cell.textLabel.text = !indexPath.section
                ? NSLocalizedString(@"Create 1-player match", @"Create Match Button")
                : NSLocalizedString(@"Create 2-player match", @"Create Match Button");

    }

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSArray *players = [self.players objectAtIndex:indexPath.section];
    if (indexPath.row < players.count) {
        id<SBPlayer> player = [players objectAtIndex:indexPath.row];
        if (player.isHuman) {
            [self performSegueWithIdentifier:@"showPlayerAlias" sender:nil];
        } else {
            [self performSegueWithIdentifier:@"showAiSelector" sender:nil];
        }

    } else {
        id<SBPlayer> one = [players objectAtIndex:0];
        id<SBPlayer> two = [players objectAtIndex:1];
        SBMatch *match = [SBMatch matchWithPlayerOne:one two:two];
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
        [self.delegate createMatchViewController:self didCreateMatch:match];
    }

}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {

    NSIndexPath *path = self.tableView.indexPathForSelectedRow;
    if ([segue.identifier isEqualToString:@"showPlayerAlias"]) {
        NSString *aliasKey = [@[ PLAYER_ONE_ALIAS, PLAYER_TWO_ALIAS] objectAtIndex:path.row];
        [segue.destinationViewController setAliasKey:aliasKey];
    }

    [super prepareForSegue:segue sender:sender];
}


@end
