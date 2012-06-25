//
//  Created by s.brautaset@london.net-a-porter.com on 30/04/2012.
//


#import "PhageRootViewController.h"
#import "SBMatchViewController.h"
#import "SBHuman.h"
#import "SBMatch.h"
#import "SBBot.h"
#import "SBBotTurnEventHandler.h"

@implementation PhageRootViewController


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    [super prepareForSegue:segue sender:sender];

    if ([segue.identifier isEqualToString:@"OnePlayer"]) {
        NSString *suffix = @"_ONE_PLAYER_MATCH";
        [TestFlight passCheckpoint:[@"START" stringByAppendingString:suffix]];

        id<SBPlayer> playerOne = [SBHuman playerWithAlias:@"Human"];
        id<SBPlayer> playerTwo = [SBBot playerWithAlias:@"Bot"];
        SBMatch *match = [SBMatch matchWithPlayerOne:playerOne two:playerTwo];

        SBMatchViewController *vc = segue.destinationViewController;
        vc.delegate = [[SBBotTurnEventHandler alloc] init];
        vc.checkPointSuffix = suffix;
        vc.match = match;

    } else if ([segue.identifier isEqual:@"TwoPlayer"]) {
        NSString *suffix = @"_PASS_TO_PLAY_MATCH";
        [TestFlight passCheckpoint:[@"START" stringByAppendingString:suffix]];

        id<SBPlayer> playerOne = [SBHuman playerWithAlias:@"Player 1"];
        id<SBPlayer> playerTwo = [SBHuman playerWithAlias:@"Player 2"];
        SBMatch *match = [SBMatch matchWithPlayerOne:playerOne two:playerTwo];

        SBMatchViewController *vc = segue.destinationViewController;
        vc.checkPointSuffix = suffix;
        vc.match = match;

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