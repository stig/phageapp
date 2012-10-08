//
//  SBTableViewController.m
//  
//
//  Created by Stig Brautaset on 09/10/2012.
//
//

#import "SBTableViewController.h"

@implementation SBTableViewController

- (NSArray *)rowsInSection:(NSInteger)section {
    return [[self.dataSource objectAtIndex:section] objectForKey:rows];
}

- (id)itemAtIndexPath:(NSIndexPath *)indexPath {
    return [[self rowsInSection:indexPath.section] objectAtIndex:indexPath.row];
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

@end
