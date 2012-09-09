//
// Created by SuperPappi on 03/09/2012.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import "SBAboutViewController.h"

static NSString *const header = @"title";
static NSString *const footer = @"footer";
static NSString *const rows = @"rows";


@interface SBAboutViewController ()
@property (nonatomic, copy) NSArray *dataSource;
@end

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
                @"Sam Dean"
            ],
            footer: NSLocalizedString(@"Names are in alphabetical order", @"About section footer")
        }

    ];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.dataSource.count;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return [[self.dataSource objectAtIndex:section] objectForKey:header];
}

- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section {
    return [[self.dataSource objectAtIndex:section] objectForKey:footer];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self rowsInSection:section].count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"NameCell"];
    cell.textLabel.text = [[self rowsInSection:indexPath.section] objectAtIndex:indexPath.row];
    return cell;
}

- (NSArray *)rowsInSection:(NSInteger)section {
    return [[self.dataSource objectAtIndex:section] objectForKey:rows];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}


@end