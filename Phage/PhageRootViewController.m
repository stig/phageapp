//
//  Created by s.brautaset@london.net-a-porter.com on 30/04/2012.
//


#import "PhageRootViewController.h"
#import "SBViewController.h"
#import "SBGameKitTurnBasedAdapter.h"
#import "SBAITurnBasedAdapter.h"

@implementation PhageRootViewController


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    NSLog(@"%@ - %@", NSStringFromSelector(_cmd), segue.identifier);

    [super prepareForSegue:segue sender:sender];

    if ([segue.identifier hasSuffix:@"Player"]) {
        SBViewController *vc = segue.destinationViewController;
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
    }
}



@end