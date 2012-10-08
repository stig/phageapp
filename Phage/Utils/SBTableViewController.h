//
//  SBTableViewController.h
//  
//
//  Created by Stig Brautaset on 09/10/2012.
//
//

static NSString *const header = @"title";
static NSString *const footer = @"footer";
static NSString *const rows = @"rows";

@interface SBTableViewController : UITableViewController
@property(nonatomic, strong) NSArray *dataSource;
- (NSArray *)rowsInSection:(NSInteger)section;

- (id)itemAtIndexPath:(NSIndexPath *)indexPath;

@end
