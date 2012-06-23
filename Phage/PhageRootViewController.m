//
//  Created by s.brautaset@london.net-a-porter.com on 30/04/2012.
//


#import "PhageRootViewController.h"
#import "SBBoardViewController.h"
#import "SBHumanPlayer.h"
#import "SBPhageMatch.h"

@implementation PhageRootViewController


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    [super prepareForSegue:segue sender:sender];

    if ([segue.identifier isEqual:@"TwoPlayer"]) {
        [TestFlight passCheckpoint:@"START_PASS_TO_PLAY_MATCH"];

        SBHumanPlayer *playerOne = [SBHumanPlayer playerWithAlias:@"Player 1"];
        SBHumanPlayer *playerTwo = [SBHumanPlayer playerWithAlias:@"Player 2"];
        SBPhageMatch *match = [SBPhageMatch matchWithPlayerOne:playerOne two:playerTwo];

        SBBoardViewController *vc = segue.destinationViewController;
        vc.checkPointBaseName = @"PASS_TO_PLAY_MATCH";
        vc.phageMatch = match;

    } else if ([segue.identifier isEqualToString:@"OnePlayer"]) {

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