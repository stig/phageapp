//
// Created by SuperPappi on 03/09/2012.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import "SBAboutViewController.h"

@implementation SBAboutViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.dataSource = @[
        @{
            header: NSLocalizedString(@"Programming", @"About section header"),
            rows: @[ @"Stig Brautaset" ]
        },
        @{
            header: NSLocalizedString(@"Graphics", @"About section header"),
            rows: @[ @"Nadia Brautaset" ]
        },
        @{
            header: NSLocalizedString(@"Game Design", @"About section header"),
            rows: @[ @"Steve Gardner" ]
        },
        @{
            header: NSLocalizedString(@"Acknowledgements", @"About section header"),
            rows: @[
                @"Avon Ho",
                @"Emilio Vacca",
                @"Gareth Potter",
                @"Lee Daffen",
                @"Rufus Cable",
                @"Sam Dean"
            ],
            footer: NSLocalizedString(@"Names are in alphabetical order", @"About section footer")
        }

    ];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"NameCell"];
    cell.textLabel.text = [self itemAtIndexPath:indexPath];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end