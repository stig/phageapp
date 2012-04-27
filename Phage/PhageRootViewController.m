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

        SBAITurnBasedMatchHelper *helper = [[SBAITurnBasedMatchHelper alloc] init];
        helper.delegate = vc;

        vc.turnBasedMatchHelper = helper;

    } else if ([segue.identifier isEqualToString:@"TwoPlayer"]) {
        SBViewController *vc = segue.destinationViewController;

        SBGameKitTurnBasedMatchHelperInternal *helper = [[SBGameKitTurnBasedMatchHelperInternal alloc] init];
        helper.presentingViewController = self;

        SBGameKitTurnBasedMatchHelper *adapter = [[SBGameKitTurnBasedMatchHelper alloc] initWithTurnBasedMatchHelper:helper];
        adapter.delegate = self;

        helper.delegate = adapter;
        vc.turnBasedMatchHelper = adapter;

    } else {
        // unhandled yet..
    }
}



@end