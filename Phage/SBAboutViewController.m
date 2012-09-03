//
// Created by SuperPappi on 03/09/2012.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import "SBAboutViewController.h"

static NSString *const title = @"title";
static NSString *const rows = @"rows";


@interface SBAboutViewController ()
@property (nonatomic, copy) NSArray *dataSource;
@end

@implementation SBAboutViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.dataSource = @[
        @{
            title: NSLocalizedString(@"Programming", @"About section header"),
            rows: @[ @"Stig Brautaset" ]
        },
        @{
            title: NSLocalizedString(@"Game Design", @"About section header"),
            rows: @[ @"Steve Gardner" ]
        }
    ];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.dataSource.count;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return [[self.dataSource objectAtIndex:section] objectForKey:title];
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