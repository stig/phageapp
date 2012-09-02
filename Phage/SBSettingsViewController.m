//
//  SBSettingsViewController.m
//  Phage
//
//  Created by Stig Brautaset on 25/08/2012.
//
//

#import <Twitter/Twitter.h>
#import <MessageUI/MessageUI.h>
#import "SBSettingsViewController.h"
#import "SBWebViewController.h"
#import "MBProgressHUD.h"

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
    NSLog(@"indexPath = %@", indexPath);

    switch (indexPath.section) {
        case 0:
            [self performSegueWithIdentifier:@"showAbout" sender:nil];
            break;
        case 2:
            switch (indexPath.row) {
                case 0: {
                    if (![TWTweetComposeViewController canSendTweet]) {
                        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view.window animated:YES];
                        hud.labelText = NSLocalizedString(@"Cannot send tweet", @"Error message");
                        hud.detailsLabelText = NSLocalizedString(@"No Twitter accounts available.", @"Error message detail");
                        hud.mode = MBProgressHUDModeText;
                        [hud hide:YES afterDelay:2.0];
                    } else {
                        TWTweetComposeViewController *tcvc = [[TWTweetComposeViewController alloc] init];
                        [tcvc setInitialText:@"@phageapp "];
                        [self presentViewController:tcvc
                                           animated:YES
                                         completion:nil];
                    }
                }
                break;
                case 1: {
                    if (![MFMailComposeViewController canSendMail]) {
                        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view.window animated:YES];
                        hud.labelText = NSLocalizedString(@"Cannot send mail", @"Error message");
                        hud.detailsLabelText = NSLocalizedString(@"No Mail accounts set up.", @"Error message detail");
                        hud.mode = MBProgressHUDModeText;
                        [hud hide:YES afterDelay:2.0];
                    } else {
                        MFMailComposeViewController *ctrl = [[MFMailComposeViewController alloc] init];
                        [ctrl setToRecipients:@[ @"support@phageapp.com"]];
                        [ctrl setMessageBody:@"fi fo fa fum" isHTML:NO];
                        [self presentViewController:ctrl
                                           animated:YES
                                         completion:nil];
                    }
                }
                break;
            }
    }
}


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {

    [super prepareForSegue:segue sender:sender];

    if ([segue.identifier isEqualToString:@"showAbout"]) {
        [segue.destinationViewController setDocumentName:@"About.html"];
        [TestFlight passCheckpoint:@"SHOW_ABOUT"];

    }
}


@end
