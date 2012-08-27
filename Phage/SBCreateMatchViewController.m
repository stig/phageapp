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
#import "SBAlertView.h"

@interface SBCreateMatchViewController ()
@property (strong, nonatomic) NSArray *titles;
@property (strong, nonatomic) NSArray *playerNames;
@end

@implementation SBCreateMatchViewController


- (void)viewDidLoad {
    [super viewDidLoad];

    self.titles = @[
        NSLocalizedString(@"1 Player Match", @"Create Match Table Section Title"),
        NSLocalizedString(@"2 Player Match", @"Create Match Table Section Title")
    ];

    self.playerNames = @[
        [@[
            NSLocalizedString(@"Player 1", @"Human Player Name"),
            NSLocalizedString(@"Sgt Pepper", @"AI Player Name")
        ] mutableCopy],
        [@[
            NSLocalizedString(@"Player 1", @"Human Player Name"),
            NSLocalizedString(@"Player 2", @"Human Player Name")
        ] mutableCopy]
    ];
}

- (IBAction)done:(id)sender
{
    [self dismissModalViewControllerAnimated:YES];
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
    NSArray *names = [self.playerNames objectAtIndex:indexPath.section];

    if (indexPath.row < names.count) {
        NSString *fmt = NSLocalizedString(@"Player %u", @"Player Number Indicator");
        cell = [tableView dequeueReusableCellWithIdentifier:@"PlayerNameCell"];
        cell.textLabel.text = [NSString stringWithFormat:fmt, indexPath.row + 1];
        cell.detailTextLabel.text = [names objectAtIndex:indexPath.row];

    } else {
        NSString *fmt = NSLocalizedString(@"Create %u-Player match", @"Create Match Button");
        cell = [tableView dequeueReusableCellWithIdentifier:@"ButtonCell"];
        cell.textLabel.text = [NSString stringWithFormat:fmt, indexPath.section + 1];
    }

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSArray *names = [self.playerNames objectAtIndex:indexPath.section];
    if (indexPath.row < names.count) {
        [[[SBAlertView alloc] initWithTitle:@"Unimplemented"
                                   message:@"Eventually you'll be able to edit player names, but for now you can't."
                                completion:nil
                         cancelButtonTitle:@"OK"
                         otherButtonTitles:nil] show];

        // TODO: push view controller to edit names
    } else {
        SBPlayer *one = [SBPlayer playerWithAlias:[names objectAtIndex:0] human:YES];
        SBPlayer *two = [SBPlayer playerWithAlias:[names objectAtIndex:1] human:!!indexPath.section];
        SBMatch *match = [SBMatch matchWithPlayerOne:one two:two];
        [self.delegate createMatchViewController:self didCreateMatch:match];
    }

    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}


@end
