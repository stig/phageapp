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
#import "SBPlayerAliasViewController.h"

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

    self.players = @[
    @[
    @{ @"aliasKey": PLAYER_ONE_ALIAS, @"human": @(YES) },
    @{ @"aliasKey": SGT_PEPPER_ALIAS, @"human": @(NO) }
    ],
    @[
    @{ @"aliasKey": PLAYER_ONE_ALIAS, @"human": @(YES) },
    @{ @"aliasKey": PLAYER_TWO_ALIAS, @"human": @(YES) }
    ]
    ];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewDidAppear:animated];
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
            ? NSLocalizedString(@"First player", @"Player Number Indicator")
            : NSLocalizedString(@"Second player", @"Player Number Indicator");


        NSString *aliasKey = [[players objectAtIndex:indexPath.row] objectForKey:@"aliasKey"];
        NSString *alias = [[NSUserDefaults standardUserDefaults] objectForKey:aliasKey];

        cell.detailTextLabel.text = alias;

        cell.accessoryType = 0 == indexPath.section && 1 == indexPath.row
                ? UITableViewCellAccessoryNone
                : UITableViewCellAccessoryDisclosureIndicator;

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
        NSDictionary *player = [players objectAtIndex:indexPath.row];
        if ([[player objectForKey:@"human"] boolValue]) {
            [self performSegueWithIdentifier:@"showPlayerAlias" sender:nil];
        } else {
            [tableView deselectRowAtIndexPath:indexPath animated:YES];
        }

    } else {
        SBPlayer *one = [self createPlayer:[players objectAtIndex:0]];
        SBPlayer *two = [self createPlayer:[players objectAtIndex:1]];
        SBMatch *match = [SBMatch matchWithPlayerOne:one two:two];
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
        [self.delegate createMatchViewController:self didCreateMatch:match];
    }

}

- (SBPlayer *)createPlayer:(NSDictionary *)dict {
    NSString *aliasKey = [dict objectForKey:@"aliasKey"];
    NSString *alias = [[NSUserDefaults standardUserDefaults] objectForKey:aliasKey];
    return [SBPlayer playerWithAlias:alias human:[[dict objectForKey:@"human"] boolValue]];
}


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {

    NSIndexPath *path = self.tableView.indexPathForSelectedRow;
    NSString *aliasKey = [[[self.players objectAtIndex:path.section] objectAtIndex:path.row] objectForKey:@"aliasKey"];

    [segue.destinationViewController setAliasKey:aliasKey];

    [super prepareForSegue:segue sender:sender];
}


@end
