//
//  Created by s.brautaset@london.net-a-porter.com on 30/04/2012.
//


#import "PhageRootViewController.h"
#import "SBViewController.h"
#import "SBGameKitTurnBasedMatchHelper.h"
#import "SBAITurnBasedMatchHelper.h"

@implementation PhageRootViewController


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    NSLog(@"%s - %@ sender: %@", (char*)_cmd, segue, sender);

    [super prepareForSegue:segue sender:sender];

    if ([segue.identifier isEqualToString:@"OnePlayer"]) {
        SBViewController *vc = segue.destinationViewController;

        TurnBasedMatchHelper *helper = [[TurnBasedMatchHelper alloc] init];
        helper.delegate = vc;

        vc.turnBasedMatchHelper = helper;

    } else if ([segue.identifier isEqualToString:@"TwoPlayer"]) {
        SBViewController *vc = segue.destinationViewController;

        TurnBasedMatchHelper *helper = [[TurnBasedMatchHelper alloc] init];
        helper.delegate = vc;
        helper.presentingViewController = vc;

        vc.turnBasedMatchHelper = helper;

    } else {
        // unhandled yet..
    }
}



@end