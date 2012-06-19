//
//  Created by s.brautaset@london.net-a-porter.com on 30/04/2012.
//


#import "PhageRootViewController.h"
#import "SBBoardViewController.h"
#import "SBGameKitTurnBasedAdapter.h"
#import "SBAITurnBasedAdapter.h"

@implementation PhageRootViewController


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    [super prepareForSegue:segue sender:sender];

    if ([segue.identifier hasSuffix:@"Player"]) {
        SBBoardViewController *vc = segue.destinationViewController;
        SBTurnBasedMatchHelper *helper = [[SBTurnBasedMatchHelper alloc] init];
        helper.delegate = vc;

        if ([segue.identifier hasPrefix:@"One"]) {
            SBAITurnBasedAdapter *adapter = [[SBAITurnBasedAdapter alloc] init];
            adapter.delegate = helper;
            helper.adapter = adapter;

        } else if ([segue.identifier hasPrefix:@"Two"]) {
            SBGameKitTurnBasedAdapter *adapter = [[SBGameKitTurnBasedAdapter alloc] init];
            adapter.delegate = helper;
            adapter.presentingViewController = vc;
            helper.adapter = adapter;
        }
        vc.turnBasedMatchHelper = helper;

    } else if ([segue.identifier isEqualToString:@"HowToPlay"]) {

        [TestFlight passCheckpoint:@"VIEW_HOWTO"];

        NSString *path = [[NSBundle mainBundle] pathForResource:@"HowToPlay" ofType:@"html"];
        NSURL *url = [[NSURL alloc] initFileURLWithPath:path];
        NSURLRequest *request = [NSURLRequest requestWithURL:url];

        UIViewController *vc = segue.destinationViewController;
        [(UIWebView*)vc.view loadRequest:request];

    }
}



- (IBAction)leaveFeedback {
    [TestFlight openFeedbackView];
}

@end