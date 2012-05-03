//
//  Created by stig on 26/04/2012.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import <Foundation/Foundation.h>
#import "SBTurnBasedMatchHelper.h"

@interface SBGameKitTurnBasedAdapter : NSObject < SBTurnBasedMatchHelperAdapter, GKTurnBasedMatchmakerViewControllerDelegate, GKTurnBasedEventHandlerDelegate>
@property(weak) SBTurnBasedMatchHelper *delegate;
@property(weak) UIViewController *presentingViewController;
@end