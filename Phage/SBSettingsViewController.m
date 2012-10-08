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
#import "SBAnalytics.h"

@interface SBSettingsViewController () <MFMailComposeViewControllerDelegate>
@end

@implementation SBSettingsViewController

#pragma mark - Actions

- (NSString *)versionNumberDisplayString {
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    NSString *version = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
    NSString *versionMod = [infoDictionary objectForKey:@"SBBundleShortVersionStringSuffix"];

    NSString *build = [infoDictionary objectForKey:@"CFBundleVersion"];
    return [NSString stringWithFormat:@"%@%@ (%@)", version, versionMod, build];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    switch (section) {
        case 2:
            return NSLocalizedString(@"Need help?", @"Settings section header");
        default:
            return nil;
    }
}

- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section {
    switch (section) {
        case 2:
            return NSLocalizedString(@"We aim to respond in 24 hours", @"Settings section footer");
        default:
            return nil;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    switch (section) {
        case 0:
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
            cell.textLabel.text = 0 == indexPath.row
                    ? NSLocalizedString(@"About", @"Setting title")
                    : NSLocalizedString(@"Legal", @"Setting title");
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

    switch (indexPath.section) {
        case 0: {
            NSString *identifier = 0 == indexPath.row ? @"showAbout" : @"showLegal";
            [self performSegueWithIdentifier:identifier sender:nil];
        }
            break;
        case 2:
            switch (indexPath.row) {
                case 0: {
                    BOOL canSend = YES;
                    if (![TWTweetComposeViewController canSendTweet]) {
                        canSend = NO;
                        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view.window animated:YES];
                        hud.labelText = NSLocalizedString(@"Cannot send tweet", @"Error message");
                        hud.detailsLabelText = NSLocalizedString(@"No Twitter accounts available.", @"Error message detail");
                        hud.mode = MBProgressHUDModeText;
                        [hud hide:YES afterDelay:2.0];
                    } else {
                        TWTweetComposeViewController *ctrl = [[TWTweetComposeViewController alloc] init];
                        [ctrl setInitialText:@"@phageapp "];
                        [self presentViewController:ctrl animated:YES completion:nil];
                    }
                    [SBAnalytics logEvent:@"INITIATE_TWEET_TO_SUPPORT" withParameters:@{ @"CAN_SEND": canSend ? @"YES": @"NO" }];
                }
                    break;
                case 1: {
                    BOOL canSend = YES;
                    if (![MFMailComposeViewController canSendMail]) {
                        canSend = YES;
                        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view.window animated:YES];
                        hud.labelText = NSLocalizedString(@"Cannot send mail", @"Error message");
                        hud.detailsLabelText = NSLocalizedString(@"No Mail accounts set up.", @"Error message detail");
                        hud.mode = MBProgressHUDModeText;
                        [hud hide:YES afterDelay:2.0];
                    } else {
                        MFMailComposeViewController *ctrl = [[MFMailComposeViewController alloc] init];
                        ctrl.mailComposeDelegate = self;
                        [ctrl setToRecipients:@[ [self supportEmailAddress]]];
                        [ctrl setMessageBody:[self createMailBody] isHTML:NO];
                        [self presentViewController:ctrl animated:YES completion:nil];
                    }
                    [SBAnalytics logEvent:@"INITIATE_MAIL_TO_SUPPORT" withParameters:@{ @"CAN_SEND": canSend ? @"YES": @"NO" }];
                }
                    break;
            }
    }
}

- (NSString *)supportEmailAddress {
    return @"support@phageapp.info";
}

- (NSString *)createMailBody {
    NSString *delim = @"~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~";
    NSMutableString *body = [NSMutableString string];
    [body appendFormat:@"\n\n%@\n", delim];
    [body appendString:NSLocalizedString(@"Compose your mail above this section. The below information may help us help you better.", @"Support email text")];
    [body appendFormat:@"\n%@\n\n", delim];
    [body appendFormat:@"Phage Version: %@", [self versionNumberDisplayString]];
    return [body copy];
}


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    [super prepareForSegue:segue sender:sender];

    [SBAnalytics logEvent:[[segue.identifier stringByReplacingOccurrencesOfString:@"show" withString:@"SHOW_"] uppercaseString]];

    if ([segue.identifier isEqualToString:@"showLegal"]) {
        [segue.destinationViewController setDocumentName:@"Legal.html"];

    }
}

- (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result
                        error:(NSError *)error {
    [controller dismissViewControllerAnimated:YES completion:nil];

}


@end
