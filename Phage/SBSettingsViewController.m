//
//  SBSettingsViewController.m
//  Phage
//
//  Created by Stig Brautaset on 25/08/2012.
//
//

#import "SBSettingsViewController.h"
#import "SBWebViewController.h"

@interface SBSettingsViewController ()
@end

@implementation SBSettingsViewController

#pragma mark - Actions

- (NSString *)versionNumberDisplayString {
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    NSString *majorVersion = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
    NSString *minorVersion = [infoDictionary objectForKey:@"CFBundleVersion"];
    if (1.0 == [minorVersion doubleValue]) {
        return majorVersion;
    }
    return [NSString stringWithFormat:@"%@ (%@)", majorVersion, minorVersion];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    switch (section) {
        case 2:
            return NSLocalizedString(@"Need help?", @"Settings section heading");
        default:
            return nil;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    switch (section) {
        case 2:
            return 2;
        default:
            return 1;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    switch (indexPath.section) {
        case 0: {
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"AboutCell"];
            cell.textLabel.text = NSLocalizedString(@"About", @"Setting title");
            return cell;
        }

        case 1: {
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"RightDetailCell"];
            cell.textLabel.text = NSLocalizedString(@"Version", @"Setting title");
            cell.detailTextLabel.text = [self versionNumberDisplayString];
            return cell;
        }

        case 2: {
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"RightDetailCell"];
            if (0 == indexPath.row) {
                cell.textLabel.text = NSLocalizedString(@"Twitter", @"Setting title");
                cell.detailTextLabel.text = @"@phageapp";
            } else {
                cell.textLabel.text = NSLocalizedString(@"Email", @"Setting title");
                cell.detailTextLabel.text = @"support@phageapp.info";
            }
            return cell;
        }

    }

    return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

    if (0 == indexPath.section)
        [self performSegueWithIdentifier:@"showAbout" sender:nil];
}


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {

    [super prepareForSegue:segue sender:sender];

    if ([segue.identifier isEqualToString:@"showAbout"]) {
        [segue.destinationViewController setDocumentName:@"About.html"];
        [TestFlight passCheckpoint:@"SHOW_ABOUT"];

    }
}


@end
