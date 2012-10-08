//
// Created by SuperPappi on 08/10/2012.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import "SBBotSelectorViewController.h"
#import "SBPlayer.h"
#import "SBPlayerHelper.h"

@interface SBBotSelectorViewController ()
@property (nonatomic, strong) SBPlayerHelper *playerHelper;
@end

@implementation SBBotSelectorViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.playerHelper = [SBPlayerHelper helper];

    self.dataSource = @[
        @{ rows: [self.playerHelper bots] }
    ];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CellIdentifier"];
    cell.textLabel.text = [[self itemAtIndexPath:indexPath] alias];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self.playerHelper setDefaultBot:[self itemAtIndexPath:indexPath]];
    [self.navigationController popViewControllerAnimated:YES];
}

@end