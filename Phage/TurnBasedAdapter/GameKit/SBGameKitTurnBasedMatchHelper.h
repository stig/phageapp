//
//  Created by stig on 26/04/2012.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import <Foundation/Foundation.h>
#import "SBTurnBasedMatchHelper.h"

@interface SBGameKitTurnBasedMatchHelper : NSObject <SBTurnBasedMatchHelper, GKTurnBasedMatchmakerViewControllerDelegate, GKTurnBasedEventHandlerDelegate>
@property(weak) UIViewController *presentingViewController;
@end