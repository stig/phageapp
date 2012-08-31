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

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
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

    }

    return nil;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
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
