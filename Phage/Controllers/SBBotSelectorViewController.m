//
// Created by SuperPappi on 08/10/2012.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import "SBBotSelectorViewController.h"
#import "SBPlayer.h"
#import "SBPlayerHelper.h"
#import "SBBot.h"

@interface SBBotSelectorViewController ()
@property (nonatomic, strong) SBPlayerHelper *playerHelper;
@property (nonatomic, strong) SBBot *defaultBot;
@end

@implementation SBBotSelectorViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.playerHelper = [SBPlayerHelper helper];

    self.dataSource = @[
        @{ rows: [self.playerHelper bots] }
    ];

    self.defaultBot = [self.playerHelper defaultBot];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CellIdentifier"];

    SBBot *bot = [self itemAtIndexPath:indexPath];
    cell.textLabel.text = [bot displayName];
    cell.accessoryType = [bot isEqual:self.defaultBot] ? UITableViewCellAccessoryCheckmark : UITableViewCellAccessoryNone;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self.playerHelper setDefaultBot:[self itemAtIndexPath:indexPath]];
    [self.navigationController popViewControllerAnimated:YES];
}

@end